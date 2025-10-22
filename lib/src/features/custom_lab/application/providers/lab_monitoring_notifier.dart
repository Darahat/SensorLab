import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/application/state/lab_monitoring_state.dart';
import 'package:sensorlab/src/features/custom_lab/data/providers/lab_repository_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';
import 'package:sensorlab/src/features/custom_lab/domain/use_cases/add_data_point_use_case.dart';
import 'package:sensorlab/src/features/custom_lab/domain/use_cases/pause_lab_session_use_case.dart';
import 'package:sensorlab/src/features/custom_lab/domain/use_cases/resume_lab_session_use_case.dart';
import 'package:sensorlab/src/features/custom_lab/domain/use_cases/start_lab_session_use_case.dart';
import 'package:sensorlab/src/features/custom_lab/domain/use_cases/stop_lab_session_use_case.dart';

/// Manages the state and logic for a custom lab monitoring session.
class LabMonitoringNotifier extends StateNotifier<LabMonitoringState> {
  final LabRepository _repository;
  final StartLabSessionUseCase _startLabSession;
  final StopLabSessionUseCase _stopLabSession;
  final PauseLabSessionUseCase _pauseLabSession;
  final ResumeLabSessionUseCase _resumeLabSession;
  final AddDataPointUseCase _addDataPoint;
  final Ref _ref; // To access other providers like sensorTimeSeriesProvider

  StreamSubscription<Map<String, dynamic>>? _sensorStreamSubscription;
  Timer? _sessionTimer;

  // Store current sensor data for saving (not for UI updates)
  final Map<String, dynamic> _currentSensorData = {};

  // Throttle sensor data - track last update time per sensor
  final Map<String, DateTime> _lastSensorUpdate = {};
  static const _sensorThrottleMs =
      200; // Accept data max every 200ms per sensor

  LabMonitoringNotifier(
    this._repository,
    this._startLabSession,
    this._stopLabSession,
    this._pauseLabSession,
    this._resumeLabSession,
    this._addDataPoint,
    this._ref,
  ) : super(const LabMonitoringState());

  Future<bool> startSession({required Lab lab}) async {
    if (state.isRecording) return false;

    try {
      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      final newSession = await _startLabSession(lab: lab, sessionId: sessionId);

      state = state.copyWith(
        isRecording: true,
        isPaused: false,
        activeLab: lab,
        activeSession: newSession,
        elapsedSeconds: 0,
        errorMessage: null,
      );

      _startSensorDataCollection(lab);
      _startSessionTimer();
      return true;
    } catch (e) {
      AppLogger.log('Error starting lab session: $e', level: LogLevel.error);
      state = state.copyWith(errorMessage: 'Failed to start session: $e');
      return false;
    }
  }

  void _startSensorDataCollection(Lab lab) {
    // Clear any previous data for all sensors when starting a new session
    for (final sensor in lab.sensors) {
      _ref.read(sensorTimeSeriesProvider(sensor).notifier).clear();
    }

    // Subscribe to real sensor streams based on selected sensors
    // We'll combine all sensor streams into one for simplicity here,
    // or manage individual subscriptions if needed.
    // For now, let's assume we get a combined stream or manage individually.
    // This part needs careful implementation based on how getSensorStream works.

    // For now, let's iterate through each sensor and subscribe individually
    for (final sensor in lab.sensors) {
      final sensorKey = sensor.name;
      _sensorStreamSubscription = _repository
          .getSensorStream(sensor)
          .listen(
            (data) {
              _onSensorData(sensor, data);
            },
            onError: (error) {
              AppLogger.log(
                'Sensor stream error for $sensorKey: $error',
                level: LogLevel.error,
              );
              state = state.copyWith(errorMessage: 'Sensor error: $error');
            },
            onDone: () {
              AppLogger.log(
                'Sensor stream for $sensorKey done',
                level: LogLevel.info,
              );
            },
          );
    }
  }

