import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/noise_meter/data/repositories/acoustic_repository_impl.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/domain/repositories/acoustic_repository.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/enhanced_noise_data.dart';

import '../../services/acoustic_report_service.dart';

/// Provider for the enhanced noise meter notifier
final enhancedNoiseMeterProvider =
    StateNotifierProvider<EnhancedNoiseMeterNotifier, EnhancedNoiseMeterData>((
      ref,
    ) {
      final repository = ref.watch(acousticRepositoryProvider);
      return EnhancedNoiseMeterNotifier(repository);
    });

/// Controller for the entire noise meter feature.
/// This class orchestrates the data flow from the repository and applies business logic
/// to produce the state for the UI.
class EnhancedNoiseMeterNotifier extends StateNotifier<EnhancedNoiseMeterData> {
  final AcousticRepository _repository;
  StreamSubscription<NoiseData>? _noiseSubscription;
  Timer? _sessionTimer;
  Timer? _eventDetectionTimer;
  Timer? _uiUpdateTimer;

  // Event detection state
  double? _previousReading;
  DateTime? _eventStartTime;
  double? _eventPeakDb;
  bool _isInEvent = false;

  // --- State not exposed to UI to prevent desync ---
  double _runningSum = 0.0;
  int _totalReadings = 0;
  DateTime? _lastUiUpdate;

  EnhancedNoiseMeterNotifier(this._repository)
      : super(const EnhancedNoiseMeterData()) {
    _checkPermission();
  }
  Future<void> _checkPermission() async {
    final hasPermission = await _repository.checkPermission();
    state = state.copyWith(hasPermission: hasPermission);
  }

  Future<void> startRecordingWithPreset(
    RecordingPreset preset, {
    Duration? customDuration,
  }) async {
    if (!state.hasPermission) {
      final hasPermission = await _repository.requestPermission();
      if (!hasPermission) {
        state = state.copyWith(errorMessage: 'Microphone permission required');
        return;
      }
      state = state.copyWith(hasPermission: true);
    }

    try {
      // Reset internal state
      _runningSum = 0.0;
      _totalReadings = 0;
      _lastUiUpdate = null;

      state = EnhancedNoiseMeterData(
        hasPermission: true,
        isRecording: true,
        activePreset: preset,
        customPresetDuration: customDuration,
        sessionStartTime: DateTime.now(),
        savedReports: state.savedReports, // Preserve existing reports
      );

      _noiseSubscription = _repository.noiseStream.listen(
        _onNoiseReading,
        onError: (error) =>
            state = state.copyWith(errorMessage: 'Error: $error'),
      );

      _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        final newDuration = state.sessionDuration + const Duration(seconds: 1);
        state = state.copyWith(sessionDuration: newDuration);

        // Check if we should stop based on preset duration
        final targetDuration =
            preset == RecordingPreset.custom && customDuration != null
                ? customDuration
                : _getPresetDuration(preset);

        // Stop if we have a valid duration and reached it
        if (targetDuration != Duration.zero && newDuration >= targetDuration) {
          stopRecording();
        }
      });

