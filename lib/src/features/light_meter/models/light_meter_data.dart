/// Represents light meter measurement data and state
class LightMeterData {
  /// Current light level in lux
  final double currentLux;

  /// Minimum light level recorded in current session
  final double minLux;

  /// Maximum light level recorded in current session
  final double maxLux;

  /// Average light level over the current session
  final double averageLux;

  /// Whether light measurement is currently active
  final bool isReading;

  /// Current light level category
  final LightLevel lightLevel;

  /// List of recent lux readings for chart visualization
  final List<double> recentReadings;

  /// Error message if any
  final String? errorMessage;

  /// Total number of readings taken
  final int totalReadings;

  /// Session duration in seconds
  final int sessionDuration;

  const LightMeterData({
    this.currentLux = 0.0,
    this.minLux = double.infinity,
    this.maxLux = double.negativeInfinity,
    this.averageLux = 0.0,
    this.isReading = false,
    this.lightLevel = LightLevel.dark,
    this.recentReadings = const [],
    this.errorMessage,
    this.totalReadings = 0,
    this.sessionDuration = 0,
  });

  /// Create a copy with modified values
  LightMeterData copyWith({
    double? currentLux,
    double? minLux,
    double? maxLux,
    double? averageLux,
    bool? isReading,
    LightLevel? lightLevel,
    List<double>? recentReadings,
    String? errorMessage,
    int? totalReadings,
    int? sessionDuration,
  }) {
    return LightMeterData(
      currentLux: currentLux ?? this.currentLux,
      minLux: minLux ?? this.minLux,
      maxLux: maxLux ?? this.maxLux,
      averageLux: averageLux ?? this.averageLux,
      isReading: isReading ?? this.isReading,
      lightLevel: lightLevel ?? this.lightLevel,
      recentReadings: recentReadings ?? this.recentReadings,
      errorMessage: errorMessage ?? this.errorMessage,
      totalReadings: totalReadings ?? this.totalReadings,
      sessionDuration: sessionDuration ?? this.sessionDuration,
    );
  }

  /// Get light level description based on current lux
  String get lightLevelDescription {
    switch (lightLevel) {
      case LightLevel.dark:
        return 'Dark (0-10 lux)';
      case LightLevel.dim:
        return 'Dim (10-200 lux)';
      case LightLevel.indoor:
        return 'Indoor (200-500 lux)';
      case LightLevel.office:
        return 'Office (500-1000 lux)';
      case LightLevel.bright:
        return 'Bright (1000-10000 lux)';
      case LightLevel.daylight:
        return 'Daylight (10000+ lux)';
    }
  }

  /// Get formatted current lux reading
  String get formattedCurrentLux => '${currentLux.toStringAsFixed(1)} lux';

  /// Get formatted min lux reading
  String get formattedMinLux =>
      minLux == double.infinity ? '--' : '${minLux.toStringAsFixed(1)} lux';

  /// Get formatted max lux reading
  String get formattedMaxLux => maxLux == double.negativeInfinity
      ? '--'
      : '${maxLux.toStringAsFixed(1)} lux';

  /// Get formatted average lux reading
  String get formattedAverageLux => '${averageLux.toStringAsFixed(1)} lux';

  /// Get formatted session duration
  String get formattedSessionDuration {
    final minutes = sessionDuration ~/ 60;
    final seconds = sessionDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Calculate light level based on lux value
  static LightLevel getLightLevel(double lux) {
    if (lux >= 10000) return LightLevel.daylight;
    if (lux >= 1000) return LightLevel.bright;
    if (lux >= 500) return LightLevel.office;
    if (lux >= 200) return LightLevel.indoor;
    if (lux >= 10) return LightLevel.dim;
    return LightLevel.dark;
  }

  /// Get color representation of current light level
  int get lightLevelColor {
    switch (lightLevel) {
      case LightLevel.dark:
        return 0xFF424242; // Dark Grey
      case LightLevel.dim:
        return 0xFF757575; // Grey
      case LightLevel.indoor:
        return 0xFFFF9800; // Orange
      case LightLevel.office:
        return 0xFFFFEB3B; // Yellow
      case LightLevel.bright:
        return 0xFFFFE082; // Light Yellow
      case LightLevel.daylight:
        return 0xFFFFF176; // Bright Yellow
    }
  }

  /// Get light level icon
  String get lightLevelIcon {
    switch (lightLevel) {
      case LightLevel.dark:
        return '🌑'; // New Moon
      case LightLevel.dim:
        return '🌘'; // Waning Crescent
      case LightLevel.indoor:
        return '💡'; // Light Bulb
      case LightLevel.office:
        return '🏢'; // Office Building
      case LightLevel.bright:
        return '☀️'; // Sun
      case LightLevel.daylight:
        return '🌞'; // Sun with Face
    }
  }
}

/// Enum representing different light levels
enum LightLevel { dark, dim, indoor, office, bright, daylight }