  void _onSensorData(SensorType sensor, Map<String, dynamic> data) {
    final sensorKey = sensor.name;
    // Throttle: only accept data every 200ms per sensor
    final now = DateTime.now();
    final lastUpdate = _lastSensorUpdate[sensorKey];
    if (lastUpdate != null) {
      final timeSinceLastUpdate = now.difference(lastUpdate).inMilliseconds;
      if (timeSinceLastUpdate < _sensorThrottleMs) {
        // Skip this update - too soon since last one
        return;
      }
    }
    _lastSensorUpdate[sensorKey] = now;

    // Update current sensor data for saving
    _currentSensorData.addAll(data);

    // Add to time series for graphing via provider (assuming data contains a single value for graph)
    // This part needs to be generic enough to extract the graphable value.
    // For now, let's assume the map contains a key that matches the sensorKey and its value is the graphable double.
    if (data.containsKey(sensorKey) && data[sensorKey] is double) {
      _ref
          .read(sensorTimeSeriesProvider(sensor).notifier)
          .addDataPoint(data[sensorKey] as double);
    }
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isRecording && !state.isPaused) {
        state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
        // Periodically save data points
        if (state.elapsedSeconds %
                (state.activeLab?.recordingInterval ?? 1000) ==
            0) {
          _collectAndSaveSensorData();
        }
      }
    });
  }

  Future<void> _collectAndSaveSensorData() async {
    if (state.activeSession == null) return;

    // Only collect data from real sensor streams
    final sensorData = Map<String, dynamic>.from(_currentSensorData);

    // Only save if we have actual sensor data
    if (sensorData.isEmpty) {
      AppLogger.log(
        'No sensor data to save - all sensors may be unavailable',
        level: LogLevel.warning,
      );
      return;
    }

    await _addDataPoint(
      sessionId: state.activeSession!.id,
      dataPoint: sensorData,
    );

    state = state.copyWith(
      activeSession: state.activeSession!.copyWith(
        dataPointsCount: state.activeSession!.dataPointsCount + 1,
      ),
    );
  }

  Future<void> pauseSession() async {
    if (!state.isRecording || state.isPaused) return;
    if (state.activeSession == null) return;

    try {
      await _pauseLabSession(state.activeSession!);
      state = state.copyWith(isPaused: true);
    } catch (e) {
      AppLogger.log('Error pausing lab session: $e', level: LogLevel.error);
      state = state.copyWith(errorMessage: 'Failed to pause session: $e');
    }
  }

  Future<void> resumeSession() async {
    if (!state.isRecording || !state.isPaused) return;
    if (state.activeSession == null) return;

    try {
      await _resumeLabSession(state.activeSession!);
      state = state.copyWith(isPaused: false);
    } catch (e) {
      AppLogger.log('Error resuming lab session: $e', level: LogLevel.error);
      state = state.copyWith(errorMessage: 'Failed to resume session: $e');
    }
  }

  Future<void> stopSession() async {
    if (!state.isRecording && !state.isPaused) return;
    if (state.activeSession == null) return;

    try {
      await _stopLabSession(state.activeSession!);
      _cleanupSession();
      state = state.copyWith(
        isRecording: false,
        isPaused: false,
        activeLab: null,
        activeSession: null,
        elapsedSeconds: 0,
      );
    } catch (e) {
      AppLogger.log('Error stopping lab session: $e', level: LogLevel.error);
      state = state.copyWith(errorMessage: 'Failed to stop session: $e');
    }
  }

  void _cleanupSession() {
    _sensorStreamSubscription?.cancel();
    _sessionTimer?.cancel();
    _currentSensorData.clear();
    _lastSensorUpdate.clear();
    // Also clear all sensorTimeSeriesProviders
    for (final sensor in state.activeLab?.sensors ?? []) {
      _ref.read(sensorTimeSeriesProvider(sensor).notifier).clear();
    }
  }

  @override
  void dispose() {
    _cleanupSession();
    super.dispose();
  }
}

final labMonitoringNotifierProvider =
    StateNotifierProvider.autoDispose<
      LabMonitoringNotifier,
      LabMonitoringState
    >(
      (ref) => LabMonitoringNotifier(
        ref.read(labRepositoryProvider),
        ref.read(startLabSessionUseCaseProvider),
        ref.read(stopLabSessionUseCaseProvider),
        ref.read(pauseLabSessionUseCaseProvider),
        ref.read(resumeLabSessionUseCaseProvider),
        ref.read(addDataPointUseCaseProvider),
        ref,
      ),
    );