      _eventDetectionTimer = Timer.periodic(
        const Duration(milliseconds: 500),
        _detectEvents,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to start: $e');
    }
  }

  void _onNoiseReading(NoiseData data) {
    final db = data.meanDecibel;

    // --- Data Validation ---
    // Ensure the reading is a valid, finite number before processing.
    // Invalid readings can corrupt the entire session's statistics.
    if (db.isInfinite || db.isNaN) {
      // Optionally, log this event for debugging.
      // print('Skipping invalid noise reading: $db');
      return;
    }

    final now = DateTime.now();

    // --- Critical state updates that must happen on every reading ---
    _runningSum += db;
    _totalReadings++;

    // Throttle UI updates to prevent performance issues
    final shouldUpdateUi = _lastUiUpdate == null ||
        now.difference(_lastUiUpdate!).inMilliseconds >= 100;

    if (!shouldUpdateUi) {
      // Even if we don't update the UI, we must update min/max in the state
      // so that the final report is accurate.
      final newMin = _totalReadings == 1
          ? db
          : (db < state.minDecibels ? db : state.minDecibels);
      final newMax = _totalReadings == 1
          ? db
          : (db > state.maxDecibels ? db : state.maxDecibels);
      if (newMin != state.minDecibels || newMax != state.maxDecibels) {
        state = state.copyWith(minDecibels: newMin, maxDecibels: newMax);
      }
      return;
    }

    // --- UI update logic ---
    _lastUiUpdate = now;

    final newAverage = _totalReadings > 0 ? _runningSum / _totalReadings : 0.0;

    final newMin = _totalReadings == 1
        ? db
        : (db < state.minDecibels ? db : state.minDecibels);
    final newMax = _totalReadings == 1
        ? db
        : (db > state.maxDecibels ? db : state.maxDecibels);

    // Keep limited history for chart
    final updatedHistory = [...state.decibelHistory, db];
    if (updatedHistory.length > 100) {
      updatedHistory.removeRange(0, updatedHistory.length - 100);
    }

    // Store samples for report (downsample to keep memory usage low)
    final shouldStoreSample = _totalReadings % 10 == 0;
    final allReadings =
        shouldStoreSample ? [...state.allReadings, db] : state.allReadings;
    if (allReadings.length > 1000) {
      allReadings.removeRange(0, allReadings.length - 1000);
    }

    state = state.copyWith(
      currentDecibels: db,
      minDecibels: newMin,
      maxDecibels: newMax,
      averageDecibels: newAverage,
      noiseLevel: _getNoiseLevel(db),
      decibelHistory: updatedHistory,
      allReadings: allReadings,
      totalReadings: _totalReadings, // Update UI with the correct total
      timeInLevels: {
        ...state.timeInLevels,
        _getNoiseLevel(db).name:
            (state.timeInLevels[_getNoiseLevel(db).name] ?? 0) + 1,
      },
    );
    _previousReading = db;
  }

  void _detectEvents(Timer timer) {
    final currentDb = state.currentDecibels;
    const loudThreshold = 65.0;
    if (!_isInEvent && currentDb > loudThreshold) {
      _isInEvent = true;
      _eventStartTime = DateTime.now();
      _eventPeakDb = currentDb;
    } else if (_isInEvent) {
      if (currentDb > (_eventPeakDb ?? 0)) _eventPeakDb = currentDb;
      if (currentDb < loudThreshold) {
        final duration = DateTime.now().difference(_eventStartTime!);
        if (duration.inSeconds >= 1) {
          state = state.copyWith(
            events: [
              ...state.events,
              AcousticEvent(
                timestamp: _eventStartTime!,
                peakDecibels: _eventPeakDb!,
                duration: duration,
                eventType: _determineEventType(duration),
              ),
            ],
          );
        }
        _isInEvent = false;
      }
    }
  }

  Future<AcousticReport?> stopRecording() async {
    state = state.copyWith(isRecording: false, isAnalyzing: true);

    // Generate the report BEFORE cleaning up
    final report = _generateReport();

    // Now cleanup timers and subscriptions
    _cleanupTimersAndSubscriptions();

    try {
      await _repository.saveReport(report);
      final reports = await _repository.getReports();
      state = state.copyWith(
        savedReports: reports,
        isAnalyzing: false,
        lastGeneratedReport: report,
      );
      return report;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to save report: $e',
        isAnalyzing: false,
      );
      return null;
    }
  }

  Future<void> loadSavedReports() async {
    try {
      final reports = await _repository.getReports();
      state = state.copyWith(savedReports: reports);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to load reports: $e');
    }
  }

  Future<void> deleteReport(String reportId) async {
    try {
      await _repository.deleteReport(reportId);
      state = state.copyWith(
        savedReports:
            state.savedReports.where((r) => r.id != reportId).toList(),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to delete report: $e');
    }
  }

  AcousticReport _generateReport() {
    final hourlyAvgs = <double>[];
    if (state.allReadings.isNotEmpty && state.sessionDuration.inHours > 0) {
      final readingsPerHour =
          state.allReadings.length / state.sessionDuration.inHours;
      for (int h = 0; h < state.sessionDuration.inHours; h++) {
        final start = (h * readingsPerHour).toInt();
        final end = ((h + 1) * readingsPerHour).toInt();
        if (end <= state.allReadings.length) {
          final hourReadings = state.allReadings.sublist(start, end);
          final avg =
              hourReadings.reduce((a, b) => a + b) / hourReadings.length;
          hourlyAvgs.add(avg);
        }
      }
    }

    final now = DateTime.now();

    // --- Use the accurate, internal state for the report ---
    final actualAverage =
        _totalReadings > 0 ? _runningSum / _totalReadings : 0.0;

    final validAverage = actualAverage.isNaN || actualAverage.isInfinite
        ? 0.0
        : actualAverage;

    final validMin =
        state.minDecibels == double.infinity ? 0.0 : state.minDecibels;
    final validMax = state.maxDecibels == double.negativeInfinity
        ? 0.0
        : state.maxDecibels;

    final environmentQuality = _calculateEnvironmentQuality(validAverage);
    final recommendation = _getRecommendation(validAverage);

    return AcousticReport(
      startTime: state.sessionStartTime ?? now,
      endTime: now,
      duration: state.sessionDuration,
      preset: state.activePreset ?? RecordingPreset.custom,
      averageDecibels: validAverage,
      minDecibels: validMin,
      maxDecibels: validMax,
      events: state.events,
      timeInLevels: state.timeInLevels,
      hourlyAverages: hourlyAvgs,
      environmentQuality: environmentQuality,
      recommendation: recommendation,
      id: now.millisecondsSinceEpoch.toString(),
    );
  }

  String _calculateEnvironmentQuality(double averageDecibels) {
    if (averageDecibels <= 35) return 'excellent';
    if (averageDecibels <= 50) return 'good';
    if (averageDecibels <= 65) return 'fair';
    return 'poor';
  }

  String _getRecommendation(double averageDecibels) {
    if (state.activePreset == RecordingPreset.sleep) {
      if (averageDecibels <= 30) return 'Perfect sleep environment!';
      if (averageDecibels <= 40) return 'Good sleep environment.';
      return 'Too noisy for quality sleep.';
    } else if (state.activePreset == RecordingPreset.work ||
        state.activePreset == RecordingPreset.focus) {
      if (averageDecibels <= 45) return 'Ideal for focus work!';
      if (averageDecibels <= 55) return 'Good for most work.';
      return 'Too loud for focused work.';
    }
    return 'Monitor your environment to optimize for your needs.';
  }

  Duration _getPresetDuration(RecordingPreset preset) {
    switch (preset) {
      case RecordingPreset.sleep:
        return const Duration(hours: 8);
      case RecordingPreset.work:
        return const Duration(hours: 1);
      case RecordingPreset.focus:
        return const Duration(minutes: 30);
      case RecordingPreset.custom:
        return Duration.zero;
    }
  }

  String _determineEventType(Duration duration) {
    if (duration.inSeconds < 3) return 'spike';
    if (duration.inSeconds < 10) return 'intermittent';
    return 'sustained';
  }

  NoiseLevel _getNoiseLevel(double db) {
    if (db < 30) return NoiseLevel.quiet;
    if (db < 60) return NoiseLevel.moderate;
    if (db < 85) return NoiseLevel.loud;
    if (db < 100) return NoiseLevel.veryLoud;
    return NoiseLevel.dangerous;
  }

  void _cleanupTimersAndSubscriptions() {
    _noiseSubscription?.cancel();
    _sessionTimer?.cancel();
    _eventDetectionTimer?.cancel();
    _uiUpdateTimer?.cancel();
    _noiseSubscription = null;
    _sessionTimer = null;
    _eventDetectionTimer = null;
    _uiUpdateTimer = null;
    _isInEvent = false;

    // Reset internal state
    _runningSum = 0.0;
    _totalReadings = 0;
    _lastUiUpdate = null;
  }

  @override
  void dispose() {
    _cleanupTimersAndSubscriptions();
    super.dispose();
  }
}

final reportStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'total': AcousticReportService.reportCount,
    'averageQuality': AcousticReportService.averageQualityScore.toInt(),
    'sleepStats': AcousticReportService.getPresetStatistics(
      RecordingPreset.sleep,
    ),
    'workStats': AcousticReportService.getPresetStatistics(
      RecordingPreset.work,
    ),
    'focusStats': AcousticReportService.getPresetStatistics(
      RecordingPreset.focus,
    ),
  };
});