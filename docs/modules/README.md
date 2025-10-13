# 📚 Module Documentation Index

## Overview

SensorLab provides a comprehensive collection of sensor modules and utilities for Flutter applications. Each module is designed with Clean Architecture principles and includes complete integration guides.

## 📊 Sensor Modules

### Motion & Position

- **[Accelerometer](accelerometer.md)** - 3-axis acceleration measurement with gesture detection
- **[Gyroscope](gyroscope.md)** - Angular velocity measurement and device rotation tracking
- **[Compass](compass.md)** - Magnetic orientation detection with cardinal directions
- **[Geolocator](geolocator.md)** - GPS positioning with distance calculations and geofencing

### Environmental

- **[Light Meter](light_meter.md)** - Ambient light measurement for photography and brightness control
- **[Noise Meter](noise_meter.md)** - Sound level measurement with decibel readings
- **[Humidity](humidity.md)** - Environmental moisture monitoring with comfort indicators
- **[Proximity](proximity.md)** - Object detection for screen management and gestures

### Health & Biometrics

- **[Health](health.md)** - Comprehensive health tracking with activity monitoring
- **[Heart Beat](../screens/heart_beat_provider.dart)** - Heart rate monitoring using camera-based photoplethysmography

### Utility & Control

- **[QR Scanner](qr_scanner.md)** - Advanced QR/barcode scanning with batch processing
- **[Flashlight](flashlight.md)** - LED torch control with brightness and strobe modes
- **[App Settings](app_settings.md)** - Centralized configuration and user preferences

## 🏗️ Architecture Overview

All modules follow the same architectural pattern:

```
lib/
├── models/           # Data entities and value objects
├── services/         # Business logic and use cases
├── screens/          # UI presentation layer
└── widgets/          # Reusable UI components
```

### Common Patterns

#### Entity Definition

```dart
class SensorData {
  final double value;
  final DateTime timestamp;
  final String? unit;

  // Add computed properties and validation
}
```

#### Provider Implementation

```dart
final sensorProvider = StreamProvider<SensorData>((ref) {
  return SensorService().dataStream.map((data) =>
    SensorData(value: data, timestamp: DateTime.now())
  );
});
```

#### Screen Structure

```dart
class SensorScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorData = ref.watch(sensorProvider);

    return sensorData.when(
      data: (data) => SensorDisplay(data: data),
      loading: () => LoadingIndicator(),
      error: (error, _) => ErrorDisplay(error: error),
    );
  }
}
```

## 🔧 Integration Guide

### Quick Start

1. Add required dependencies to `pubspec.yaml`
2. Configure permissions for target platforms
3. Initialize providers in your app
4. Implement UI components or use provided screens

### Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  sensors_plus: ^4.0.2
  permission_handler: ^11.1.0
  # Module-specific dependencies listed in each module doc
```

### Permissions Setup

#### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.VIBRATE" />
```

#### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access required for QR scanning and heart rate monitoring</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location access required for GPS features</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access required for noise level measurement</string>
```

## 📱 Platform Support

| Module        | Android | iOS | Web | Windows | macOS | Linux |
| ------------- | ------- | --- | --- | ------- | ----- | ----- |
| Accelerometer | ✅      | ✅  | ❌  | ❌      | ❌    | ❌    |
| Gyroscope     | ✅      | ✅  | ❌  | ❌      | ❌    | ❌    |
| Compass       | ✅      | ✅  | ❌  | ❌      | ❌    | ❌    |
| Geolocator    | ✅      | ✅  | ✅  | ✅      | ✅    | ✅    |
| Light Meter   | ✅      | ✅  | ❌  | ❌      | ❌    | ❌    |
| Noise Meter   | ✅      | ✅  | ❌  | ❌      | ❌    | ❌    |
| QR Scanner    | ✅      | ✅  | ✅  | ❌      | ❌    | ❌    |
| Flashlight    | ✅      | ✅  | ❌  | ❌      | ❌    | ❌    |

## 🎯 Usage Examples

### Basic Sensor Reading

```dart
// Watch sensor data
final accelerometer = ref.watch(accelerometerProvider);

accelerometer.when(
  data: (data) => Text('X: ${data.x.toStringAsFixed(2)}'),
  loading: () => CircularProgressIndicator(),
  error: (error, _) => Text('Error: $error'),
);
```

### Custom Integration

```dart
// Create custom provider combining multiple sensors
final motionProvider = Provider<MotionData>((ref) {
  final accel = ref.watch(accelerometerProvider).value;
  final gyro = ref.watch(gyroscopeProvider).value;

  return MotionData(
    acceleration: accel,
    rotation: gyro,
    timestamp: DateTime.now(),
  );
});
```

## 🔍 Advanced Features

### Data Processing

- Real-time filtering and smoothing
- Calibration and offset correction
- Multi-sensor fusion algorithms
- Statistical analysis and trending

### Export & Sharing

- CSV/JSON data export
- Real-time data streaming
- Cloud synchronization
- Batch processing capabilities

### Customization

- Configurable update rates
- Custom UI themes and layouts
- Localization support (4 languages)
- Accessibility features

## 📖 Additional Resources

- **[Project Architecture](../PROJECT_ARCHITECTURE.md)** - Complete technical architecture overview
- **[Main README](../../README.md)** - Setup instructions and project overview
- **[Release Notes](../../RELEASE_NOTES.md)** - Latest updates and improvements

## 🤝 Contributing

When adding new modules, follow these guidelines:

1. **Structure**: Follow the established Clean Architecture pattern
2. **Documentation**: Create comprehensive module documentation
3. **Testing**: Include unit and integration tests
4. **Localization**: Add translations for all user-facing text
5. **Platform Support**: Document platform-specific limitations

For detailed contribution guidelines, see the main README.md file.
