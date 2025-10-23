import 'dart:async';
import 'dart:math' show min, max;

// Note: Random-based simulation removed. This provider only exposes real sensor data when available.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/humidity_data.dart';

/// Provider for humidity functionality
final humidityProvider = StateNotifierProvider<HumidityNotifier, HumidityData>((
  ref,
) {
  return HumidityNotifier();
});

/// State notifier for managing humidity data and operations
class HumidityNotifier extends StateNotifier<HumidityData> {
  HumidityNotifier() : super(const HumidityData());

  Timer? _sessionTimer;
  Timer? _sensorPollTimer; // Placeholder for real sensor poll if supported
  final List<double> _allReadings = [];

  @override
  void dispose() {
    stopMeasurement();
    super.dispose();
  }

  /// Check if device has humidity sensor and initialize
  Future<void> checkSensorAvailability() async {
    try {
      // Check actual hardware availability (platform/implementation specific)
      final hasSensor = await _checkHumidityAvailability();

      state = state.copyWith(
        hasSensor: hasSensor,
        errorMessage: hasSensor
            ? null
            : 'Device does not have a humidity sensor.',
      );
    } catch (e) {
      state = state.copyWith(
        hasSensor: false,
        errorMessage: 'Error checking sensor availability: $e',
      );
    }
  }

  /// Check humidity sensor availability (stub - replace with platform-specific implementation)
  Future<bool> _checkHumidityAvailability() async {
    // TODO: Implement actual availability check via a suitable plugin or platform channel.
    // For now, return false to indicate unavailable on most devices.
    return false;
  }

  /// Start humidity measurement (real sensor only)
  Future<void> startMeasurement() async {
    if (!state.hasSensor) {
      await checkSensorAvailability();
    }

    try {
      if (!state.hasSensor) {
        // Do not start measurement without a real sensor
        state = state.copyWith(
          isReading: false,
          errorMessage: 'Humidity sensor not available on this device.',
        );
        return;
      }

      // Reset session data
      _allReadings.clear();
      state = state.copyWith(
        isReading: true,
        errorMessage: null,
        minHumidity: double.infinity,
        maxHumidity: double.negativeInfinity,
        averageHumidity: 0.0,
        totalReadings: 0,
        sessionDuration: 0,
        recentReadings: [],
      );

      // TODO: Subscribe to real humidity sensor stream if available.
      // As a placeholder, we keep a session timer to track elapsed time only.
      _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        state = state.copyWith(sessionDuration: state.sessionDuration + 1);
      });
    } catch (e) {
      state = state.copyWith(
        isReading: false,
        errorMessage: 'Failed to start humidity measurement: $e',
      );
    }
  }

  /// Process humidity reading (real or simulated)
  // Process a real humidity reading from hardware/plugin.
  // This remains for when a real sensor stream is integrated.
  // ignore: unused_element
  void _processHumidityReading(double humidity) {
    if (!mounted) return;

    try {
      // Add to all readings for average calculation
      _allReadings.add(humidity);

      // Calculate statistics
      final newMin = min(
        state.minHumidity == double.infinity ? humidity : state.minHumidity,
        humidity,
      );
      final newMax = max(
        state.maxHumidity == double.negativeInfinity
            ? humidity
            : state.maxHumidity,
        humidity,
      );
      final newAverage = _allReadings.isNotEmpty
          ? _allReadings.reduce((a, b) => a + b) / _allReadings.length
          : 0.0;

      // Update recent readings for chart (keep last 50 readings)
      final updatedRecentReadings = List<double>.from(state.recentReadings);
      updatedRecentReadings.add(humidity);
      if (updatedRecentReadings.length > 50) {
        updatedRecentReadings.removeAt(0);
      }

      // Determine humidity level
      final humidityLevel = HumidityData.getHumidityLevel(humidity);

      // Update state
      state = state.copyWith(
        currentHumidity: humidity,
        minHumidity: newMin,
        maxHumidity: newMax,
        averageHumidity: newAverage,
        humidityLevel: humidityLevel,
        recentReadings: updatedRecentReadings,
        totalReadings: _allReadings.length,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error processing humidity data: $e',
      );
    }
  }

  /// Stop humidity measurement
  void stopMeasurement() {
    _sensorPollTimer?.cancel();
    _sensorPollTimer = null;
    _sessionTimer?.cancel();
    _sessionTimer = null;

    state = state.copyWith(isReading: false);
  }

  /// Reset all data
  void resetData() {
    stopMeasurement();
    _allReadings.clear();

    state = const HumidityData().copyWith(hasSensor: state.hasSensor);
  }

  /// Toggle measurement (start/stop)
  Future<void> toggleMeasurement() async {
    if (state.isReading) {
      stopMeasurement();
    } else {
      await startMeasurement();
    }
  }

  /// Get a single humidity reading
  Future<void> getSingleReading() async {
    try {
      if (!state.hasSensor) {
        await checkSensorAvailability();
        state = state.copyWith(
          errorMessage: 'Humidity sensor not available on this device.',
        );
        return;
      }

      // TODO: Read a single real humidity value from the platform, if supported.
      state = state.copyWith(
        errorMessage:
            'Single humidity reading is not supported on this device yet.',
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to get humidity reading: $e',
      );
    }
  }
}
