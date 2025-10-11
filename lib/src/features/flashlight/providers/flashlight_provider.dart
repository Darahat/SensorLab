import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torch_controller/torch_controller.dart';

import '../models/flashlight_data.dart';

/// Provider for flashlight functionality
final flashlightProvider =
    StateNotifierProvider<FlashlightNotifier, FlashlightData>((ref) {
      return FlashlightNotifier();
    });

/// State notifier for managing flashlight data and operations
class FlashlightNotifier extends StateNotifier<FlashlightData> {
  FlashlightNotifier() : super(const FlashlightData());

  final TorchController _controller = TorchController();
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
      // Initialize torch controller
      await _controller.initialize();

      // Check if intensity control is supported (typically iOS)
      final supportsIntensity = Platform.isIOS;

      state = state.copyWith(
        isInitialized: true,
        isAvailable: true,
        supportsIntensity: supportsIntensity,
        sessionStartTime: DateTime.now(),
        errorMessage: null,
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
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to toggle flashlight: $e');
    }
  }

  /// Turn flashlight on
  Future<void> _turnOn() async {
    await _controller.toggle(
      intensity: state.supportsIntensity ? state.intensity : null,
    );

    state = state.copyWith(isOn: true);

    // Start tracking on-time
    _startOnTimeTracking();
  }

  /// Turn flashlight off
  Future<void> _turnOff() async {
    await _controller.toggle();

    state = state.copyWith(isOn: false);

    // Stop tracking on-time
    _stopOnTimeTracking();
    _stopSpecialModes();
  }

  /// Set flashlight intensity (iOS only)
  Future<void> setIntensity(double intensity) async {
    if (!state.supportsIntensity) {
      state = state.copyWith(
        errorMessage: 'Intensity control not supported on this device',
      );
      return;
    }

    try {
      final clampedIntensity = intensity.clamp(0.0, 1.0);

      state = state.copyWith(intensity: clampedIntensity, errorMessage: null);

      // If flashlight is on, update the intensity
      if (state.isOn) {
        await _controller.toggle(intensity: clampedIntensity);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to set intensity: $e');
    }
  }

  /// Set flashlight mode
  Future<void> setMode(FlashlightMode mode) async {
    if (!state.isInitialized || !state.isAvailable) return;

    try {
      // Stop current special modes
      _stopSpecialModes();

      state = state.copyWith(mode: mode, errorMessage: null);

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
        await _controller.toggle(
          intensity: state.supportsIntensity ? state.intensity : null,
        );
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

    _sosTimer = Timer(Duration(milliseconds: duration), () {
      if (isOn) {
        _controller.toggle(
          intensity: state.supportsIntensity ? state.intensity : null,
        );
      } else {
        _controller.toggle(); // Turn off
      }

      _sosStep++;
      if (state.mode == FlashlightMode.sos && state.isOn) {
        _nextSOSStep();
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
      lastToggleTime: null,
      mode: FlashlightMode.normal,
      errorMessage: null,
    );
  }

  /// Quick flash (brief on/off)
  Future<void> quickFlash({int durationMs = 100}) async {
    if (!state.isInitialized || !state.isAvailable) return;
    if (state.isOn) return; // Don't flash if already on

    try {
      // Turn on
      await _controller.toggle(
        intensity: state.supportsIntensity ? state.intensity : null,
      );

      // Wait for specified duration
      await Future.delayed(Duration(milliseconds: durationMs));

      // Turn off
      await _controller.toggle();

      state = state.copyWith(
        toggleCount: state.toggleCount + 2, // Count both on and off
        lastToggleTime: DateTime.now(),
        errorMessage: null,
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
        _controller.toggle();
      } catch (e) {
        // Ignore errors during cleanup
      }
    }
  }
}
