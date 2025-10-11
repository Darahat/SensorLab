import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../models/magnetometer_data.dart';

class MagnetometerNotifier extends StateNotifier<MagnetometerData> {
  StreamSubscription<MagnetometerEvent>? _subscription;

  MagnetometerNotifier() : super(const MagnetometerData()) {
    _startListening();
  }

  void _startListening() {
    _subscription = magnetometerEventStream().listen((MagnetometerEvent event) {
      _updateData(event);
    });
  }

  void _updateData(MagnetometerEvent event) {
    final strength = MagnetometerData.calculateStrength(
      event.x,
      event.y,
      event.z,
    );
    final newMaxStrength = math.max(state.maxStrength, strength);

    state = state.copyWith(
      x: event.x,
      y: event.y,
      z: event.z,
      strength: strength,
      maxStrength: newMaxStrength,
      isActive: true,
    );
  }

  void resetMaxStrength() {
    state = state.resetMaxStrength();
  }

  void reset() {
    state = const MagnetometerData();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final magnetometerProvider =
    StateNotifierProvider<MagnetometerNotifier, MagnetometerData>(
      (ref) => MagnetometerNotifier(),
    );
