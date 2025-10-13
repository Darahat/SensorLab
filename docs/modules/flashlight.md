# 🔦 Flashlight Module Documentation

## Overview

The flashlight module provides device LED torch control with brightness adjustment and strobe functionality for utility and emergency applications.

## Features

- LED torch on/off control
- Brightness level adjustment
- Strobe mode with customizable intervals
- Battery-aware operation
- Emergency SOS patterns

## Integration

```yaml
dependencies:
  torch_light: ^1.0.0
  permission_handler: ^11.1.0
```

```dart
// Entity
class FlashlightState {
  final bool isOn;
  final double brightness;
  final bool isStrobeMode;
  final int strobeInterval;
  final DateTime lastToggled;

  const FlashlightState({
    this.isOn = false,
    this.brightness = 1.0,
    this.isStrobeMode = false,
    this.strobeInterval = 500,
    required this.lastToggled,
  });
}

// Controller
class FlashlightController extends StateNotifier<FlashlightState> {
  Timer? _strobeTimer;

  FlashlightController() : super(
    FlashlightState(lastToggled: DateTime.now())
  );

  Future<void> toggle() async {
    try {
      if (state.isOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }
      state = state.copyWith(
        isOn: !state.isOn,
        lastToggled: DateTime.now(),
      );
    } catch (e) {
      // Handle torch error
    }
  }

  void startStrobe(int intervalMs) {
    _strobeTimer?.cancel();
    _strobeTimer = Timer.periodic(
      Duration(milliseconds: intervalMs),
      (_) => toggle(),
    );
    state = state.copyWith(
      isStrobeMode: true,
      strobeInterval: intervalMs,
    );
  }
}
```

## Permissions

```xml
<!-- Android -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.FLASHLIGHT" />
```

## Use Cases

- Emergency lighting
- Photography assistance
- Security applications
- Utility lighting
- Signal transmission

