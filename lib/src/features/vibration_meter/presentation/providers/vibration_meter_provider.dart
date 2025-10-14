import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../models/vibration_data.dart';

class VibrationMeterNotifier extends StateNotifier<VibrationData> {
  StreamSubscription<AccelerometerEvent>? _subscription;
  final List<double> _magnitudeBuffer = [];

  // Configuration
  static const int bufferSize = 100; // Keep last 100 samples for analysis

  VibrationMeterNotifier() : super(VibrationData()) {
    _startListening();
  }

  void _startListening() {
    // Use accelerometer with highest sampling rate for accurate vibration detection
    _subscription =
        accelerometerEventStream(
          samplingPeriod: const Duration(milliseconds: 10), // 100 Hz sampling
        ).listen(
          (AccelerometerEvent event) {
            _updateData(event);
          },
          onError: (error) {
            // Handle error silently
          },
          cancelOnError: false,
        );
  }

  void _updateData(AccelerometerEvent event) {
    // Update state with new accelerometer data
    state = state.update(
      accelX: event.x,
      accelY: event.y,
      accelZ: event.z,
      recentMagnitudes: _magnitudeBuffer,
    );

    // Update buffer for frequency and pattern analysis
    _magnitudeBuffer.add(state.magnitude);
    if (_magnitudeBuffer.length > bufferSize) {
      _magnitudeBuffer.removeAt(0);
    }
  }

  /// Reset statistics (max, min, avg)
  void resetStats() {
    state = state.resetStats();
  }

  /// Reset all data
  void reset() {
    _magnitudeBuffer.clear();
    state = VibrationData();
  }

  /// Pause vibration monitoring
  void pause() {
    _subscription?.pause();
  }

  /// Resume vibration monitoring
  void resume() {
    _subscription?.resume();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final vibrationMeterProvider =
    StateNotifierProvider<VibrationMeterNotifier, VibrationData>(
      (ref) => VibrationMeterNotifier(),
    );
