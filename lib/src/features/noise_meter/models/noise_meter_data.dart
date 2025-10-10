/// Represents noise meter measurement data and state
class NoiseMeterData {
  /// Current decibel level in dB
  final double currentDecibels;

  /// Minimum decibel level recorded in current session
  final double minDecibels;

  /// Maximum decibel level recorded in current session
  final double maxDecibels;

  /// Average decibel level over the current session
  final double averageDecibels;

  /// Whether noise measurement is currently active
  final bool isRecording;

  /// Current noise level category
  final NoiseLevel noiseLevel;

  /// List of recent decibel readings for chart visualization
  final List<double> recentReadings;

  /// Error message if any
  final String? errorMessage;

  /// Whether microphone permission is granted
  final bool hasPermission;

  /// Total number of readings taken
  final int totalReadings;

  /// Session duration in seconds
  final int sessionDuration;

  const NoiseMeterData({
    this.currentDecibels = 0.0,
    this.minDecibels = double.infinity,
    this.maxDecibels = double.negativeInfinity,
    this.averageDecibels = 0.0,
    this.isRecording = false,
    this.noiseLevel = NoiseLevel.quiet,
    this.recentReadings = const [],
    this.errorMessage,
    this.hasPermission = false,
    this.totalReadings = 0,
    this.sessionDuration = 0,
  });

  /// Create a copy with modified values
  NoiseMeterData copyWith({
    double? currentDecibels,
    double? minDecibels,
    double? maxDecibels,
    double? averageDecibels,
    bool? isRecording,
    NoiseLevel? noiseLevel,
    List<double>? recentReadings,
    String? errorMessage,
    bool? hasPermission,
    int? totalReadings,
    int? sessionDuration,
  }) {
    return NoiseMeterData(
      currentDecibels: currentDecibels ?? this.currentDecibels,
      minDecibels: minDecibels ?? this.minDecibels,
      maxDecibels: maxDecibels ?? this.maxDecibels,
      averageDecibels: averageDecibels ?? this.averageDecibels,
      isRecording: isRecording ?? this.isRecording,
      noiseLevel: noiseLevel ?? this.noiseLevel,
      recentReadings: recentReadings ?? this.recentReadings,
      errorMessage: errorMessage ?? this.errorMessage,
      hasPermission: hasPermission ?? this.hasPermission,
      totalReadings: totalReadings ?? this.totalReadings,
      sessionDuration: sessionDuration ?? this.sessionDuration,
    );
  }

  /// Get noise level description based on current decibels
  String get noiseLevelDescription {
    switch (noiseLevel) {
      case NoiseLevel.quiet:
        return 'Quiet (0-30 dB)';
      case NoiseLevel.moderate:
        return 'Moderate (30-60 dB)';
      case NoiseLevel.loud:
        return 'Loud (60-85 dB)';
      case NoiseLevel.veryLoud:
        return 'Very Loud (85-100 dB)';
      case NoiseLevel.dangerous:
        return 'Dangerous (100+ dB)';
    }
  }

  /// Get formatted current decibel reading
  String get formattedCurrentDecibels =>
      '${currentDecibels.toStringAsFixed(1)} dB';

  /// Get formatted min decibel reading
  String get formattedMinDecibels =>
      minDecibels == double.infinity
          ? '--'
          : '${minDecibels.toStringAsFixed(1)} dB';

  /// Get formatted max decibel reading
  String get formattedMaxDecibels =>
      maxDecibels == double.negativeInfinity
          ? '--'
          : '${maxDecibels.toStringAsFixed(1)} dB';

  /// Get formatted average decibel reading
  String get formattedAverageDecibels =>
      '${averageDecibels.toStringAsFixed(1)} dB';

  /// Get formatted session duration
  String get formattedSessionDuration {
    final minutes = sessionDuration ~/ 60;
    final seconds = sessionDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Calculate noise level based on decibel value
  static NoiseLevel getNoiseLevel(double decibels) {
    if (decibels >= 100) return NoiseLevel.dangerous;
    if (decibels >= 85) return NoiseLevel.veryLoud;
    if (decibels >= 60) return NoiseLevel.loud;
    if (decibels >= 30) return NoiseLevel.moderate;
    return NoiseLevel.quiet;
  }

  /// Check if current noise level is potentially harmful
  bool get isPotentiallyHarmful =>
      noiseLevel == NoiseLevel.veryLoud || noiseLevel == NoiseLevel.dangerous;

  /// Get color representation of current noise level
  int get noiseLevelColor {
    switch (noiseLevel) {
      case NoiseLevel.quiet:
        return 0xFF4CAF50; // Green
      case NoiseLevel.moderate:
        return 0xFF8BC34A; // Light Green
      case NoiseLevel.loud:
        return 0xFFFF9800; // Orange
      case NoiseLevel.veryLoud:
        return 0xFFFF5722; // Deep Orange
      case NoiseLevel.dangerous:
        return 0xFFF44336; // Red
    }
  }
}

/// Enum representing different noise levels
enum NoiseLevel { quiet, moderate, loud, veryLoud, dangerous }
