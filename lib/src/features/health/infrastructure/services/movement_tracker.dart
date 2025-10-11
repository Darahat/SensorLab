import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../domain/entities/activity_type.dart';

class MovementTracker {
  final ActivityType activityType;
  StreamSubscription<UserAccelerometerEvent>? _accelSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;
  StreamSubscription<StepCount>? _stepSub;

  MovementTracker(this.activityType);

  void startTracking({
    required Function(UserAccelerometerEvent) onAccelerometer,
    required Function(GyroscopeEvent) onGyroscope,
    required Function(int) onSteps,
  }) {
    _accelSub = userAccelerometerEventStream().listen(onAccelerometer);

    switch (activityType) {
      case ActivityType.workout:
      case ActivityType.stairs:
        _gyroSub = gyroscopeEventStream().listen(onGyroscope);
        break;
      case ActivityType.walking:
      case ActivityType.running:
      case ActivityType.cycling:
        _stepSub = Pedometer.stepCountStream.listen((e) => onSteps(e.steps));
        break;
      case ActivityType.sitting:
      case ActivityType.standing:
        // No sensor tracking needed for stationary activities
        break;
    }
  }

  void stopTracking() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    _stepSub?.cancel();
  }
}
