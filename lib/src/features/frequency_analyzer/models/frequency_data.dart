import 'dart:math' as math;

class FrequencyData {
  final List<double> frequencies; // Frequency bins in Hz
  final List<double> magnitudes; // Magnitude for each frequency
  final double dominantFrequency; // Most prominent frequency
  final double dominantMagnitude; // Magnitude of dominant frequency
  final double fundamentalFrequency; // Fundamental/base frequency
  final List<double> harmonics; // Harmonic frequencies
  final double spectralCentroid; // Weighted mean of frequencies
  final double
  spectralRolloff; // Frequency below which 85% of energy is contained
  final double bandwidth; // Frequency range with significant energy
  final DateTime timestamp;
  final bool isActive;

  FrequencyData({
    this.frequencies = const [],
    this.magnitudes = const [],
    this.dominantFrequency = 0,
    this.dominantMagnitude = 0,
    this.fundamentalFrequency = 0,
    this.harmonics = const [],
    this.spectralCentroid = 0,
    this.spectralRolloff = 0,
    this.bandwidth = 0,
    DateTime? timestamp,
    this.isActive = false,
  }) : timestamp = timestamp ?? DateTime.now();

  FrequencyData copyWith({
    List<double>? frequencies,
    List<double>? magnitudes,
    double? dominantFrequency,
    double? dominantMagnitude,
    double? fundamentalFrequency,
    List<double>? harmonics,
    double? spectralCentroid,
    double? spectralRolloff,
    double? bandwidth,
    DateTime? timestamp,
    bool? isActive,
  }) {
    return FrequencyData(
      frequencies: frequencies ?? this.frequencies,
      magnitudes: magnitudes ?? this.magnitudes,
      dominantFrequency: dominantFrequency ?? this.dominantFrequency,
      dominantMagnitude: dominantMagnitude ?? this.dominantMagnitude,
      fundamentalFrequency: fundamentalFrequency ?? this.fundamentalFrequency,
      harmonics: harmonics ?? this.harmonics,
      spectralCentroid: spectralCentroid ?? this.spectralCentroid,
      spectralRolloff: spectralRolloff ?? this.spectralRolloff,
      bandwidth: bandwidth ?? this.bandwidth,
      timestamp: timestamp ?? this.timestamp,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Update with new FFT data
  static FrequencyData fromFFT({
    required List<double> fftMagnitudes,
    required double sampleRate,
    int? maxFrequency,
  }) {
    if (fftMagnitudes.isEmpty) {
      return FrequencyData();
    }

    final maxFreq = maxFrequency ?? (sampleRate / 2).toInt();
    final frequencyResolution = sampleRate / (fftMagnitudes.length * 2);

    // Create frequency bins
    final frequencies = <double>[];
    final magnitudes = <double>[];

    for (int i = 0; i < fftMagnitudes.length; i++) {
      final freq = i * frequencyResolution;
      if (freq <= maxFreq) {
        frequencies.add(freq);
        magnitudes.add(fftMagnitudes[i]);
      }
    }

    if (magnitudes.isEmpty) {
      return FrequencyData();
    }

    // Find dominant frequency
    double maxMag = 0;
    int maxIndex = 0;
    for (int i = 0; i < magnitudes.length; i++) {
      if (magnitudes[i] > maxMag) {
        maxMag = magnitudes[i];
        maxIndex = i;
      }
    }

    final dominantFreq = frequencies[maxIndex];
    final dominantMag = maxMag;

    // Find fundamental frequency (lowest significant peak)
    double fundamentalFreq = dominantFreq;
    const threshold = 0.3; // 30% of max magnitude
    for (int i = 1; i < magnitudes.length; i++) {
      if (magnitudes[i] > maxMag * threshold && frequencies[i] > 20) {
        fundamentalFreq = frequencies[i];
        break;
      }
    }

    // Find harmonics (multiples of fundamental)
    final harmonicsList = <double>[];
    if (fundamentalFreq > 0) {
      for (int n = 2; n <= 5; n++) {
        final harmonic = fundamentalFreq * n;
        if (harmonic <= maxFreq) {
          // Find closest actual frequency
          final targetIndex = (harmonic / frequencyResolution).round();
          if (targetIndex < frequencies.length) {
            harmonicsList.add(frequencies[targetIndex]);
          }
        }
      }
    }

    // Calculate spectral centroid (center of mass of spectrum)
    double weightedSum = 0;
    double magnitudeSum = 0;
    for (int i = 0; i < frequencies.length; i++) {
      weightedSum += frequencies[i] * magnitudes[i];
      magnitudeSum += magnitudes[i];
    }
    final centroid = magnitudeSum > 0 ? weightedSum / magnitudeSum : 0;

    // Calculate spectral rolloff (frequency below which 85% of energy is contained)
    final totalEnergy = magnitudes.fold(0.0, (sum, mag) => sum + mag * mag);
    final rolloffThreshold = totalEnergy * 0.85;
    double cumulativeEnergy = 0;
    double rolloff = 0;
    for (int i = 0; i < magnitudes.length; i++) {
      cumulativeEnergy += magnitudes[i] * magnitudes[i];
      if (cumulativeEnergy >= rolloffThreshold) {
        rolloff = frequencies[i];
        break;
      }
    }

    // Calculate bandwidth (frequency range with significant energy)
    double minFreq = 0;
    double maxFreqBand = 0;
    const energyThreshold = 0.1; // 10% of max
    for (int i = 0; i < magnitudes.length; i++) {
      if (magnitudes[i] > maxMag * energyThreshold) {
        if (minFreq == 0) minFreq = frequencies[i];
        maxFreqBand = frequencies[i];
      }
    }
    final bandwidth = maxFreqBand - minFreq;

    return FrequencyData(
      frequencies: frequencies,
      magnitudes: magnitudes,
      dominantFrequency: dominantFreq,
      dominantMagnitude: dominantMag,
      fundamentalFrequency: fundamentalFreq,
      harmonics: harmonicsList,
      spectralCentroid: centroid.toDouble(),
      spectralRolloff: rolloff,
      bandwidth: bandwidth,
      timestamp: DateTime.now(),
      isActive: true,
    );
  }

  // Formatted getters
  String get dominantFrequencyFormatted => dominantFrequency.toStringAsFixed(1);
  String get fundamentalFrequencyFormatted =>
      fundamentalFrequency.toStringAsFixed(1);
  String get spectralCentroidFormatted => spectralCentroid.toStringAsFixed(1);
  String get spectralRolloffFormatted => spectralRolloff.toStringAsFixed(1);
  String get bandwidthFormatted => bandwidth.toStringAsFixed(1);

  /// Get note name from frequency
  String get dominantNote => _frequencyToNote(dominantFrequency);
  String get fundamentalNote => _frequencyToNote(fundamentalFrequency);

  /// Get frequency category
  String get frequencyCategory {
    if (dominantFrequency < 20) return 'Subsonic';
    if (dominantFrequency < 250) return 'Bass';
    if (dominantFrequency < 2000) return 'Midrange';
    if (dominantFrequency < 6000) return 'Presence';
    if (dominantFrequency < 20000) return 'Brilliance';
    return 'Ultrasonic';
  }

  /// Get sound type based on spectral characteristics
  String get soundType {
    if (!isActive || dominantMagnitude < 0.1) return 'Silence';

    if (harmonics.length >= 3) {
      return 'Harmonic'; // Musical tone
    } else if (bandwidth > 2000) {
      return 'Noise'; // Broadband noise
    } else if (dominantFrequency < 100) {
      return 'Rumble'; // Low frequency
    } else if (dominantFrequency > 5000) {
      return 'Hiss'; // High frequency
    } else {
      return 'Tone'; // Single frequency
    }
  }

  /// Convert frequency to musical note
  static String _frequencyToNote(double frequency) {
    if (frequency < 20 || frequency > 20000) return '--';

    const noteNames = [
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B',
    ];

    // A4 = 440 Hz
    const a4 = 440.0;
    final c0 = a4 * math.pow(2, -4.75); // C0 frequency

    final halfSteps = 12 * (math.log(frequency / c0) / math.ln2);
    final octave = (halfSteps / 12).floor();
    final note = halfSteps.round() % 12;

    if (octave < 0 || octave > 8) return '--';

    return '${noteNames[note]}$octave';
  }

  /// Get cents deviation from nearest note (for tuning)
  double getCentsDeviation() {
    if (dominantFrequency < 20 || dominantFrequency > 20000) return 0;

    const a4 = 440.0;
    final c0 = a4 * math.pow(2, -4.75);

    final halfSteps = 12 * (math.log(dominantFrequency / c0) / math.ln2);
    final nearestHalfStep = halfSteps.round();
    final cents = (halfSteps - nearestHalfStep) * 100;

    return cents;
  }

  String get centsDeviationFormatted {
    final cents = getCentsDeviation();
    final sign = cents >= 0 ? '+' : '';
    return '$sign${cents.toStringAsFixed(0)}¢';
  }
}
