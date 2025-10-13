# 📐 Proximity Sensor Module Documentation

## Overview

The proximity sensor module detects nearby objects using infrared or ultrasonic sensors, commonly used for screen management and gesture detection in mobile applications.

## Features

- Object detection within range
- Distance measurement (device dependent)
- Screen auto-lock functionality
- Call management integration
- Power saving automation

## Integration

```yaml
dependencies:
  proximity_sensor: ^3.0.0
  flutter_riverpod: ^2.4.9
```

```dart
// Entity
class ProximityData {
  final bool isNear;
  final double? distance;
  final DateTime timestamp;

  String get status => isNear ? 'Object Detected' : 'Clear';

  bool get shouldLockScreen => isNear;
}

// Provider
final proximityProvider = StreamProvider<ProximityData>((ref) {
  return ProximitySensor.events.map((event) => ProximityData(
    isNear: event == 0,
    distance: event.toDouble(),
    timestamp: DateTime.now(),
  ));
});

// Controller for screen management
class ProximityController extends StateNotifier<ProximityData?> {
  ProximityController() : super(null) {
    _initializeProximity();
  }

  void _initializeProximity() {
    ProximitySensor.events.listen((event) {
      state = ProximityData(
        isNear: event == 0,
        distance: event.toDouble(),
        timestamp: DateTime.now(),
      );

      // Handle screen lock/unlock
      if (state?.shouldLockScreen == true) {
        _lockScreen();
      } else {
        _unlockScreen();
      }
    });
  }
}
```

## Use Cases

- Automatic screen lock during calls
- Power saving features
- Gesture-based interactions
- Security applications
- Accessibility features

