import 'dart:math' as math;

enum VibrationLevel { none, minimal, light, moderate, strong, severe, extreme }

enum VibrationPattern { stable, rhythmic, irregular, pulsing, continuous }

class VibrationData {
  final double magnitude; // Overall vibration magnitude (m/s²)
  final double x; // X-axis acceleration (m/s²)
  final double y; // Y-axis acceleration (m/s²)
  final double z; // Z-axis acceleration (m/s²)
  final double frequency; // Dominant vibration frequency (Hz)
  final double rms; // Root Mean Square of vibration
  final double peakToPeak; // Peak-to-peak amplitude
  final double crestFactor; // Peak / RMS ratio
  final VibrationLevel level; // Vibration severity level
  final VibrationPattern pattern; // Vibration pattern type
  final double maxMagnitude; // Maximum magnitude recorded
  final double minMagnitude; // Minimum magnitude recorded
  final double avgMagnitude; // Average magnitude
  final List<double> magnitudeHistory; // Recent magnitude values for graphing
  final DateTime timestamp;
  final bool isActive;
  final int sampleCount;

  VibrationData({
    this.magnitude = 0,
    this.x = 0,
    this.y = 0,
    this.z = 0,
    this.frequency = 0,
    this.rms = 0,
    this.peakToPeak = 0,
    this.crestFactor = 0,
    this.level = VibrationLevel.none,
    this.pattern = VibrationPattern.stable,
    this.maxMagnitude = 0,
    this.minMagnitude = double.infinity,
    this.avgMagnitude = 0,
    this.magnitudeHistory = const [],
    DateTime? timestamp,
    this.isActive = false,
    this.sampleCount = 0,
  }) : timestamp = timestamp ?? DateTime.now();

  VibrationData copyWith({
    double? magnitude,
    double? x,
    double? y,
    double? z,
    double? frequency,
    double? rms,
    double? peakToPeak,
    double? crestFactor,
    VibrationLevel? level,
    VibrationPattern? pattern,
    double? maxMagnitude,
    double? minMagnitude,
    double? avgMagnitude,
    List<double>? magnitudeHistory,
    DateTime? timestamp,
    bool? isActive,
    int? sampleCount,
  }) {
    return VibrationData(
      magnitude: magnitude ?? this.magnitude,
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      frequency: frequency ?? this.frequency,
      rms: rms ?? this.rms,
      peakToPeak: peakToPeak ?? this.peakToPeak,
      crestFactor: crestFactor ?? this.crestFactor,
      level: level ?? this.level,
      pattern: pattern ?? this.pattern,
      maxMagnitude: maxMagnitude ?? this.maxMagnitude,
      minMagnitude: minMagnitude ?? this.minMagnitude,
      avgMagnitude: avgMagnitude ?? this.avgMagnitude,
      magnitudeHistory: magnitudeHistory ?? this.magnitudeHistory,
      timestamp: timestamp ?? this.timestamp,
      isActive: isActive ?? this.isActive,
      sampleCount: sampleCount ?? this.sampleCount,
    );
  }

  /// Update with new accelerometer data
  VibrationData update({
    required double accelX,
    required double accelY,
    required double accelZ,
    required List<double> recentMagnitudes,
  }) {
    // Calculate magnitude (remove gravity component ~9.81 m/s²)
    final mag =
        math.sqrt(accelX * accelX + accelY * accelY + accelZ * accelZ) - 9.81;

    final absMag = mag.abs();

    // Update statistics
    final newSampleCount = sampleCount + 1;
    final newMaxMag = math.max(maxMagnitude, absMag);
    final newMinMag = minMagnitude == double.infinity
        ? absMag
        : math.min(minMagnitude, absMag);
    final newAvgMag = ((avgMagnitude * sampleCount) + absMag) / newSampleCount;

    // Calculate RMS (Root Mean Square)
    final magnitudes = [...recentMagnitudes, absMag];
    final sumSquares = magnitudes.fold(0.0, (sum, m) => sum + m * m);
    final newRms = math.sqrt(sumSquares / magnitudes.length);

    // Calculate peak-to-peak
    final peak = magnitudes.reduce(math.max);
    final valley = magnitudes.reduce(math.min);
    final newPeakToPeak = peak - valley;

    // Calculate crest factor (peak/RMS)
    final newCrestFactor = newRms > 0 ? peak / newRms : 0;

    // Estimate dominant frequency (simple zero-crossing method)
    final newFrequency = _estimateFrequency(magnitudes);

    // Determine vibration level
    final newLevel = _determineLevel(newRms);

    // Determine vibration pattern
    final newPattern = _determinePattern(
      magnitudes,
      newFrequency,
      newCrestFactor.toDouble(),
    );

    // Update history (keep last 100 samples)
    final newHistory = [...magnitudeHistory, absMag];
    if (newHistory.length > 100) {
      newHistory.removeAt(0);
    }

    return copyWith(
      magnitude: absMag,
      x: accelX,
      y: accelY,
      z: accelZ,
      frequency: newFrequency,
      rms: newRms,
      peakToPeak: newPeakToPeak,
      crestFactor: newCrestFactor.toDouble(),
      level: newLevel,
      pattern: newPattern,
      maxMagnitude: newMaxMag,
      minMagnitude: newMinMag,
      avgMagnitude: newAvgMag,
      magnitudeHistory: newHistory,
      timestamp: DateTime.now(),
      isActive: true,
      sampleCount: newSampleCount,
    );
  }

