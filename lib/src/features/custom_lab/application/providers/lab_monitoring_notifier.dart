import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/providers.dart'; // Import core sensor providers
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/recording_session_provider.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/application/state/lab_monitoring_state.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/custom_lab/domain/use_cases/add_data_point_use_case.dart';
import 'package:sensorlab/src/features/custom_lab/domain/use_cases/pause_lab_session_use_case.dart';
import 'package:sensorlab/src/features/custom_lab/domain/use_cases/resume_lab_session_use_case.dart';
import 'package:sensorlab/src/features/custom_lab/domain/use_cases/start_lab_session_use_case.dart';
import 'package:sensorlab/src/features/custom_lab/domain/use_cases/stop_lab_session_use_case.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart'
    as entities;

/// Manages the state and logic for a custom lab monitoring session.
class LabMonitoringNotifier extends StateNotifier<LabMonitoringState> {
  final StartLabSessionUseCase _startLabSession;
  final StopLabSessionUseCase _stopLabSession;
  final AddDataPointUseCase _addDataPoint;
  final Ref _ref; // To access other providers like sensorTimeSeriesProvider

  Timer? _sensorPollTimer;
  Timer? _sessionTimer;

  // Store current sensor data for saving (not for UI updates)
  final Map<String, dynamic> _currentSensorData = {};

  // Throttle sensor data - track last update time per sensor
  final Map<String, DateTime> _lastSensorUpdate = {};

  // Battery optimization: slower polling for less critical sensors
  static const _sensorThrottleMs =
      400; // Increased from 200ms to 400ms (2 Hz instead of 5 Hz)

  // Track poll cycles to stagger heavy sensors
  int _pollCycle = 0;

  LabMonitoringNotifier(
    this._startLabSession,
    this._stopLabSession,

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

    // Initialize sensors that need explicit setup
    for (final sensor in lab.sensors) {
      switch (sensor) {
        case SensorType.noiseMeter:
          // Noise meter needs to start recording
          _ref
              .read(enhancedNoiseMeterProvider.notifier)
              .startRecordingWithPreset(
                // Use custom preset with very long duration for continuous monitoring
                entities.RecordingPreset.custom,
                customDuration: const Duration(hours: 24),
              );
          break;
        case SensorType.gps:
          // GPS/Geolocator needs initialization
          _ref.read(geolocatorProvider.notifier).initialize();
          break;
        case SensorType.lightMeter:
          // Light meter - ensure it's in standard mode (not photo mode)
          _ref.read(lightMeterProvider.notifier).enableStandardMode();
          _ref.read(lightMeterProvider.notifier).startMeasurement();
          break;
        default:
          // Other sensors auto-start when provider is watched
          break;
      }
    }

    // Poll core sensor providers periodically (every 200ms)
    _sensorPollTimer?.cancel();
    _sensorPollTimer = Timer.periodic(
      const Duration(milliseconds: _sensorThrottleMs),
      (_) => _pollSensorData(lab.sensors),
    );
  }

