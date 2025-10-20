import 'dart:async';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/compass_data.dart';

class CompassNotifier extends StateNotifier<CompassData> {
  StreamSubscription<CompassEvent>? _subscription;

  CompassNotifier() : super(const CompassData()) {
    _startListening();
  }

  void _startListening() {
    _subscription = FlutterCompass.events?.listen(
      (CompassEvent event) {
        _updateHeading(event.heading);
      },
      onError: (error) {
        state = state.copyWith(hasError: true, isActive: false);
      },
    );
  }

  void _updateHeading(double? heading) {
    final direction = CompassData.calculateDirection(heading);

    state = state.copyWith(
      heading: heading,
      currentDirection: direction,
      hasError: false,
      isActive: heading != null,
    );
  }

  Future<void> calibrate() async {
    state = state.copyWith(isCalibrating: true);

    // Simulate calibration process
    await Future.delayed(const Duration(seconds: 3));

    state = state.copyWith(isCalibrating: false);
  }

  void reset() {
    state = const CompassData();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final compassProvider = StateNotifierProvider<CompassNotifier, CompassData>(
  (ref) => CompassNotifier(),
);
