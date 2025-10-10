import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../models/gyroscope_data.dart';

class GyroscopeNotifier extends StateNotifier<GyroscopeData> {
  StreamSubscription<GyroscopeEvent>? _subscription;
  static const int maxDataPoints = 50;

  GyroscopeNotifier() : super(const GyroscopeData()) {
    _startListening();
  }

  void _startListening() {
    _subscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      _updateData(event);
    });
  }

  void _updateData(GyroscopeEvent event) {
    final intensity = (event.x.abs() + event.y.abs() + event.z.abs()) / 3;
    final newTime = state.time + 1;

    // Create new data points
    final newXPoints = List<GyroscopePoint>.from(state.xPoints)
      ..add(GyroscopePoint(newTime.toDouble(), event.x));
    final newYPoints = List<GyroscopePoint>.from(state.yPoints)
      ..add(GyroscopePoint(newTime.toDouble(), event.y));
    final newZPoints = List<GyroscopePoint>.from(state.zPoints)
      ..add(GyroscopePoint(newTime.toDouble(), event.z));

    // Keep only last maxDataPoints
    if (newXPoints.length > maxDataPoints) {
      newXPoints.removeAt(0);
      newYPoints.removeAt(0);
      newZPoints.removeAt(0);
    }

    state = state.copyWith(
      x: event.x,
      y: event.y,
      z: event.z,
      intensity: intensity,
      isActive: true,
      xPoints: newXPoints,
      yPoints: newYPoints,
      zPoints: newZPoints,
      time: newTime,
    );
  }

  void reset() {
    state = const GyroscopeData();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final gyroscopeProvider =
    StateNotifierProvider<GyroscopeNotifier, GyroscopeData>(
      (ref) => GyroscopeNotifier(),
    );
