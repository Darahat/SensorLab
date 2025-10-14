import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/speed_data.dart';

class SpeedMeterNotifier extends StateNotifier<SpeedData> {
  StreamSubscription<Position>? _positionSubscription;
  Position? _lastPosition;
  double _totalSpeed = 0;
  bool _isTracking = false;

  SpeedMeterNotifier() : super(const SpeedData());

  Future<void> startTracking() async {
    if (_isTracking) return;

    // Check permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    _isTracking = true;
    _lastPosition = null;

    // Start listening to position stream
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1, // Update every meter
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            _updateSpeed(position);
          },
        );
  }

  void _updateSpeed(Position position) {
    // Get speed from GPS (in m/s)
    final currentSpeed = position.speed >= 0 ? position.speed : 0.0;

    // Calculate distance if we have a previous position
    double distanceIncrement = 0;
    if (_lastPosition != null) {
      distanceIncrement = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
    }

    _lastPosition = position;

    // Update max speed
    final newMaxSpeed = math.max(state.maxSpeed, currentSpeed);

    // Update average speed
    final newSampleCount = state.sampleCount + 1;
    _totalSpeed += currentSpeed;
    final newAvgSpeed = _totalSpeed / newSampleCount;

    // Update total distance
    final newDistance = state.distance + distanceIncrement;

    state = state.copyWith(
      currentSpeed: currentSpeed,
      maxSpeed: newMaxSpeed,
      avgSpeed: newAvgSpeed,
      distance: newDistance,
      isActive: true,
      sampleCount: newSampleCount,
    );
  }

  void stopTracking() {
    _isTracking = false;
    _positionSubscription?.cancel();
    _positionSubscription = null;
    state = state.copyWith(isActive: false);
  }

  void resetStats() {
    _totalSpeed = 0;
    state = state.resetStats();
  }

  void reset() {
    _totalSpeed = 0;
    _lastPosition = null;
    state = const SpeedData();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}

final speedMeterProvider = StateNotifierProvider<SpeedMeterNotifier, SpeedData>(
  (ref) => SpeedMeterNotifier(),
);
