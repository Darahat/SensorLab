import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

import '../../models/proximity_data.dart';

/// Provider for proximity sensor functionality
final proximityProvider =
    StateNotifierProvider<ProximityNotifier, ProximityData>((ref) {
      return ProximityNotifier();
    });

/// State notifier for managing proximity sensor data and operations
class ProximityNotifier extends StateNotifier<ProximityData> {
  ProximityNotifier() : super(const ProximityData());

  StreamSubscription<dynamic>? _proximitySubscription;
  Timer? _sessionTimer;

  @override
  void dispose() {
    stopMeasurement();
    super.dispose();
  }

  /// Check and request permissions for proximity sensor
  Future<void> checkPermissions() async {
    try {
      var status = await Permission.sensors.status;

      if (!status.isGranted) {
        status = await Permission.sensors.request();
      }

      final hasSensor = await _checkSensorAvailability();

      state = state.copyWith(
        hasPermission: status.isGranted,
        hasSensor: hasSensor,
        errorMessage: !status.isGranted
            ? 'Sensor permission is required'
            : !hasSensor
            ? 'Device does not have a proximity sensor'
            : null,
      );
    } catch (e) {
      state = state.copyWith(
        hasPermission: false,
        hasSensor: false,
        errorMessage: 'Error checking permissions: $e',
      );
    }
  }

  /// Check if device has proximity sensor
  Future<bool> _checkSensorAvailability() async {
    try {
      // Try to access the proximity sensor to check availability
      // Most modern smartphones have proximity sensors
      return true; // Assume available for most devices
    } catch (e) {
      return false;
    }
  }

  /// Start proximity sensor measurement
  Future<void> startMeasurement() async {
    if (!state.hasPermission || !state.hasSensor) {
      await checkPermissions();
      if (!state.hasPermission || !state.hasSensor) return;
    }

    try {
      state = state.copyWith(
        isReading: true,
        totalReadings: 0,
        sessionDuration: 0,
        nearDetections: 0,
        farDetections: 0,
        recentReadings: [],
      );

      // Start listening to proximity sensor events
      _proximitySubscription = ProximitySensor.events.listen(
        _onProximityData,
        onError: _onProximityError,
        cancelOnError: false,
      );

      // Start session timer
      _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        state = state.copyWith(sessionDuration: state.sessionDuration + 1);
      });
    } catch (e) {
      state = state.copyWith(
        isReading: false,
        errorMessage: 'Failed to start proximity measurement: $e',
      );
    }
  }

  /// Handle incoming proximity sensor data
  void _onProximityData(dynamic event) {
    if (!mounted) return;

    try {
      // proximity_sensor package returns int: 1 for near, 0 for far
      final isNear = event > 0;
      final proximityState = isNear ? ProximityState.near : ProximityState.far;

      // Create new reading
      final newReading = ProximityReading(
        isNear: isNear,
        timestamp: DateTime.now(),
      );

      // Update recent readings (keep last 100 readings)
      final updatedRecentReadings = List<ProximityReading>.from(
        state.recentReadings,
      );
      updatedRecentReadings.add(newReading);
      if (updatedRecentReadings.length > 100) {
        updatedRecentReadings.removeAt(0);
      }

      // Update counters
      final newNearDetections = state.nearDetections + (isNear ? 1 : 0);
      final newFarDetections = state.farDetections + (isNear ? 0 : 1);

      // Update state
      state = state.copyWith(
        isNear: isNear,
        proximityState: proximityState,
        recentReadings: updatedRecentReadings,
        totalReadings: state.totalReadings + 1,
        nearDetections: newNearDetections,
        farDetections: newFarDetections,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error processing proximity data: $e',
      );
    }
  }

  /// Handle proximity sensor errors
  void _onProximityError(dynamic error) {
    if (!mounted) return;

    state = state.copyWith(
      errorMessage: 'Proximity sensor error: $error',
      isReading: false,
    );

    // Clean up on error
    stopMeasurement();
  }

  /// Stop proximity sensor measurement
  void stopMeasurement() {
    _proximitySubscription?.cancel();
    _proximitySubscription = null;
    _sessionTimer?.cancel();
    _sessionTimer = null;

    state = state.copyWith(isReading: false);
  }

  /// Reset all data
  void resetData() {
    stopMeasurement();

    state = const ProximityData().copyWith(
      hasPermission: state.hasPermission,
      hasSensor: state.hasSensor,
    );
  }

  /// Toggle measurement (start/stop)
  Future<void> toggleMeasurement() async {
    if (state.isReading) {
      stopMeasurement();
    } else {
      await startMeasurement();
    }
  }

  /// Get a single proximity reading
  Future<void> getSingleReading() async {
    if (!state.hasPermission || !state.hasSensor) {
      await checkPermissions();
      if (!state.hasPermission || !state.hasSensor) return;
    }

    try {
      // Get a single reading from the proximity sensor
      final eventStream = ProximitySensor.events;
      final event = await eventStream.first.timeout(const Duration(seconds: 3));

      final isNear = event > 0;
      final proximityState = isNear ? ProximityState.near : ProximityState.far;

      state = state.copyWith(isNear: isNear, proximityState: proximityState);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to get proximity reading: $e',
      );
    }
  }
}
