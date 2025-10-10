import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/noise_meter_data.dart';

/// Provider for noise meter functionality
final noiseMeterProvider =
    StateNotifierProvider<NoiseMeterNotifier, NoiseMeterData>((ref) {
      return NoiseMeterNotifier();
    });

/// State notifier for managing noise meter data and operations
class NoiseMeterNotifier extends StateNotifier<NoiseMeterData> {
  NoiseMeterNotifier() : super(const NoiseMeterData());

  NoiseMeter? _noiseMeter;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  Timer? _sessionTimer;
  final List<double> _allReadings = [];

  /// Check and request microphone permission
  Future<void> checkPermission() async {
    try {
      final status = await Permission.microphone.status;

      if (status.isDenied) {
        final result = await Permission.microphone.request();
        state = state.copyWith(hasPermission: result.isGranted);
      } else {
        state = state.copyWith(hasPermission: status.isGranted);
      }

      if (!state.hasPermission) {
        state = state.copyWith(
          errorMessage:
              'Microphone permission is required to measure noise levels',
        );
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error checking microphone permission: $e',
        hasPermission: false,
      );
    }
  }

  /// Start noise measurement
  Future<void> startMeasurement() async {
    if (!state.hasPermission) {
      await checkPermission();
      if (!state.hasPermission) return;
    }

    try {
      // Reset session data
      _allReadings.clear();
      state = state.copyWith(
        isRecording: true,
        errorMessage: null,
        minDecibels: double.infinity,
        maxDecibels: double.negativeInfinity,
        averageDecibels: 0.0,
        totalReadings: 0,
        sessionDuration: 0,
        recentReadings: [],
      );

      // Create noise meter instance
      _noiseMeter = NoiseMeter();

      // Start listening to noise readings
      _noiseSubscription = _noiseMeter!.noise.listen(
        _onNoiseData,
        onError: _onNoiseError,
        cancelOnError: false,
      );

      // Start session timer
      _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        state = state.copyWith(sessionDuration: state.sessionDuration + 1);
      });
    } catch (e) {
      state = state.copyWith(
        isRecording: false,
        errorMessage: 'Failed to start noise measurement: $e',
      );
    }
  }

  /// Stop noise measurement
  void stopMeasurement() {
    _noiseSubscription?.cancel();
    _noiseSubscription = null;
    _noiseMeter = null;
    _sessionTimer?.cancel();
    _sessionTimer = null;

    state = state.copyWith(isRecording: false, errorMessage: null);
  }

  /// Handle incoming noise data
  void _onNoiseData(NoiseReading reading) {
    if (!mounted) return;

    try {
      // Get decibel value from reading
      double decibels = reading.meanDecibel;

      // Ensure reasonable bounds for decibels
      decibels = decibels.clamp(0.0, 150.0);

      // Add to all readings for average calculation
      _allReadings.add(decibels);

      // Calculate statistics
      final newMin = min(
        state.minDecibels == double.infinity ? decibels : state.minDecibels,
        decibels,
      );
      final newMax = max(
        state.maxDecibels == double.negativeInfinity
            ? decibels
            : state.maxDecibels,
        decibels,
      );
      final newAverage =
          _allReadings.isNotEmpty
              ? _allReadings.reduce((a, b) => a + b) / _allReadings.length
              : 0.0;

      // Update recent readings for chart (keep last 50 readings)
      final updatedRecentReadings = List<double>.from(state.recentReadings);
      updatedRecentReadings.add(decibels);
      if (updatedRecentReadings.length > 50) {
        updatedRecentReadings.removeAt(0);
      }

      // Determine noise level
      final noiseLevel = NoiseMeterData.getNoiseLevel(decibels);

      // Update state
      state = state.copyWith(
        currentDecibels: decibels,
        minDecibels: newMin,
        maxDecibels: newMax,
        averageDecibels: newAverage,
        noiseLevel: noiseLevel,
        recentReadings: updatedRecentReadings,
        totalReadings: _allReadings.length,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error processing noise data: $e');
    }
  }

  /// Handle noise reading errors
  void _onNoiseError(dynamic error) {
    if (!mounted) return;

    state = state.copyWith(
      errorMessage: 'Noise measurement error: $error',
      isRecording: false,
    );

    // Clean up on error
    stopMeasurement();
  }

  /// Reset all data
  void resetData() {
    stopMeasurement();
    _allReadings.clear();

    state = const NoiseMeterData().copyWith(hasPermission: state.hasPermission);
  }

  /// Toggle measurement (start/stop)
  Future<void> toggleMeasurement() async {
    if (state.isRecording) {
      stopMeasurement();
    } else {
      await startMeasurement();
    }
  }

  @override
  void dispose() {
    stopMeasurement();
    super.dispose();
  }
}
