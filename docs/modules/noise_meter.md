# 🔊 Noise Meter Module Documentation

## Overview

The noise meter module measures environmental sound levels using the device's microphone, providing decibel readings for acoustic analysis and noise monitoring.

## Features

- Real-time noise level measurement
- Decibel (dB) readings
- Sound level categorization
- Peak and average detection
- Noise exposure tracking

## Integration

```yaml
dependencies:
  noise_meter: ^5.0.1
  permission_handler: ^11.1.0
```

```dart
// Entity
class NoiseData {
  final double decibels;
  final double maxDecibels;
  final DateTime timestamp;

  String get noiseLevel {
    if (decibels < 30) return 'Very Quiet';
    if (decibels < 50) return 'Quiet';
    if (decibels < 70) return 'Moderate';
    if (decibels < 90) return 'Loud';
    return 'Very Loud';
  }

  bool get isHarmful => decibels > 85;
}

// Provider
final noiseProvider = StreamProvider<NoiseData>((ref) {
  final noiseMeter = NoiseMeter();
  return noiseMeter.noise.map((reading) => NoiseData(
    decibels: reading.decibel,
    maxDecibels: reading.maxDecibel,
    timestamp: DateTime.now(),
  ));
});
```

## Permissions

```xml
<!-- Android -->
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.MICROPHONE" />
```

## Use Cases

- Environmental monitoring
- Occupational safety
- Sleep quality assessment
- Urban planning studies
- Hearing protection guidance
