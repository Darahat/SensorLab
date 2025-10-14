import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../models/barometer_data.dart';

class BarometerNotifier extends StateNotifier<BarometerData> {
  StreamSubscription<BarometerEvent>? _subscription;
  double _totalPressure = 0;
  double? _previousPressure;

  BarometerNotifier() : super(BarometerData()) {
    _startListening();
  }

  void _startListening() {
    _subscription = barometerEventStream().listen(
      (BarometerEvent event) {
        _updateData(event);
      },
      onError: (error) {
        // Handle error silently
      },
      cancelOnError: false,
    );
  }

  void _updateData(BarometerEvent event) {
    final currentPressure = event.pressure;

    // Update max pressure
    final newMaxPressure = math.max(state.maxPressure, currentPressure);

    // Update min pressure
    final newMinPressure = state.minPressure == double.infinity
        ? currentPressure
        : math.min(state.minPressure, currentPressure);

    // Update average pressure
    final newSampleCount = state.sampleCount + 1;
    _totalPressure += currentPressure;
    final newAvgPressure = _totalPressure / newSampleCount;

    // Store previous pressure for trend analysis
    _previousPressure = state.pressure;

    state = state.copyWith(
      pressure: currentPressure,
      maxPressure: newMaxPressure,
      minPressure: newMinPressure,
      avgPressure: newAvgPressure,
      isActive: true,
      sampleCount: newSampleCount,
      timestamp: DateTime.now(),
    );
  }

  /// Get the current pressure trend
  PressureTrend? getPressureTrend() {
    if (_previousPressure == null) return null;
    return state.getPressureTrend(_previousPressure!);
  }

  void resetStats() {
    _totalPressure = 0;
    _previousPressure = null;
    state = state.resetStats();
  }

  void reset() {
    _totalPressure = 0;
    _previousPressure = null;
    state = BarometerData();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final barometerProvider =
    StateNotifierProvider<BarometerNotifier, BarometerData>(
      (ref) => BarometerNotifier(),
    );
