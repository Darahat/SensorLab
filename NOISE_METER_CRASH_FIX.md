# Noise Meter Crash Fix - Root Cause Analysis

## Problem Summary

The app crashes when selecting noise meter in Custom Lab, but works fine without it.

## Root Cause

**Multiple `NoiseMeter()` instances competing for microphone access**

### The Conflict:

1. **Noise Meter Feature** (`lib/src/features/noise_meter/`)

   - Creates `NoiseMeter()` in `AcousticRepositoryImpl.noiseStream`
   - **No cleanup/disposal mechanism**
   - Instance persists even when not actively recording

2. **Custom Lab Feature** (`lib/src/features/custom_lab/`)
   - Creates `NoiseMeter()` in `SensorStreamService._initializeNoiseMeter()`
   - **Has proper cleanup** via `_cleanupNoiseMeter()`
3. **Frequency Analyzer Feature**
   - Also creates `NoiseMeter()` instances

### Why It Crashes:

- The `noise_meter` package uses native platform code to access the microphone
- **Only ONE instance can access the microphone at a time**
- When Custom Lab tries to create its `NoiseMeter()` while the standalone noise meter feature's instance is still active → **RESOURCE CONFLICT** → **CRASH**

## Changes Made

### ✅ Fixed: `lib/src/features/noise_meter/data/repositories/acoustic_repository_impl.dart`

**Before:**

```dart
class AcousticRepositoryImpl implements AcousticRepository {
  NoiseMeter? _noiseMeter;

  @override
  Stream<NoiseData> get noiseStream {
    _noiseMeter ??= NoiseMeter();  // ❌ Never cleaned up
    return _noiseMeter!.noise.map(...);  // ❌ No subscription management
  }
}
```

**After:**

```dart
class AcousticRepositoryImpl implements AcousticRepository {
  NoiseMeter? _noiseMeter;
  StreamSubscription? _noiseSubscription;  // ✅ Track subscription
  StreamController<NoiseData>? _controller;  // ✅ Controlled stream

  @override
  Stream<NoiseData> get noiseStream {
    _cleanup();  // ✅ Clean up first

    _controller = StreamController<NoiseData>.broadcast(
      onCancel: _cleanup,  // ✅ Auto-cleanup on cancel
    );

    _noiseMeter = NoiseMeter();
    _noiseSubscription = _noiseMeter!.noise.listen(...);

    return _controller!.stream;
  }

  void _cleanup() {  // ✅ Proper cleanup
    _noiseSubscription?.cancel();
    _noiseMeter = null;
    _controller?.close();
  }

  void dispose() {  // ✅ Public disposal
    _cleanup();
  }
}
```

## How the Fix Works

### 1. **Prevents Multiple Instances**

- `_cleanup()` is called before creating a new `NoiseMeter()`
- Ensures only ONE instance exists at a time

### 2. **Proper Resource Management**

- Subscriptions are tracked and cancelled
- Stream controllers are properly closed
- NoiseMeter instances are nullified

### 3. **Automatic Cleanup**

- `onCancel` callback ensures cleanup when stream is no longer needed
- `dispose()` method for manual cleanup

## Testing Recommendations

1. **Test Noise Meter Feature Alone**

   - Start recording
   - Stop recording
   - Verify no lingering instances

2. **Test Custom Lab with Noise Meter**

   - Select noise meter sensor
   - Start custom lab recording
   - Should NOT crash now

3. **Test Switching Between Features**
   - Use standalone noise meter
   - Switch to custom lab with noise meter
   - Switch back
   - No crashes or conflicts

## Additional Notes

### Other Features Using NoiseMeter:

- `frequency_analyzer` also creates `NoiseMeter()` instances
- May need similar fixes if conflicts arise

### Best Practice:

Always cleanup hardware sensor access (microphone, camera, etc.) when done to:

- Prevent resource conflicts
- Save battery
- Respect user privacy
- Prevent app crashes

## Related Files

- `lib/src/features/noise_meter/data/repositories/acoustic_repository_impl.dart` ✅ FIXED
- `lib/src/features/custom_lab/data/services/sensor_stream_service.dart` ✅ Already has cleanup
- `lib/src/features/frequency_analyzer/presentation/providers/frequency_analyzer_provider.dart` ⚠️ May need attention
