import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({super.key});

  @override
  _HeartRateScreenState createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  CameraController? _cameraController;
  late TorchController controller;
  bool _isDetecting = false;
  int _bpm = 0;
  List<int> _samples = [];
  bool _isFlashOn = false;
  bool _isInitialized = false;
  String _statusMessage = 'Initializing...';
  bool _isStreamRunning = false;
  double _lastValidBpm = 0;
  DateTime _lastValidReading = DateTime.now();
  bool _fingerDetected = false;
  bool _showSoundWarning = true;
  final _vibrationDuration = Duration(milliseconds: 200);
  double _baselineBrightness = 0;
  int _stableReadings = 0;
  List<double> _bpmHistory = [];
  DateTime? _warningStartTime;
  @override
  void initState() {
    super.initState();
    controller = TorchController();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _statusMessage = 'No cameras found');
        return;
      }

      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _isInitialized = true;
          _statusMessage = 'Ready - Cover camera with finger';
        });
        _startMonitoring();
      });
    } on CameraException catch (e) {
      setState(() => _statusMessage = 'Camera error: ${e.description}');
    } catch (e) {
      setState(() => _statusMessage = 'Error: ${e.toString()}');
    }
  }

  void _checkEnvironment() {
    if (_showSoundWarning) {
      _warningStartTime = DateTime.now();

      // Vibrate (optional - requires vibration package)
      try {
        // Uncomment if you have vibration package:
        // Vibration.vibrate(duration: _vibrationDuration.inMilliseconds);
      } catch (e) {
        debugPrint('Vibration error: $e');
      }

      Future.delayed(Duration(seconds: 5), () {
        if (mounted) {
          setState(() => _showSoundWarning = false);
        }
      });
    }
  }

  Widget _buildEnvironmentWarning() {
    if (!_showSoundWarning) return SizedBox.shrink();

    final elapsed =
        _warningStartTime != null
            ? DateTime.now().difference(_warningStartTime!).inSeconds
            : 0;
    final remaining = 5 - elapsed;

    return AnimatedOpacity(
      opacity: _showSoundWarning ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.amber[700]?.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Quiet environment needed ($remaining s)',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                if (mounted) {
                  setState(() => _showSoundWarning = false);
                }
              },
              child: Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  void _startMonitoring() {
    _checkEnvironment();
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    _cameraController!.startImageStream((CameraImage? image) {
      if (image == null || image.planes.isEmpty || !mounted || _isDetecting)
        return;

      _isDetecting = true;
      try {
        final plane = image.planes[0];
        if (plane.bytes.isEmpty) return;

        final total = plane.bytes.fold<int>(0, (sum, byte) => sum + byte);
        final avg = total ~/ plane.bytes.length;

        _samples.add(avg);
        if (_samples.length > 100) {
          _samples.removeAt(0);
          _calculateBPM();
        }
      } catch (e, stack) {
        debugPrint("Image analysis error: $e\n$stack");
      } finally {
        _isDetecting = false;
      }
    });
  }

  void _calculateBPM() {
    if (_samples.length < 50) {
      setState(() => _statusMessage = 'Place finger firmly on camera');
      return;
    }

    final currentAvg = _samples.reduce((a, b) => a + b) / _samples.length;
    final currentVariation = _calculateVariation(_samples);
    print(
      'Current Variation: $currentVariation, Baseline: $_baselineBrightness',
    );

    if (!_fingerDetected) {
      if (_samples.length > 30 && currentVariation > 5) {
        _fingerDetected = true;
        _baselineBrightness = currentAvg;
        setState(() => _statusMessage = 'Measuring...');
      } else {
        setState(() => _statusMessage = 'Press finger firmly on camera');
        return;
      }
    }

    if (_fingerDetected && currentVariation < 2) {
      _fingerDetected = false;
      _stableReadings = 0;
      _bpmHistory.clear();
      setState(() {
        _statusMessage = 'Finger moved! Place firmly on camera';
        _bpm = 0;
      });
      return;
    }

    // Adjust threshold if needed
    final threshold = max(_baselineBrightness * 0.015, 3.0);
    print('Using threshold: $threshold');

    final peaks = _findValidPeaks(threshold);

    if (peaks.length >= 2) {
      final bpm = _calculateValidBPM(peaks);

      if (bpm != null) {
        _bpmHistory.add(bpm);
        if (_bpmHistory.length > 5) _bpmHistory.removeAt(0);

        final smoothedBpm =
            _bpmHistory.reduce((a, b) => a + b) / _bpmHistory.length;

        setState(() {
          _bpm = smoothedBpm.round();
          _statusMessage = 'Heart rate: ${_bpm.round()} BPM';
        });
        _stableReadings++;
        return;
      }
    }

    if (_stableReadings > 0) {
      _stableReadings--;
      setState(() => _statusMessage = 'Hold still...');
    } else {
      setState(() {
        _statusMessage = 'Adjust finger pressure';
        _bpm = 0;
      });
    }
  }

  double? _calculateValidBPM(List<int> peaks) {
    List<int> intervals = [];
    for (int i = 1; i < peaks.length; i++) {
      intervals.add(peaks[i] - peaks[i - 1]);
    }

    // Filter irregular intervals
    final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
    intervals =
        intervals
            .where((i) => (i - avgInterval).abs() < avgInterval * 0.4)
            .toList();

    if (intervals.length >= 2) {
      final validInterval =
          intervals.reduce((a, b) => a + b) / intervals.length;
      final calculatedBpm = (60 * 30) / validInterval; // Assuming 30fps

      // Only accept reasonable values
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
    List<int> peaks = [];
    for (int i = 1; i < _samples.length - 1; i++) {
      if (_samples[i] > _samples[i - 1] + threshold &&
          _samples[i] > _samples[i + 1] + threshold) {
        peaks.add(i);
      }
    }
    return peaks;
  }

  Future<void> _toggleFlash() async {
    try {
      if (_cameraController == null ||
          !_cameraController!.value.isInitialized) {
        return;
      }

      await _cameraController!.setFlashMode(
        _isFlashOn ? FlashMode.off : FlashMode.torch,
      );

      if (mounted) {
        setState(() {
          _isFlashOn = !_isFlashOn;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _statusMessage = 'Flash error: ${e.toString()}');
      }
    }
  }

  Future<void> _stopCamera() async {
    try {
      if (_cameraController != null) {
        if (_isStreamRunning) {
          await _cameraController!.stopImageStream();
          _isStreamRunning = false;
        }
        await controller.toggle(); // Ensure flash is off
        await _cameraController!.dispose();
      }
    } catch (e) {
      debugPrint('Error stopping camera: $e');
    }
  }

  @override
  void dispose() {
    // Turn off flash first
    if (_isFlashOn) {
      controller.toggle();
    }
    // Then attempt to stop camera / image stream and dispose resources.
    // We intentionally don't await here because dispose cannot be async.
    // ignore: unawaited_futures
    _stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Rate Monitor'),
        actions: [
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: _toggleFlash,
            tooltip: 'Toggle flash',
          ),
        ],
      ),
      body:
          _isInitialized
              ? Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        if (_cameraController != null &&
                            _cameraController!.value.isInitialized)
                          CameraPreview(_cameraController!),
                        Column(
                          children: [
                            _buildEnvironmentWarning(),
                            Center(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _statusMessage,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Estimated Heart Rate',
                          style: TextStyle(fontSize: 18),
                        ),
                        const Text(
                          'Estimated Heart Rate',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '$_bpm BPM',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _toggleFlash,
                          child: Text(
                            _isFlashOn ? 'Turn Flash Off' : 'Turn Flash On',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(_statusMessage),
                  ],
                ),
              ),
    );
  }
}
