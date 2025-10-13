# 💧 Humidity Module Documentation

## Overview

The humidity module monitors environmental moisture levels using device sensors or connected hardware, providing relative humidity measurements for comfort and health monitoring.

## Features

- Relative humidity measurement
- Comfort level indicators
- Dew point calculations
- Trend tracking
- Health recommendations

## Integration

```yaml
dependencies:
  sensors_plus: ^4.0.2
  flutter_riverpod: ^2.4.9
```

```dart
// Entity
class HumidityData {
  final double percentage;
  final double? temperature;
  final DateTime timestamp;

  String get comfortLevel {
    if (percentage < 30) return 'Too Dry';
    if (percentage < 40) return 'Dry';
    if (percentage <= 60) return 'Comfortable';
    if (percentage <= 70) return 'Humid';
    return 'Too Humid';
  }

  double? get dewPoint {
    if (temperature == null) return null;
    final a = 17.27;
    final b = 237.7;
    final alpha = ((a * temperature!) / (b + temperature!)) +
                 (percentage / 100).log();
    return (b * alpha) / (a - alpha);
  }
}

// Provider (Mock implementation for devices without humidity sensor)
final humidityProvider = StateProvider<HumidityData>((ref) {
  return HumidityData(
    percentage: 45.0,
    temperature: 22.0,
    timestamp: DateTime.now(),
  );
});
```

## Hardware Requirements

- Device with built-in humidity sensor (limited support)
- External humidity sensor via Bluetooth/WiFi
- Environmental station integration

## Use Cases

- Indoor air quality monitoring
- HVAC system optimization
- Health and comfort tracking
- Agricultural monitoring
- Weather station data

