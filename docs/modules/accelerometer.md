# 📊 Accelerometer Module Documentation

## Overview

The Accelerometer module provides real-time 3-axis acceleration measurement capabilities, enabling motion detection, device orientation tracking, and activity recognition. This module serves as a foundation for motion-based applications and fitness tracking.

---

## 🎯 Features

### Core Functionality

- **3-Axis Acceleration**: X, Y, Z axis acceleration measurement
- **Real-time Data Stream**: Continuous acceleration data updates
- **Motion Detection**: Detect device movement and orientation changes
- **Data Filtering**: Built-in noise reduction and smoothing
- **Activity Recognition**: Basic activity pattern recognition

### Measurement Capabilities

- **Linear Acceleration**: Device movement without gravity
- **User Acceleration**: Human-induced acceleration
- **Gravity Vector**: Gravitational force direction
- **Sampling Rate**: Configurable data collection frequency

---

## 🏗️ Module Architecture

```
📁 accelerometer/
├── 📁 domain/
│   ├── 📁 entities/
│   │   └── accelerometer_data.dart    # Acceleration data entity
│   ├── 📁 repositories/
│   │   └── accelerometer_repository.dart # Repository interface
│   └── 📁 usecases/
│       ├── get_acceleration_stream.dart # Data stream use case
│       └── detect_motion.dart         # Motion detection
│
├── 📁 infrastructure/
│   ├── 📁 datasources/
│   │   └── sensor_accelerometer_source.dart # Sensor integration
│   └── 📁 repositories/
│       └── accelerometer_repository_impl.dart
│
└── 📁 presentation/
    ├── 📁 screens/
    │   └── accelerometer_screen.dart  # Main accelerometer screen
    ├── 📁 widgets/
    │   ├── acceleration_chart.dart    # Data visualization
    │   └── motion_indicator.dart      # Motion status display
    └── 📁 providers/
        └── accelerometer_provider.dart # State management
```

---

## 📋 Integration Guide

### 1. Dependencies Required

```yaml
dependencies:
  sensors_plus: ^4.0.2
  flutter_riverpod: ^2.4.9
  fl_chart: ^0.64.0 # For data visualization
```

### 2. Basic Implementation

#### Accelerometer Entity

```dart
// domain/entities/accelerometer_data.dart
class AccelerometerData {
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;

  const AccelerometerData({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  // Calculate magnitude
  double get magnitude => math.sqrt(x * x + y * y + z * z);

  // Check if device is moving
  bool get isMoving => magnitude > 1.5; // Threshold for motion detection
}
```

#### Repository Implementation

```dart
// infrastructure/repositories/accelerometer_repository_impl.dart
class AccelerometerRepositoryImpl implements AccelerometerRepository {
  @override
  Stream<AccelerometerData> getAccelerationStream() {
    return accelerometerEvents.map(
      (event) => AccelerometerData(
        x: event.x,
        y: event.y,
        z: event.z,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  Future<bool> isSupported() async {
    // Check if accelerometer is available
    return true; // Most devices have accelerometers
  }
}
```

#### Provider Setup

```dart
// providers/accelerometer_provider.dart
final accelerometerProvider = StreamProvider<AccelerometerData>((ref) {
  final repository = ref.read(accelerometerRepositoryProvider);
  return repository.getAccelerationStream();
});
```

### 3. UI Implementation

```dart
// screens/accelerometer_screen.dart
class AccelerometerScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accelerometerAsync = ref.watch(accelerometerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Accelerometer')),
      body: accelerometerAsync.when(
        data: (data) => AccelerometerDisplay(data: data),
        loading: () => CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
      ),
    );
  }
}
```

---

## 📱 Usage Examples

### Motion Detection

```dart
class MotionDetector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accelerometerAsync = ref.watch(accelerometerProvider);

    return accelerometerAsync.when(
      data: (data) {
        final isMoving = data.magnitude > 2.0;
        return Container(
          color: isMoving ? Colors.red : Colors.green,
          child: Text(isMoving ? 'Moving' : 'Still'),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (_, __) => Text('Sensor not available'),
    );
  }
}
```

### Activity Recognition

```dart
class ActivityRecognizer {
  static ActivityType recognizeActivity(List<AccelerometerData> samples) {
    final avgMagnitude = samples
        .map((s) => s.magnitude)
        .reduce((a, b) => a + b) / samples.length;

    if (avgMagnitude < 1.2) return ActivityType.sitting;
    if (avgMagnitude < 2.0) return ActivityType.walking;
    if (avgMagnitude < 4.0) return ActivityType.running;
    return ActivityType.workout;
  }
}
```

---

## 🔧 Customization Options

### Sampling Rate Configuration

```dart
class AccelerometerConfig {
  static const Duration samplingInterval = Duration(milliseconds: 100);
  static const double motionThreshold = 1.5;
  static const int bufferSize = 50;
}
```

### Data Filtering

```dart
class AccelerometerFilter {
  static AccelerometerData lowPassFilter(
    AccelerometerData current,
    AccelerometerData previous,
    double alpha,
  ) {
    return AccelerometerData(
      x: alpha * current.x + (1 - alpha) * previous.x,
      y: alpha * current.y + (1 - alpha) * previous.y,
      z: alpha * current.z + (1 - alpha) * previous.z,
      timestamp: current.timestamp,
    );
  }
}
```

---

## 🧪 Testing

### Unit Tests

```dart
void main() {
  group('AccelerometerData', () {
    test('calculates magnitude correctly', () {
      final data = AccelerometerData(
        x: 3.0,
        y: 4.0,
        z: 0.0,
        timestamp: DateTime.now(),
      );

      expect(data.magnitude, equals(5.0));
    });
  });
}
```

---

This module provides essential motion sensing capabilities that can be extended for various applications including fitness tracking, gesture recognition, and device orientation detection.