  /// Estimate dominant frequency using zero-crossing method
  static double _estimateFrequency(List<double> magnitudes) {
    if (magnitudes.length < 10) return 0;

    // Count zero crossings
    int crossings = 0;
    final mean = magnitudes.reduce((a, b) => a + b) / magnitudes.length;

    for (int i = 1; i < magnitudes.length; i++) {
      if ((magnitudes[i - 1] - mean) * (magnitudes[i] - mean) < 0) {
        crossings++;
      }
    }

    // Assuming ~100 samples per second (typical accelerometer rate)
    // Frequency = crossings / 2 / duration
    const sampleRate = 100.0; // Hz
    final duration = magnitudes.length / sampleRate;
    return crossings / (2 * duration);
  }

  /// Determine vibration level based on RMS
  static VibrationLevel _determineLevel(double rms) {
    if (rms < 0.01) return VibrationLevel.none;
    if (rms < 0.05) return VibrationLevel.minimal;
    if (rms < 0.2) return VibrationLevel.light;
    if (rms < 0.5) return VibrationLevel.moderate;
    if (rms < 1.0) return VibrationLevel.strong;
    if (rms < 2.0) return VibrationLevel.severe;
    return VibrationLevel.extreme;
  }

  /// Determine vibration pattern
  static VibrationPattern _determinePattern(
    List<double> magnitudes,
    double frequency,
    double crestFactor,
  ) {
    if (magnitudes.length < 10) return VibrationPattern.stable;

    // Calculate variance
    final mean = magnitudes.reduce((a, b) => a + b) / magnitudes.length;
    final variance =
        magnitudes.map((m) => (m - mean) * (m - mean)).reduce((a, b) => a + b) /
        magnitudes.length;
    final stdDev = math.sqrt(variance);

    // Low variance = stable
    if (stdDev < 0.05) return VibrationPattern.stable;

    // High crest factor = pulsing
    if (crestFactor > 3) return VibrationPattern.pulsing;

    // Frequency detection = rhythmic
    if (frequency > 1 && frequency < 20) return VibrationPattern.rhythmic;

    // High variance, low frequency = irregular
    if (stdDev > 0.2 && frequency < 1) return VibrationPattern.irregular;

    // Default = continuous
    return VibrationPattern.continuous;
  }

  /// Reset statistics
  VibrationData resetStats() {
    return copyWith(
      maxMagnitude: magnitude,
      minMagnitude: magnitude,
      avgMagnitude: magnitude,
      sampleCount: 0,
    );
  }

  /// Reset all data
  VibrationData reset() {
    return VibrationData();
  }

  // Formatted getters
  String get magnitudeFormatted => magnitude.toStringAsFixed(3);
  String get xFormatted => x.toStringAsFixed(2);
  String get yFormatted => y.toStringAsFixed(2);
  String get zFormatted => z.toStringAsFixed(2);
  String get frequencyFormatted => frequency.toStringAsFixed(1);
  String get rmsFormatted => rms.toStringAsFixed(3);
  String get peakToPeakFormatted => peakToPeak.toStringAsFixed(3);
  String get crestFactorFormatted => crestFactor.toStringAsFixed(2);
  String get maxMagnitudeFormatted => maxMagnitude.toStringAsFixed(3);
  String get minMagnitudeFormatted => minMagnitude == double.infinity
      ? '0.000'
      : minMagnitude.toStringAsFixed(3);
  String get avgMagnitudeFormatted => avgMagnitude.toStringAsFixed(3);

  /// Get vibration level display name
  String get levelName {
    switch (level) {
      case VibrationLevel.none:
        return 'None';
      case VibrationLevel.minimal:
        return 'Minimal';
      case VibrationLevel.light:
        return 'Light';
      case VibrationLevel.moderate:
        return 'Moderate';
      case VibrationLevel.strong:
        return 'Strong';
      case VibrationLevel.severe:
        return 'Severe';
      case VibrationLevel.extreme:
        return 'Extreme';
    }
  }

  /// Get vibration level color
  String get levelColor {
    switch (level) {
      case VibrationLevel.none:
        return 'grey';
      case VibrationLevel.minimal:
        return 'green';
      case VibrationLevel.light:
        return 'lightGreen';
      case VibrationLevel.moderate:
        return 'yellow';
      case VibrationLevel.strong:
        return 'orange';
      case VibrationLevel.severe:
        return 'red';
      case VibrationLevel.extreme:
        return 'purple';
    }
  }

  /// Get vibration pattern display name
  String get patternName {
    switch (pattern) {
      case VibrationPattern.stable:
        return 'Stable';
      case VibrationPattern.rhythmic:
        return 'Rhythmic';
      case VibrationPattern.irregular:
        return 'Irregular';
      case VibrationPattern.pulsing:
        return 'Pulsing';
      case VibrationPattern.continuous:
        return 'Continuous';
    }
  }

  /// Get vibration severity description
  String get severityDescription {
    switch (level) {
      case VibrationLevel.none:
        return 'No significant vibration detected';
      case VibrationLevel.minimal:
        return 'Barely perceptible vibration';
      case VibrationLevel.light:
        return 'Light vibration, noticeable but not concerning';
      case VibrationLevel.moderate:
        return 'Moderate vibration, monitor if persistent';
      case VibrationLevel.strong:
        return 'Strong vibration, may indicate issues';
      case VibrationLevel.severe:
        return 'Severe vibration, investigation recommended';
      case VibrationLevel.extreme:
        return 'Extreme vibration, immediate attention needed';
    }
  }

  /// Get application suggestions
  String get applicationHint {
    if (frequency > 0 && frequency < 5) {
      return 'Low frequency - structural/seismic';
    } else if (frequency >= 5 && frequency < 20) {
      return 'Medium frequency - machinery';
    } else if (frequency >= 20 && frequency < 100) {
      return 'High frequency - motors/bearings';
    } else if (frequency >= 100) {
      return 'Very high frequency - electrical/resonance';
    }
    return 'General vibration monitoring';
  }
}
