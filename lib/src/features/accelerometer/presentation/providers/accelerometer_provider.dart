import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

// import 'package:state_notifier/state_notifier.dart';

import '../../models/accelerometer_data.dart';

class AccelerometerNotifier extends StateNotifier<AccelerometerData> {
  StreamSubscription<AccelerometerEvent>? _subscription;

  AccelerometerNotifier() : super(const AccelerometerData()) {
    _startListening();
  }

  void _startListening() {
    _subscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      _updateData(event);
    });
  }

  void _updateData(AccelerometerEvent event) {
    // Update max values
    final newMaxX = math.max(state.maxX, event.x.abs());
    final newMaxY = math.max(state.maxY, event.y.abs());
    final newMaxZ = math.max(state.maxZ, event.z.abs());

    state = state.copyWith(
      x: event.x,
      y: event.y,
      z: event.z,
      maxX: newMaxX,
      maxY: newMaxY,
      maxZ: newMaxZ,
      isActive: true,
    );
  }

  void resetMaxValues() {
    state = state.resetMaxValues();
  }

  void reset() {
    state = const AccelerometerData();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final accelerometerProvider =
    StateNotifierProvider<AccelerometerNotifier, AccelerometerData>(
      (ref) => AccelerometerNotifier(),
    );
