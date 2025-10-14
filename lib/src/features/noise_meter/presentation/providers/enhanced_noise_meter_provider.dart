import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensorlab/src/features/noise_meter/models/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/services/acoustic_report_service.dart';

/// Enhanced noise meter provider with acoustic analysis and Hive persistence
class EnhancedNoiseMeterNotifier extends StateNotifier<EnhancedNoiseMeterData> {
  StreamSubscription<NoiseReading>? _noiseSubscription;
  Timer? _sessionTimer;
  Timer? _eventDetectionTimer;

  // Event detection state
  double? _previousReading;
  DateTime? _eventStartTime;
  double? _eventPeakDb;
  bool _isInEvent = false;

  EnhancedNoiseMeterNotifier() : super(const EnhancedNoiseMeterData()) {
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.microphone.status;
    state = state.copyWith(hasPermission: status.isGranted);
  }

  /// Start recording with a preset
  Future<void> startRecordingWithPreset(RecordingPreset preset) async {
    if (!state.hasPermission) {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        state = state.copyWith(errorMessage: 'Microphone permission required');
        return;
      }
      state = state.copyWith(hasPermission: true);
    }

    try {
      final noiseMeter = NoiseMeter();

      // Reset state for new session
      state = EnhancedNoiseMeterData(
        hasPermission: true,
        isRecording: true,
        activePreset: preset,
        sessionStartTime: DateTime.now(),
        sessionDuration: Duration.zero,
        events: [],
        allReadings: [],
        timeInLevels: {
          'quiet': 0,
          'moderate': 0,
          'loud': 0,
          'veryLoud': 0,
          'dangerous': 0,
        },
      );

      // Start noise monitoring
      _noiseSubscription = noiseMeter.noise.listen(
        _onNoiseReading,
        onError: (error) {
          state = state.copyWith(
            errorMessage: 'Error reading noise: $error',
            isRecording: false,
          );
        },
        cancelOnError: false,
      );

      // Start session duration timer
      _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final newDuration = state.sessionDuration + const Duration(seconds: 1);
        state = state.copyWith(sessionDuration: newDuration);

        // Check if preset duration reached
        if (preset != RecordingPreset.custom) {
          final targetDuration = state.getPresetDuration(preset);
          if (newDuration >= targetDuration) {
            stopRecording();
          }
        }
      });

      // Start event detection timer
      _eventDetectionTimer = Timer.periodic(
        const Duration(milliseconds: 500),
        _detectEvents,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to start recording: $e',
        isRecording: false,
      );
    }
  }

  /// Handle noise reading
  void _onNoiseReading(NoiseReading reading) {
    final db = reading.meanDecibel;

    // Update current readings
    final newReadings = [...state.recentReadings, db];
    if (newReadings.length > 100) {
      newReadings.removeAt(0);
    }

    // Update decibel history for chart (keep last 100)
    final decibelHistory = [...state.decibelHistory, db];
    if (decibelHistory.length > 100) {
      decibelHistory.removeAt(0);
    }

    // Store all readings for report
    final allReadings = [...state.allReadings, db];

    // Calculate statistics
    final totalReadings = state.totalReadings + 1;
    final newMin = state.minDecibels == double.infinity
        ? db
        : db < state.minDecibels
        ? db
        : state.minDecibels;
    final newMax = state.maxDecibels == double.negativeInfinity
        ? db
        : db > state.maxDecibels
        ? db
        : state.maxDecibels;

    // Calculate running average
    final newAvg =
        ((state.averageDecibels * state.totalReadings) + db) / totalReadings;

    // Determine noise level
    final noiseLevel = _getNoiseLevel(db);

    // Update time in levels
    final timeInLevels = Map<String, int>.from(state.timeInLevels);
    final levelKey = noiseLevel.name;
    timeInLevels[levelKey] = (timeInLevels[levelKey] ?? 0) + 1;

    state = state.copyWith(
      currentDecibels: db,
      minDecibels: newMin,
      maxDecibels: newMax,
      averageDecibels: newAvg,
      noiseLevel: noiseLevel,
      recentReadings: newReadings,
      decibelHistory: decibelHistory,
      allReadings: allReadings,
      totalReadings: totalReadings,
      timeInLevels: timeInLevels,
      errorMessage: null,
    );

    _previousReading = db;
  }

  /// Detect acoustic events (loud interruptions)
  void _detectEvents(Timer timer) {
    if (_previousReading == null) return;

    final currentDb = state.currentDecibels;
    const loudThreshold = 65.0; // dB
    const spikeThreshold = 10.0; // dB change

    // Check if we're entering an event
    if (!_isInEvent && currentDb > loudThreshold) {
      _isInEvent = true;
      _eventStartTime = DateTime.now();
      _eventPeakDb = currentDb;
    }

    // Update peak during event
    if (_isInEvent && currentDb > (_eventPeakDb ?? 0)) {
      _eventPeakDb = currentDb;
    }

    // Check if event ended
    if (_isInEvent && currentDb < loudThreshold) {
      if (_eventStartTime != null && _eventPeakDb != null) {
        final duration = DateTime.now().difference(_eventStartTime!);

        // Only record events longer than 1 second
        if (duration.inSeconds >= 1) {
          final eventType = _determineEventType(_eventPeakDb!, duration);

          final event = AcousticEvent(
            timestamp: _eventStartTime!,
            peakDecibels: _eventPeakDb!,
            duration: duration,
            eventType: eventType,
          );

          final events = [...state.events, event];
          state = state.copyWith(events: events);
        }
      }

      _isInEvent = false;
      _eventStartTime = null;
      _eventPeakDb = null;
    }
  }

  /// Determine event type
  String _determineEventType(double peakDb, Duration duration) {
    if (duration.inSeconds < 3) {
      return 'spike'; // Quick loud noise
    } else if (duration.inSeconds < 10) {
      return 'intermittent'; // Medium duration
    } else {
      return 'sustained'; // Long duration
    }
  }

  /// Get noise level from decibels
  NoiseLevel _getNoiseLevel(double db) {
    if (db < 30) return NoiseLevel.quiet;
    if (db < 60) return NoiseLevel.moderate;
    if (db < 85) return NoiseLevel.loud;
    if (db < 100) return NoiseLevel.veryLoud;
    return NoiseLevel.dangerous;
  }

  /// Stop recording and generate report
  Future<AcousticReport?> stopRecording() async {
    _noiseSubscription?.cancel();
    _sessionTimer?.cancel();
    _eventDetectionTimer?.cancel();

    _noiseSubscription = null;
    _sessionTimer = null;
    _eventDetectionTimer = null;
    _isInEvent = false;
    _eventStartTime = null;
    _eventPeakDb = null;

    state = state.copyWith(isRecording: false, isAnalyzing: true);

    // Generate report
    final report = state.generateReport();

    // Save to Hive database
    try {
      await AcousticReportService.saveReport(report);

      // Add to saved reports in state
      final savedReports = [...state.savedReports, report];
      state = state.copyWith(
        savedReports: savedReports,
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

  /// Load saved reports from Hive
  Future<void> loadSavedReports() async {
    try {
      final reports = AcousticReportService.getReportsSorted();
      state = state.copyWith(savedReports: reports);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to load reports: $e');
    }
  }

  /// Delete a report
  Future<void> deleteReport(String reportId) async {
    try {
      await AcousticReportService.deleteReport(reportId);
      final reports = state.savedReports
          .where((r) => r.id != reportId)
          .toList();
      state = state.copyWith(savedReports: reports);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to delete report: $e');
    }
  }

  /// Clear all reports
  Future<void> clearAllReports() async {
    try {
      await AcousticReportService.deleteAllReports();
      state = state.copyWith(savedReports: []);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to clear reports: $e');
    }
  }

  /// Reset current session
  void resetSession() {
    _noiseSubscription?.cancel();
    _sessionTimer?.cancel();
    _eventDetectionTimer?.cancel();

    state = EnhancedNoiseMeterData(
      hasPermission: state.hasPermission,
      savedReports: state.savedReports,
    );
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    _sessionTimer?.cancel();
    _eventDetectionTimer?.cancel();
    super.dispose();
  }
}

/// Provider for enhanced noise meter
final enhancedNoiseMeterProvider =
    StateNotifierProvider<EnhancedNoiseMeterNotifier, EnhancedNoiseMeterData>(
      (ref) => EnhancedNoiseMeterNotifier(),
    );

/// Provider for report statistics
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