  void _pollSensorData(List<SensorType> sensors) {
    if (!state.isRecording || state.isPaused) return;

    final now = DateTime.now();
    _pollCycle++;

    // Define heavy sensors that should be polled less frequently
    const heavySensors = {
      SensorType.noiseMeter, // Uses microphone constantly
      SensorType.gps, // GPS drains battery
      SensorType.heartBeat, // Uses camera + flashlight
    };

    for (final sensor in sensors) {
      try {
        // Skip heavy sensors on odd cycles (poll them every 1 second instead of 500ms)
        if (heavySensors.contains(sensor) && _pollCycle % 2 != 0) {
          continue;
        }

        // Read from core providers based on sensor type
        dynamic sensorData;

        switch (sensor) {
          case SensorType.lightMeter:
            sensorData = _ref.read(lightMeterProvider);
            _processSensorValue(
              sensor,
              'lightMeter',
              sensorData.currentLux,
              now,
            );
            break;
          case SensorType.noiseMeter:
            sensorData = _ref.read(enhancedNoiseMeterProvider);
            _processSensorValue(
              sensor,
              'noiseMeter',
              sensorData.currentDecibels,
              now,
            );
            break;
          case SensorType.accelerometer:
            sensorData = _ref.read(accelerometerProvider);
            _processSensorValue(
              sensor,
              'accelerometer',
              sensorData.magnitude,
              now,
            );
            break;
          case SensorType.gyroscope:
            sensorData = _ref.read(gyroscopeProvider);
            _processSensorValue(sensor, 'gyroscope', sensorData.intensity, now);
            break;
          case SensorType.magnetometer:
            sensorData = _ref.read(magnetometerProvider);
            _processSensorValue(
              sensor,
              'magnetometer',
              sensorData.strength,
              now,
            );
            break;
          case SensorType.barometer:
            // Barometer uses altimeter data
            final altimeter = _ref.read(altimeterProvider);
            _processSensorValue(sensor, 'barometer', altimeter.pressure, now);
            break;
          case SensorType.compass:
            sensorData = _ref.read(compassProvider);
            final headingValue = sensorData.heading ?? 0.0;
            _processSensorValue(sensor, 'compass', headingValue, now);
            break;
          case SensorType.proximity:
            sensorData = _ref.read(proximityProvider);
            _processSensorValue(
              sensor,
              'proximity',
              sensorData.isNear ? 1.0 : 0.0,
              now,
            );
            break;
          case SensorType.pedometer:
            sensorData = _ref.read(pedometerProvider);
            _processSensorValue(
              sensor,
              'pedometer',
              sensorData.steps.toDouble(),
              now,
            );
            break;
          case SensorType.heartBeat:
            sensorData = _ref.read(heartBeatProvider);
            _processSensorValue(
              sensor,
              'heartBeat',
              sensorData.currentBPM.toDouble(),
              now,
            );
            break;
          case SensorType.gps:
            sensorData = _ref.read(geolocatorProvider);
            // GPS needs special handling - store multiple values
            if (sensorData.latitude != null && sensorData.longitude != null) {
              _currentSensorData['gps_latitude'] = sensorData.latitude;
              _currentSensorData['gps_longitude'] = sensorData.longitude;
              _currentSensorData['gps_altitude'] = sensorData.altitude ?? 0.0;
              _currentSensorData['gps_speed'] = sensorData.speed ?? 0.0;
              _currentSensorData['gps_accuracy'] = sensorData.accuracy ?? 0.0;
              // For graph, use speed or accuracy
              _ref
                  .read(sensorTimeSeriesProvider(sensor).notifier)
                  .addDataPoint(sensorData.speed ?? 0.0);
            }
            break;
          case SensorType.altimeter:
            sensorData = _ref.read(altimeterProvider);
            _processSensorValue(sensor, 'altimeter', sensorData.altitude, now);
            break;
          default:
            break;
        }
      } catch (e) {
        AppLogger.log(
          'Error reading sensor ${sensor.name}: $e',
          level: LogLevel.warning,
        );
      }
    }
  }

  void _processSensorValue(
    SensorType sensor,
    String sensorKey,
    double value,
    DateTime timestamp,
  ) {
    // Store for database
    _currentSensorData[sensorKey] = value;

    // Add to time series for graphing
    _ref.read(sensorTimeSeriesProvider(sensor).notifier).addDataPoint(value);
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isRecording && !state.isPaused) {
        state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);

        // Battery optimization: Save data less frequently
        // recordingInterval is in milliseconds, convert to seconds
        final intervalMillis = state.activeLab?.recordingInterval ?? 5000;
        final saveInterval = (intervalMillis / 1000).round().clamp(
          1,
          60,
        ); // Min 1s, max 60s

        if (state.elapsedSeconds % saveInterval == 0) {
          _collectAndSaveSensorData();
        }

        // TODO: Add auto-stop based on preset duration when Lab entity has maxDuration field
        // For now, sessions continue until manually stopped
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

