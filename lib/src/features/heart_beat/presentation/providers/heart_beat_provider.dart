import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torch_light/torch_light.dart';

import '../../models/heart_beat_data.dart';

class HeartBeatNotifier extends StateNotifier<HeartBeatData> {
  CameraController? _cameraController;
  late TorchLight _torchController;
  Timer? _warningTimer;

  HeartBeatNotifier() : super(HeartBeatData.initial()) {
    _torchController = TorchLight();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        state = state.copyWith(
          status: HeartRateStatus.error,
          statusMessage: 'No cameras found',
        );
        return;
      }

      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium, // Reduced from high to medium
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420, // Specify format
      );

      await _cameraController!.initialize();

      state = state.copyWith(
        isInitialized: true,
        status: HeartRateStatus.ready,
        statusMessage: 'Ready - Cover camera with finger',
      );

      _startMonitoring();
      _checkEnvironment();
    } on CameraException catch (e) {
      state = state.copyWith(
        status: HeartRateStatus.error,
        statusMessage: 'Camera error: ${e.description}',
      );
    } catch (e) {
      state = state.copyWith(
        status: HeartRateStatus.error,
        statusMessage: 'Error: ${e.toString()}',
      );
    }
  }

  void _checkEnvironment() {
    if (state.showSoundWarning) {
      state = state.copyWith(warningStartTime: DateTime.now());

      _warningTimer = Timer(const Duration(seconds: 5), () {
        if (!mounted) return;
        state = state.copyWith(showSoundWarning: false);
      });
    }
  }

  void dismissWarning() {
    _warningTimer?.cancel();
    state = state.copyWith(showSoundWarning: false);
  }

  void pauseMonitoring() {
    try {
      _cameraController?.stopImageStream();
      state = state.copyWith(
        status: HeartRateStatus.ready,
        statusMessage: 'Paused - Camera in use by another feature',
      );
    } catch (e) {
      // Camera might already be stopped
    }
  }

  void resumeMonitoring() {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      state = state.copyWith(
        status: HeartRateStatus.ready,
        statusMessage: 'Ready - Cover camera with finger',
      );
      _startMonitoring();
    }
  }

  void _startMonitoring() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    _cameraController!.startImageStream((CameraImage? image) {
      if (image == null ||
          image.planes.isEmpty ||
          !mounted ||
          state.isDetecting) {
        return;
      }

      state = state.copyWith(isDetecting: true);

      try {
        final plane = image.planes[0];
        if (plane.bytes.isEmpty) return;

        final total = plane.bytes.fold<int>(0, (sum, byte) => sum + byte);
        final avg = total ~/ plane.bytes.length;

        final newSamples = List<int>.from(state.samples)..add(avg);
        if (newSamples.length > 50) {
          // Reduced buffer size from 100 to 50
          newSamples.removeRange(0, newSamples.length - 50);
        }

        state = state.copyWith(samples: newSamples);

        if (newSamples.length > 30) {
          // Reduced from 100 to 30
          _calculateBPM();
        }
      } catch (e) {
        // Handle error silently
      } finally {
        state = state.copyWith(isDetecting: false);
      }
    });
  }

  void _calculateBPM() {
    if (state.samples.length < 50) {
      state = state.copyWith(
        status: HeartRateStatus.fingerNotDetected,
        statusMessage: 'Place finger firmly on camera',
      );
      return;
    }

    final currentAvg =
        state.samples.reduce((a, b) => a + b) / state.samples.length;
    final currentVariation = _calculateVariation(state.samples);

    if (!state.fingerDetected) {
      if (state.samples.length > 30 && currentVariation > 5) {
        state = state.copyWith(
          fingerDetected: true,
          baselineBrightness: currentAvg,
          status: HeartRateStatus.measuring,
          statusMessage: 'Measuring...',
        );
      } else {
        state = state.copyWith(
          status: HeartRateStatus.fingerNotDetected,
          statusMessage: 'Place finger firmly on camera',
        );
        return;
      }
    }

    if (state.fingerDetected && currentVariation < 2) {
      state = state.copyWith(
        fingerDetected: false,
        stableReadings: 0,
        bpmHistory: [],
        status: HeartRateStatus.fingerMoved,
        statusMessage: 'Finger moved! Place firmly on camera',
        bpm: 0,
      );
      return;
    }

    final threshold = max(state.baselineBrightness * 0.015, 3.0);
    final peaks = _findValidPeaks(threshold);

    if (peaks.length >= 2) {
      final bpm = _calculateValidBPM(peaks);

      if (bpm != null) {
        final newBpmHistory = List<double>.from(state.bpmHistory)..add(bpm);
        if (newBpmHistory.length > 5) newBpmHistory.removeAt(0);

        final smoothedBpm =
            newBpmHistory.reduce((a, b) => a + b) / newBpmHistory.length;

        state = state.copyWith(
          bpm: smoothedBpm.round(),
          bpmHistory: newBpmHistory,
          stableReadings: state.stableReadings + 1,
          status: HeartRateStatus.measuring,
          statusMessage: 'Heart rate: ${smoothedBpm.round()} BPM',
          lastValidBpm: smoothedBpm,
          lastValidReading: DateTime.now(),
        );
        return;
      }
    }

    if (state.stableReadings > 0) {
      state = state.copyWith(
        stableReadings: state.stableReadings - 1,
        status: HeartRateStatus.holdStill,
        statusMessage: 'Hold still...',
      );
    } else {
      state = state.copyWith(
        status: HeartRateStatus.adjustPressure,
        statusMessage: 'Adjust finger pressure',
        bpm: 0,
      );
    }
  }

  double? _calculateValidBPM(List<int> peaks) {
    List<int> intervals = [];
    for (int i = 1; i < peaks.length; i++) {
      intervals.add(peaks[i] - peaks[i - 1]);
    }

    final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
    intervals = intervals
        .where((i) => (i - avgInterval).abs() < avgInterval * 0.4)
        .toList();

    if (intervals.length >= 2) {
      final validInterval =
          intervals.reduce((a, b) => a + b) / intervals.length;
      final calculatedBpm = (60 * 30) / validInterval; // Assuming 30fps

      if (calculatedBpm >= 40 && calculatedBpm <= 150) {
        return calculatedBpm;
      }
    }
    return null;
  }

  double _calculateVariation(List<int> samples) {
    final avg = samples.reduce((a, b) => a + b) / samples.length;
    return samples.map((s) => (s - avg).abs()).reduce((a, b) => a + b) /
        samples.length;
  }

  List<int> _findValidPeaks(double threshold) {
    final List<int> peaks = [];
    for (int i = 1; i < state.samples.length - 1; i++) {
      if (state.samples[i] > state.samples[i - 1] + threshold &&
          state.samples[i] > state.samples[i + 1] + threshold) {
        peaks.add(i);
      }
    }
    return peaks;
  }

  Future<void> toggleFlash() async {
    try {
      if (_cameraController == null ||
          !_cameraController!.value.isInitialized) {
        return;
      }

      await _cameraController!.setFlashMode(
        state.isFlashOn ? FlashMode.off : FlashMode.torch,
      );

      state = state.copyWith(isFlashOn: !state.isFlashOn);
    } catch (e) {
      state = state.copyWith(
        status: HeartRateStatus.error,
        statusMessage: 'Flash error: ${e.toString()}',
      );
    }
  }

  void reset() {
    state = state.copyWith(
      bpm: 0,
      samples: [],
      bpmHistory: [],
      fingerDetected: false,
      stableReadings: 0,
      status: HeartRateStatus.ready,
      statusMessage: 'Ready - Cover camera with finger',
    );
  }

  CameraController? get cameraController => _cameraController;

  @override
  @override
  void dispose() {
    _warningTimer?.cancel();
    if (state.isFlashOn) {
      TorchLight.disableTorch();
    }
    try {
      _cameraController?.stopImageStream();
    } catch (e) {
      // Image stream might already be stopped
    }
    _cameraController?.dispose();
    super.dispose();
  }
}

final heartBeatProvider =
    StateNotifierProvider<HeartBeatNotifier, HeartBeatData>(
      (ref) => HeartBeatNotifier(),
    );
