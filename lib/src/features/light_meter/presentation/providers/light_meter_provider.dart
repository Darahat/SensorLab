import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light/light.dart';

import '../../models/light_meter_data.dart';

/// Provider for light meter functionality
final lightMeterProvider =
    StateNotifierProvider<LightMeterNotifier, LightMeterData>((ref) {
      return LightMeterNotifier();
    });

/// State notifier for managing light meter data and operations
class LightMeterNotifier extends StateNotifier<LightMeterData> {
  LightMeterNotifier() : super(const LightMeterData());

  StreamSubscription<int>? _lightSubscription;
  Timer? _sessionTimer;
  final List<double> _allReadings = [];

  /// Start light measurement
  Future<void> startMeasurement() async {
    try {
      // Reset session data
      _allReadings.clear();
      state = state.copyWith(
        isReading: true,
        errorMessage: null,
        minLux: double.infinity,
        maxLux: double.negativeInfinity,
        averageLux: 0.0,
        totalReadings: 0,
        sessionDuration: 0,
        recentReadings: [],
      );

      // Start listening to light sensor readings
      _lightSubscription = Light().lightSensorStream.listen(
        _onLightData,
        onError: _onLightError,
        cancelOnError: false,
      );

      // Start session timer
      _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        state = state.copyWith(sessionDuration: state.sessionDuration + 1);
      });
    } catch (e) {
      state = state.copyWith(
        isReading: false,
        errorMessage: 'Failed to start light measurement: $e',
      );
    }
  }

  /// Stop light measurement
  void stopMeasurement() {
    _lightSubscription?.cancel();
    _lightSubscription = null;
    _sessionTimer?.cancel();
    _sessionTimer = null;

    state = state.copyWith(isReading: false, errorMessage: null);
  }

  /// Handle incoming light data
  void _onLightData(int luxValue) {
    if (!mounted) return;

    try {
      // Convert to double for calculations
      double lux = luxValue.toDouble();

      // Ensure reasonable bounds for lux
      lux = lux.clamp(0.0, 100000.0);

      // Add to all readings for average calculation
      _allReadings.add(lux);

      // Calculate statistics
      final newMin = min(
        state.minLux == double.infinity ? lux : state.minLux,
        lux,
      );
      final newMax = max(
        state.maxLux == double.negativeInfinity ? lux : state.maxLux,
        lux,
      );
      final newAverage =
          _allReadings.isNotEmpty
              ? _allReadings.reduce((a, b) => a + b) / _allReadings.length
              : 0.0;

      // Update recent readings for chart (keep last 50 readings)
      final updatedRecentReadings = List<double>.from(state.recentReadings);
      updatedRecentReadings.add(lux);
      if (updatedRecentReadings.length > 50) {
        updatedRecentReadings.removeAt(0);
      }

      // Determine light level
      final lightLevel = LightMeterData.getLightLevel(lux);

      // Update state
      state = state.copyWith(
        currentLux: lux,
        minLux: newMin,
        maxLux: newMax,
        averageLux: newAverage,
        lightLevel: lightLevel,
        recentReadings: updatedRecentReadings,
        totalReadings: _allReadings.length,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error processing light data: $e');
    }
  }

  /// Handle light reading errors
  void _onLightError(dynamic error) {
    if (!mounted) return;

    state = state.copyWith(
      errorMessage: 'Light measurement error: $error',
      isReading: false,
    );

    // Clean up on error
    stopMeasurement();
  }

  /// Reset all data
  void resetData() {
    stopMeasurement();
    _allReadings.clear();

    state = const LightMeterData();
  }

  /// Toggle measurement (start/stop)
  Future<void> toggleMeasurement() async {
    if (state.isReading) {
      stopMeasurement();
    } else {
      await startMeasurement();
    }
  }

  /// Get a single light reading without starting continuous measurement
  Future<void> getSingleReading() async {
    try {
      // Get a single reading from the stream
      final lightValue = await Light().lightSensorStream.first;
      final lux = lightValue.toDouble();

      final lightLevel = LightMeterData.getLightLevel(lux);

      state = state.copyWith(
        currentLux: lux,
        lightLevel: lightLevel,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to get light reading: $e');
    }
  }

  @override
  void dispose() {
    stopMeasurement();
    super.dispose();
  }
}