  Future<void> toggleSession() async {
    if (!state.isRecording || state.activeSession == null) return;

    if (state.isPaused) {
      // Resume logic
      try {
        await _ref.read(resumeLabSessionUseCaseProvider)(state.activeSession!);
        state = state.copyWith(isPaused: false);

        // Resume sensor polling
        if (state.activeLab != null) {
          _sensorPollTimer?.cancel();
          _sensorPollTimer = Timer.periodic(
            const Duration(milliseconds: _sensorThrottleMs),
            (_) => _pollSensorData(state.activeLab!.sensors),
          );
        }
        // Restart light meter measurement explicitly
        _ref.read(lightMeterProvider.notifier).startMeasurement();
      } catch (e) {
        AppLogger.log('Error resuming lab session: $e', level: LogLevel.error);
        state = state.copyWith(errorMessage: 'Failed to resume session: $e');
      }
    } else {
      // Pause logic
      try {
        // Save labId for invalidation
        final labId = state.activeLab?.id;

        // Update session with current duration before pausing
        final updatedSession = state.activeSession!.copyWith(
          duration: state.elapsedSeconds,
        );
        await _ref.read(pauseLabSessionUseCaseProvider)(updatedSession);

        // Stop sensor polling when paused to save battery
        _sensorPollTimer?.cancel();

        // Stop light meter measurement explicitly
        _ref.read(lightMeterProvider.notifier).stopMeasurement();

        state = state.copyWith(isPaused: true);

        // Invalidate the session list provider to refresh UI
        if (labId != null) {
          _ref.invalidate(labSessionsProvider(labId));
        }
      } catch (e) {
        AppLogger.log('Error pausing lab session: $e', level: LogLevel.error);
        state = state.copyWith(errorMessage: 'Failed to pause session: $e');
      }
    }
  }

  Future<void> stopSession() async {
    if (!state.isRecording && !state.isPaused) return;
    if (state.activeSession == null) return;

    try {
      // Save labId before clearing state
      final labId = state.activeLab?.id;

      // Update session with final duration before stopping
      final updatedSession = state.activeSession!.copyWith(
        duration: state.elapsedSeconds,
      );
      await _stopLabSession(updatedSession);
      _cleanupSession();
      state = state.copyWith(
        isRecording: false,
        isPaused: false,
        activeLab: null,
        activeSession: null,
        elapsedSeconds: 0,
      );

      // Invalidate the session list provider to refresh UI
      if (labId != null) {
        _ref.invalidate(labSessionsProvider(labId));
      }
    } catch (e) {
      AppLogger.log('Error stopping lab session: $e', level: LogLevel.error);
      state = state.copyWith(errorMessage: 'Failed to stop session: $e');
    }
  }

  void _cleanupSession() {
    _sensorPollTimer?.cancel();
    _sessionTimer?.cancel();
    _currentSensorData.clear();
    _lastSensorUpdate.clear();

    // Stop sensors that need explicit cleanup
    if (state.activeLab != null) {
      for (final sensor in state.activeLab!.sensors) {
        switch (sensor) {
          case SensorType.noiseMeter:
            // Stop noise meter recording
            final noiseMeterNotifier = _ref.read(
              enhancedNoiseMeterProvider.notifier,
            );
            if (_ref.read(enhancedNoiseMeterProvider).isRecording) {
              noiseMeterNotifier.stopRecording();
            }
            break;
          case SensorType.gps:
            // Stop GPS tracking if active
            final gpsNotifier = _ref.read(geolocatorProvider.notifier);
            if (_ref.read(geolocatorProvider).isTracking) {
              gpsNotifier.stopTracking();
            }
            break;
          case SensorType.lightMeter:
            _ref.read(lightMeterProvider.notifier).stopMeasurement();
            break;
          default:
            break;
        }
      }
    }

    // Clear all sensorTimeSeriesProviders
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
        ref.read(startLabSessionUseCaseProvider),
        ref.read(stopLabSessionUseCaseProvider),
        ref.read(addDataPointUseCaseProvider),
        ref,
      ),
    );
