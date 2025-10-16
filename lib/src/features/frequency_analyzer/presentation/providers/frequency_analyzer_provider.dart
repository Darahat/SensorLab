import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/frequency_data.dart';

class FrequencyAnalyzerNotifier extends StateNotifier<FrequencyData> {
  StreamSubscription<NoiseReading>? _noiseSubscription;
  final List<double> _audioBuffer = [];
  Timer? _fftTimer;

  // FFT parameters
  static const int fftSize = 2048; // Power of 2 for FFT
  static const double sampleRate = 44100; // Standard audio sample rate
  static const int maxDisplayFrequency = 8000; // Show up to 8kHz

  FrequencyAnalyzerNotifier() : super(FrequencyData()) {
    _initialize();
  }

  Future<void> _initialize() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      return;
    }

    _startListening();
    _startFFTProcessing();
  }

  void _startListening() {
    try {
      final noiseMeter = NoiseMeter();
      _noiseSubscription = noiseMeter.noise.listen(
        (NoiseReading reading) {
          // Add audio sample to buffer
          // NoiseReading gives us dB, we'll simulate samples
          // In real implementation, you'd use audio recording package
          final amplitude = _dbToAmplitude(reading.meanDecibel);
          _audioBuffer.add(amplitude);

          // Keep buffer size manageable
          if (_audioBuffer.length > fftSize * 2) {
            _audioBuffer.removeRange(0, _audioBuffer.length - fftSize);
          }
        },
        onError: (error) {
          // Handle error silently
        },
        cancelOnError: false,
      );
    } catch (e) {
      // Handle initialization error
    }
  }

  void _startFFTProcessing() {
    // Process FFT every 100ms for real-time display
    _fftTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_audioBuffer.length >= fftSize) {
        _processFFT();
      }
    });
  }

  void _processFFT() {
    // Get the last fftSize samples
    final samples = _audioBuffer.sublist(
      math.max(0, _audioBuffer.length - fftSize),
    );

    // Apply Hamming window to reduce spectral leakage
    final windowed = _applyHammingWindow(samples);

    // Perform FFT
    final fftResult = _performFFT(windowed);

    // Calculate magnitudes
    final magnitudes = _calculateMagnitudes(fftResult);

    // Update state with new frequency data
    state = FrequencyData.fromFFT(
      fftMagnitudes: magnitudes,
      sampleRate: sampleRate,
      maxFrequency: maxDisplayFrequency,
    );
  }

  /// Apply Hamming window to reduce spectral leakage
  List<double> _applyHammingWindow(List<double> samples) {
    final n = samples.length;
    final windowed = <double>[];

    for (int i = 0; i < n; i++) {
      final window = 0.54 - 0.46 * math.cos(2 * math.pi * i / (n - 1));
      windowed.add(samples[i] * window);
    }

    return windowed;
  }

  /// Perform FFT (Fast Fourier Transform)
  /// Simplified implementation - in production, use a proper FFT library
  List<List<double>> _performFFT(List<double> samples) {
    final n = samples.length;
    final real = List<double>.from(samples);
    final imag = List<double>.filled(n, 0.0);

    // Simple DFT for demonstration (slow but works)
    // In production, use package like 'fftea' or 'scidart'
    final freqReal = <double>[];
    final freqImag = <double>[];

    // Only compute first half (positive frequencies)
    final halfN = n ~/ 2;

    for (int k = 0; k < halfN; k++) {
      double sumReal = 0;
      double sumImag = 0;

      for (int n = 0; n < real.length; n++) {
        final angle = -2 * math.pi * k * n / real.length;
        sumReal += real[n] * math.cos(angle);
        sumImag += real[n] * math.sin(angle);
      }

      freqReal.add(sumReal);
      freqImag.add(sumImag);
    }

    return [freqReal, freqImag];
  }

  /// Calculate magnitudes from FFT result
  List<double> _calculateMagnitudes(List<List<double>> fftResult) {
    final real = fftResult[0];
    final imag = fftResult[1];
    final magnitudes = <double>[];

    for (int i = 0; i < real.length; i++) {
      final magnitude = math.sqrt(real[i] * real[i] + imag[i] * imag[i]);
      // Normalize
      magnitudes.add(magnitude / real.length);
    }

    // Apply log scale for better visualization
    final logMagnitudes = magnitudes.map((mag) {
      if (mag <= 0) return 0.0;
      // Convert to dB scale
      final db = 20 * math.log(mag) / math.ln10;
      // Normalize to 0-1 range (assuming -60dB to 0dB range)
      return ((db + 60) / 60).clamp(0.0, 1.0);
    }).toList();

    return logMagnitudes;
  }

  /// Convert dB to amplitude (0-1 range)
  double _dbToAmplitude(double db) {
    // Convert dB to linear amplitude
    // Reference: 0 dB = 1.0 amplitude
    final amplitude = math.pow(10, db / 20);
    return amplitude.toDouble().clamp(0.0, 1.0);
  }

  void pause() {
    _fftTimer?.cancel();
    _noiseSubscription?.pause();
  }

  void resume() {
    _noiseSubscription?.resume();
    _startFFTProcessing();
  }

  void reset() {
    _audioBuffer.clear();
    state = FrequencyData();
  }

  @override
  void dispose() {
    _fftTimer?.cancel();
    _noiseSubscription?.cancel();
    super.dispose();
  }
}

final frequencyAnalyzerProvider =
    StateNotifierProvider<FrequencyAnalyzerNotifier, FrequencyData>(
      (ref) => FrequencyAnalyzerNotifier(),
    );
