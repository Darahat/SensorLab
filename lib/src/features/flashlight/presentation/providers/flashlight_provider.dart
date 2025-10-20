import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torch_light/torch_light.dart';

import '../../models/flashlight_data.dart';

/// Provider for flashlight functionality
final flashlightProvider =
    StateNotifierProvider<FlashlightNotifier, FlashlightData>((ref) {
      return FlashlightNotifier();
    });

/// State notifier for managing flashlight data and operations
class FlashlightNotifier extends StateNotifier<FlashlightData> {
  FlashlightNotifier() : super(const FlashlightData());

  Timer? _onTimeTracker;
  Timer? _strobeTimer;
  Timer? _sosTimer;
  bool _sosState = false;
  int _sosStep = 0;

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }

  /// Initialize flashlight controller
  Future<void> initialize() async {
    try {
      // Check if torch is available on device
      final isAvailable = await TorchLight.isTorchAvailable();

      if (!isAvailable) {
        state = state.copyWith(
          isInitialized: true,
          isAvailable: false,
          errorMessage: 'Torch not available on this device',
        );
        return;
      }

      // Check if intensity control is supported (typically iOS)
      final supportsIntensity = Platform.isIOS;

      state = state.copyWith(
        isInitialized: true,
        isAvailable: true,
        supportsIntensity: supportsIntensity,
        sessionStartTime: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isInitialized: false,
        isAvailable: false,
        errorMessage: 'Failed to initialize flashlight: $e',
      );
    }
  }

  /// Toggle flashlight on/off
  Future<void> toggleFlashlight() async {
    if (!state.isInitialized || !state.isAvailable) {
      await initialize();
      if (!state.isInitialized) return;
    }

    try {
      if (state.isOn) {
        await _turnOff();
      } else {
        await _turnOn();
      }

      // Update toggle count and last toggle time
      state = state.copyWith(
        toggleCount: state.toggleCount + 1,
        lastToggleTime: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to toggle flashlight: $e');
    }
  }

  /// Turn flashlight on
  Future<void> _turnOn() async {
    try {
      await TorchLight.enableTorch();
      state = state.copyWith(isOn: true);
    } on EnableTorchExistentUserException {
      // The camera is in use
      state = state.copyWith(errorMessage: 'Camera is in use');
    } on EnableTorchNotAvailableException {
      // Torch was not detected
      state = state.copyWith(errorMessage: 'Torch not available');
    } on EnableTorchException {
      // Torch could not be enabled due to another error
      state = state.copyWith(errorMessage: 'Failed to enable torch');
    }

    // Start tracking on-time
    _startOnTimeTracking();
  }

  /// Turn flashlight off
  Future<void> _turnOff() async {
    try {
      await TorchLight.disableTorch();
      state = state.copyWith(isOn: false);
    } on DisableTorchExistentUserException {
      // The camera is in use
      state = state.copyWith(errorMessage: 'Camera is in use');
    } on DisableTorchNotAvailableException {
      // Torch was not detected
      state = state.copyWith(errorMessage: 'Torch not available');
    } on DisableTorchException {
      // Torch could not be disabled due to another error
      state = state.copyWith(errorMessage: 'Failed to disable torch');
    }

    // Stop tracking on-time
    _stopOnTimeTracking();
    _stopSpecialModes();
  }

  /// Set flashlight intensity (Note: torch_light package doesn't support intensity control)
  Future<void> setIntensity(double intensity) async {
    // torch_light package doesn't support intensity control
    // This is a placeholder for future implementation or alternative packages
    state = state.copyWith(
      errorMessage: 'Intensity control not supported by torch_light package',
    );

    // For UI purposes, still update the intensity value
    final clampedIntensity = intensity.clamp(0.0, 1.0);
    state = state.copyWith(intensity: clampedIntensity);
  }

  /// Set flashlight mode
  Future<void> setMode(FlashlightMode mode) async {
    if (!state.isInitialized || !state.isAvailable) return;

    try {
      // Stop current special modes
      _stopSpecialModes();

      state = state.copyWith(mode: mode);

      // Start new mode if flashlight is on
      if (state.isOn) {
        switch (mode) {
          case FlashlightMode.normal:
            // Already handled by stopping special modes
            break;
          case FlashlightMode.strobe:
            _startStrobe();
            break;
          case FlashlightMode.sos:
            _startSOS();
            break;
        }
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to set mode: $e');
    }
  }

  /// Start strobe mode
  void _startStrobe() {
    _strobeTimer = Timer.periodic(const Duration(milliseconds: 200), (
      timer,
    ) async {
      try {
        // Simple strobe: toggle between on and off
        if (state.isOn) {
          await TorchLight.disableTorch();
          state = state.copyWith(isOn: false);
        } else {
          await TorchLight.enableTorch();
          state = state.copyWith(isOn: true);
        }
      } catch (e) {
        // Handle error silently or log it
      }
    });
  }

  /// Start SOS mode (... --- ...)
  void _startSOS() {
    _sosStep = 0;
    _sosState = false;
    _nextSOSStep();
  }

  /// Execute next step in SOS pattern
  void _nextSOSStep() {
    const sosPattern = [
      100, 100, 100, 100, 100, 100, // ... (3 short)
      300, 300, 300, 300, 300, 300, // --- (3 long)
      100, 100, 100, 100, 100, 100, // ... (3 short)
      1000, // pause
    ];

    if (_sosStep >= sosPattern.length) {
      _sosStep = 0;
    }

    final duration = sosPattern[_sosStep];
    final isOn = _sosStep.isEven;

    _sosTimer = Timer(Duration(milliseconds: duration), () async {
      try {
        if (isOn) {
          await TorchLight.enableTorch();
          state = state.copyWith(isOn: true);
        } else {
          await TorchLight.disableTorch();
          state = state.copyWith(isOn: false);
        }

        _sosStep++;
        if (state.mode == FlashlightMode.sos && state.isOn) {
          _nextSOSStep();
        }
      } catch (e) {
        // Handle error silently
      }
    });
  }

  /// Start tracking flashlight on-time
  void _startOnTimeTracking() {
    _onTimeTracker = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(totalOnTime: state.totalOnTime + 1);
    });
  }

  /// Stop tracking flashlight on-time
  void _stopOnTimeTracking() {
    _onTimeTracker?.cancel();
    _onTimeTracker = null;
  }

  /// Stop special modes (strobe, SOS)
  void _stopSpecialModes() {
    _strobeTimer?.cancel();
    _strobeTimer = null;
    _sosTimer?.cancel();
    _sosTimer = null;
  }

  /// Reset all session data
  void resetSession() {
    if (state.isOn) {
      toggleFlashlight();
    }

    state = state.copyWith(
      totalOnTime: 0,
      toggleCount: 0,
      sessionStartTime: DateTime.now(),
      mode: FlashlightMode.normal,
    );
  }

  /// Quick flash (brief on/off)
  Future<void> quickFlash({int durationMs = 100}) async {
    if (!state.isInitialized || !state.isAvailable) return;
    if (state.isOn) return; // Don't flash if already on

    try {
      // Turn on
      await TorchLight.enableTorch();
      state = state.copyWith(isOn: true);

      // Wait for specified duration
      await Future.delayed(Duration(milliseconds: durationMs));

      // Turn off
      await TorchLight.disableTorch();
      state = state.copyWith(isOn: false);

      state = state.copyWith(
        toggleCount: state.toggleCount + 2, // Count both on and off
        lastToggleTime: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to perform quick flash: $e');
    }
  }

  /// Clean up resources
  void _cleanup() {
    _stopOnTimeTracking();
    _stopSpecialModes();

    // Turn off flashlight if it's on
    if (state.isOn) {
      try {
        TorchLight.disableTorch();
      } catch (e) {
        // Ignore errors during cleanup
      }
    }
  }
}
