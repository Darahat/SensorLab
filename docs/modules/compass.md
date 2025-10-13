# 🧭 Compass Module Documentation

## Overview

The compass module provides magnetic orientation detection using the device's magnetometer, offering accurate directional information for navigation and positioning applications.

## Features

- Real-time compass heading
- Cardinal direction display
- Magnetic declination correction
- Smooth rotation animations
- Calibration indicators

## Integration

```yaml
dependencies:
  flutter_compass: ^0.7.0
  sensors_plus: ^4.0.2
```

```dart
// Entity
class CompassData {
  final double? heading;
  final double? accuracy;
  final DateTime timestamp;

  String get cardinalDirection {
    if (heading == null) return 'Unknown';
    final directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((heading! + 22.5) / 45) % 8;
    return directions[index.floor()];
  }
}

// Provider
final compassProvider = StreamProvider<CompassData>((ref) {
  return FlutterCompass.events!.map((event) =>
    CompassData(
      heading: event.heading,
      accuracy: event.accuracy,
      timestamp: DateTime.now(),
    )
  );
});
```

## Use Cases

- Navigation and hiking
- Augmented reality applications
- Camera orientation
- Geographic surveys
- Educational compass apps
