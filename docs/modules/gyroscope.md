# 🌀 Gyroscope Module Documentation

## Overview

The Gyroscope module provides angular velocity measurements around the device's three axes, enabling rotation detection, orientation tracking, and gesture recognition. Essential for advanced motion analysis and gaming applications.

## 🎯 Features

- **3-Axis Angular Velocity**: X, Y, Z rotation measurement
- **Real-time Rotation Data**: Continuous gyroscope updates
- **Gesture Recognition**: Detect rotational gestures and movements
- **Device Orientation**: Track device orientation changes
- **Calibration Support**: Auto-calibration and bias correction

## 📋 Integration Guide

### Dependencies

```yaml
dependencies:
  sensors_plus: ^4.0.2
  flutter_riverpod: ^2.4.9
```

### Basic Implementation

```dart
// Entity
class GyroscopeData {
  final double x, y, z;
  final DateTime timestamp;

  const GyroscopeData({required this.x, required this.y, required this.z, required this.timestamp});

  double get magnitude => math.sqrt(x * x + y * y + z * z);
}

// Provider
final gyroscopeProvider = StreamProvider<GyroscopeData>((ref) {
  return gyroscopeEvents.map((event) => GyroscopeData(
    x: event.x, y: event.y, z: event.z, timestamp: DateTime.now()
  ));
});

// Usage
class GyroscopeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gyroAsync = ref.watch(gyroscopeProvider);

    return gyroAsync.when(
      data: (data) => Column(children: [
        Text('X: ${data.x.toStringAsFixed(2)}'),
        Text('Y: ${data.y.toStringAsFixed(2)}'),
        Text('Z: ${data.z.toStringAsFixed(2)}'),
      ]),
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
```

## 🔧 Use Cases

- **Gaming**: Motion-controlled games and AR applications
- **Navigation**: Compass and orientation tracking
- **Fitness**: Exercise form analysis and movement tracking
- **Accessibility**: Gesture-based device control

---
