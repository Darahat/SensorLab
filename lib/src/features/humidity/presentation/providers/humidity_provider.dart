import 'dart:async';
import 'dart:math';

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
  Timer? _simulationTimer;
  final List<double> _allReadings = [];
  final Random _random = Random();

  @override
  void dispose() {
    stopMeasurement();
    super.dispose();
  }

  /// Check if device has humidity sensor and initialize
  Future<void> checkSensorAvailability() async {
    try {
      // Most consumer devices don't have humidity sensors
      // We'll simulate this functionality for demonstration
      final hasSensor = await _checkHumidityAvailability();

      state = state.copyWith(
        hasSensor: hasSensor,
        errorMessage: hasSensor
            ? null
            : 'Device does not have a humidity sensor. Showing simulated data.',
      );
    } catch (e) {
      state = state.copyWith(
        hasSensor: false,
        errorMessage: 'Error checking sensor availability: $e',
      );
    }
  }

  /// Simulate humidity sensor availability check
  Future<bool> _checkHumidityAvailability() async {
    // In a real app, you would check for actual sensor availability
    // Most smartphones don't have humidity sensors, so we'll simulate
    await Future.delayed(const Duration(milliseconds: 500));
    return false; // Most devices don't have humidity sensors
  }

  /// Start humidity measurement (simulation for most devices)
  Future<void> startMeasurement() async {
    if (!state.hasSensor) {
      await checkSensorAvailability();
    }

    try {
      // Reset session data
      _allReadings.clear();
      state = state.copyWith(
        isReading: true,
        errorMessage: state.hasSensor ? null : 'Using simulated humidity data',
        minHumidity: double.infinity,
        maxHumidity: double.negativeInfinity,
        averageHumidity: 0.0,
        totalReadings: 0,
        sessionDuration: 0,
        recentReadings: [],
      );

      // Start simulation timer (since most devices don't have humidity sensors)
      _simulationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        _generateSimulatedHumidityData();
      });

      // Start session timer
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

  /// Generate simulated humidity data
  void _generateSimulatedHumidityData() {
    if (!mounted) return;

    try {
      // Generate realistic humidity values
      // Base humidity around 45-55% with some variation
      const baseHumidity = 50.0;
      final variation = (_random.nextDouble() - 0.5) * 20; // ±10%
      final seasonalOffset = _getSeasonalOffset();

      double humidity = (baseHumidity + variation + seasonalOffset).clamp(
        20.0,
        90.0,
      );

      // Add small trends over time
      if (_allReadings.isNotEmpty) {
        final lastReading = _allReadings.last;
        final trend = (_random.nextDouble() - 0.5) * 2; // Small trend
        humidity = (lastReading + trend).clamp(20.0, 90.0);
      }

      _processHumidityReading(humidity);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error generating humidity data: $e',
      );
    }
  }

  /// Get seasonal humidity offset (simulation)
  double _getSeasonalOffset() {
    final month = DateTime.now().month;

    // Summer months tend to be more humid
    if (month >= 6 && month <= 8) {
      return 10.0; // Higher humidity in summer
    }
    // Winter months tend to be drier
    else if (month >= 12 || month <= 2) {
      return -15.0; // Lower humidity in winter
    }

    return 0.0; // Spring/fall baseline
  }

  /// Process humidity reading (real or simulated)
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
    _simulationTimer?.cancel();
    _simulationTimer = null;
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
      }

      // Generate single simulated reading
      final humidity = 45.0 + (_random.nextDouble() - 0.5) * 30; // 30-60% range
      final humidityLevel = HumidityData.getHumidityLevel(humidity);

      state = state.copyWith(
        currentHumidity: humidity,
        humidityLevel: humidityLevel,
        errorMessage: state.hasSensor
            ? null
            : 'Single reading from simulated data',
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to get humidity reading: $e',
      );
    }
  }
}
