/// Represents humidity measurement data and state
class HumidityData {
  /// Current humidity percentage (0-100%)
  final double currentHumidity;

  /// Minimum humidity recorded in current session
  final double minHumidity;

  /// Maximum humidity recorded in current session
  final double maxHumidity;

  /// Average humidity over the current session
  final double averageHumidity;

  /// Whether humidity measurement is currently active
  final bool isReading;

  /// Current humidity comfort level
  final HumidityLevel humidityLevel;

  /// List of recent humidity readings for chart visualization
  final List<double> recentReadings;

  /// Error message if any
  final String? errorMessage;

  /// Whether device has humidity sensor
  final bool hasSensor;

  /// Total number of readings taken
  final int totalReadings;

  /// Session duration in seconds
  final int sessionDuration;

  const HumidityData({
    this.currentHumidity = 0.0,
    this.minHumidity = double.infinity,
    this.maxHumidity = double.negativeInfinity,
    this.averageHumidity = 0.0,
    this.isReading = false,
    this.humidityLevel = HumidityLevel.dry,
    this.recentReadings = const [],
    this.errorMessage,
    this.hasSensor = false,
    this.totalReadings = 0,
    this.sessionDuration = 0,
  });

  /// Create a copy with modified values
  HumidityData copyWith({
    double? currentHumidity,
    double? minHumidity,
    double? maxHumidity,
    double? averageHumidity,
    bool? isReading,
    HumidityLevel? humidityLevel,
    List<double>? recentReadings,
    String? errorMessage,
    bool? hasSensor,
    int? totalReadings,
    int? sessionDuration,
  }) {
    return HumidityData(
      currentHumidity: currentHumidity ?? this.currentHumidity,
      minHumidity: minHumidity ?? this.minHumidity,
      maxHumidity: maxHumidity ?? this.maxHumidity,
      averageHumidity: averageHumidity ?? this.averageHumidity,
      isReading: isReading ?? this.isReading,
      humidityLevel: humidityLevel ?? this.humidityLevel,
      recentReadings: recentReadings ?? this.recentReadings,
      errorMessage: errorMessage ?? this.errorMessage,
      hasSensor: hasSensor ?? this.hasSensor,
      totalReadings: totalReadings ?? this.totalReadings,
      sessionDuration: sessionDuration ?? this.sessionDuration,
    );
  }

  /// Get humidity level description based on current humidity
  String get humidityLevelDescription {
    switch (humidityLevel) {
      case HumidityLevel.veryDry:
        return 'Very Dry (0-30%)';
      case HumidityLevel.dry:
        return 'Dry (30-40%)';
      case HumidityLevel.comfortable:
        return 'Comfortable (40-60%)';
      case HumidityLevel.humid:
        return 'Humid (60-70%)';
      case HumidityLevel.veryHumid:
        return 'Very Humid (70%+)';
    }
  }

  /// Get formatted current humidity reading
  String get formattedCurrentHumidity =>
      '${currentHumidity.toStringAsFixed(1)}%';

  /// Get formatted min humidity reading
  String get formattedMinHumidity => minHumidity == double.infinity
      ? '--'
      : '${minHumidity.toStringAsFixed(1)}%';

  /// Get formatted max humidity reading
  String get formattedMaxHumidity => maxHumidity == double.negativeInfinity
      ? '--'
      : '${maxHumidity.toStringAsFixed(1)}%';

  /// Get formatted average humidity reading
  String get formattedAverageHumidity =>
      '${averageHumidity.toStringAsFixed(1)}%';

  /// Get formatted session duration
  String get formattedSessionDuration {
    final minutes = sessionDuration ~/ 60;
    final seconds = sessionDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Calculate humidity level based on percentage
  static HumidityLevel getHumidityLevel(double humidity) {
    if (humidity >= 70) return HumidityLevel.veryHumid;
    if (humidity >= 60) return HumidityLevel.humid;
    if (humidity >= 40) return HumidityLevel.comfortable;
    if (humidity >= 30) return HumidityLevel.dry;
    return HumidityLevel.veryDry;
  }

  /// Get color representation of current humidity level
  int get humidityLevelColor {
    switch (humidityLevel) {
      case HumidityLevel.veryDry:
        return 0xFFD32F2F; // Red
      case HumidityLevel.dry:
        return 0xFFFF9800; // Orange
      case HumidityLevel.comfortable:
        return 0xFF4CAF50; // Green
      case HumidityLevel.humid:
        return 0xFF2196F3; // Blue
      case HumidityLevel.veryHumid:
        return 0xFF3F51B5; // Indigo
    }
  }

  /// Get humidity level icon
  String get humidityLevelIcon {
    switch (humidityLevel) {
      case HumidityLevel.veryDry:
        return '🏜️'; // Desert
      case HumidityLevel.dry:
        return '🌵'; // Cactus
      case HumidityLevel.comfortable:
        return '🌿'; // Herb
      case HumidityLevel.humid:
        return '💧'; // Water drop
      case HumidityLevel.veryHumid:
        return '🌊'; // Water wave
    }
  }

  /// Get comfort assessment
  String get comfortAssessment {
    switch (humidityLevel) {
      case HumidityLevel.veryDry:
        return 'Too dry - may cause skin and respiratory irritation';
      case HumidityLevel.dry:
        return 'Somewhat dry - consider using a humidifier';
      case HumidityLevel.comfortable:
        return 'Ideal humidity level for comfort and health';
      case HumidityLevel.humid:
        return 'Somewhat humid - may feel sticky';
      case HumidityLevel.veryHumid:
        return 'Too humid - may promote mold growth';
    }
  }
}

/// Enum representing different humidity levels
enum HumidityLevel { veryDry, dry, comfortable, humid, veryHumid }
