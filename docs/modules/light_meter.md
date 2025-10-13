# 💡 Light Meter Module Documentation

## Overview

Measures ambient light levels using the device's light sensor, providing lux measurements for photography, indoor/outdoor detection, and environmental monitoring.

## Features

- Real-time light level measurement
- Lux unit display
- Light condition categorization
- Photography light assessment
- Auto-brightness recommendations

## Integration

```yaml
dependencies:
  light: ^3.0.1
  flutter_riverpod: ^2.4.9
```

```dart
// Entity
class LightData {
  final double luxValue;
  final DateTime timestamp;

  String get lightCondition {
    if (luxValue < 1) return 'Dark';
    if (luxValue < 50) return 'Very Dim';
    if (luxValue < 200) return 'Dim';
    if (luxValue < 500) return 'Normal Indoor';
    if (luxValue < 1000) return 'Bright Indoor';
    if (luxValue < 5000) return 'Very Bright';
    return 'Direct Sunlight';
  }
}

// Provider
final lightProvider = StreamProvider<LightData>((ref) {
  return Light().lightSensorStream.map((luxValue) =>
    LightData(luxValue: luxValue, timestamp: DateTime.now())
  );
});
```

## Use Cases

- Photography light metering
- Auto-brightness adjustment
- Indoor/outdoor detection
- Sleep cycle optimization
- Energy efficiency monitoring
