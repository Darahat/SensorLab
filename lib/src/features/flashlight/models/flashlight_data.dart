/// Represents flashlight state and functionality data
class FlashlightData {
  /// Whether flashlight is currently on
  final bool isOn;

  /// Current intensity level (0.0 to 1.0)
  final double intensity;

  /// Whether device supports intensity control
  final bool supportsIntensity;

  /// Whether flashlight is available on device
  final bool isAvailable;

  /// Whether flashlight controller is initialized
  final bool isInitialized;

  /// Current flashlight mode
  final FlashlightMode mode;

  /// Error message if any
  final String? errorMessage;

  /// Total time flashlight has been on in current session (seconds)
  final int totalOnTime;

  /// Number of times flashlight was toggled in session
  final int toggleCount;

  /// Session start time
  final DateTime? sessionStartTime;

  /// Last toggle time
  final DateTime? lastToggleTime;

  /// Battery usage warning threshold (in seconds)
  final int batteryWarningThreshold;

  const FlashlightData({
    this.isOn = false,
    this.intensity = 0.5,
    this.supportsIntensity = false,
    this.isAvailable = false,
    this.isInitialized = false,
    this.mode = FlashlightMode.normal,
    this.errorMessage,
    this.totalOnTime = 0,
    this.toggleCount = 0,
    this.sessionStartTime,
    this.lastToggleTime,
    this.batteryWarningThreshold = 300, // 5 minutes
  });

  /// Create a copy with modified values
  FlashlightData copyWith({
    bool? isOn,
    double? intensity,
    bool? supportsIntensity,
    bool? isAvailable,
    bool? isInitialized,
    FlashlightMode? mode,
    String? errorMessage,
    int? totalOnTime,
    int? toggleCount,
    DateTime? sessionStartTime,
    DateTime? lastToggleTime,
    int? batteryWarningThreshold,
  }) {
    return FlashlightData(
      isOn: isOn ?? this.isOn,
      intensity: intensity ?? this.intensity,
      supportsIntensity: supportsIntensity ?? this.supportsIntensity,
      isAvailable: isAvailable ?? this.isAvailable,
      isInitialized: isInitialized ?? this.isInitialized,
      mode: mode ?? this.mode,
      errorMessage: errorMessage ?? this.errorMessage,
      totalOnTime: totalOnTime ?? this.totalOnTime,
      toggleCount: toggleCount ?? this.toggleCount,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      lastToggleTime: lastToggleTime ?? this.lastToggleTime,
      batteryWarningThreshold:
          batteryWarningThreshold ?? this.batteryWarningThreshold,
    );
  }

  /// Get current status description
  String get statusDescription {
    if (!isAvailable) return 'Flashlight not available';
    if (!isInitialized) return 'Initializing...';
    return isOn ? 'Flashlight ON' : 'Flashlight OFF';
  }

  /// Get formatted intensity percentage
  String get formattedIntensity => '${(intensity * 100).toInt()}%';

  /// Get formatted total on time
  String get formattedTotalOnTime {
    final minutes = totalOnTime ~/ 60;
    final seconds = totalOnTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get flashlight mode description
  String get modeDescription {
    switch (mode) {
      case FlashlightMode.normal:
        return 'Normal';
      case FlashlightMode.strobe:
        return 'Strobe';
      case FlashlightMode.sos:
        return 'SOS';
    }
  }

  /// Get color for current state
  int get stateColor {
    if (!isAvailable || !isInitialized) return 0xFF9E9E9E; // Grey
    return isOn ? 0xFFFFEB3B : 0xFF424242; // Yellow when on, dark grey when off
  }

  /// Get icon for current state
  String get stateIcon {
    if (!isAvailable) return '🚫';
    if (!isInitialized) return '⏳';
    return isOn ? '🔦' : '💡';
  }

  /// Check if battery warning should be shown
  bool get shouldShowBatteryWarning => totalOnTime >= batteryWarningThreshold;

  /// Get battery usage level
  BatteryUsageLevel get batteryUsageLevel {
    if (totalOnTime < 60) return BatteryUsageLevel.low;
    if (totalOnTime < 180) return BatteryUsageLevel.medium;
    if (totalOnTime < 300) return BatteryUsageLevel.high;
    return BatteryUsageLevel.critical;
  }

  /// Get battery usage description
  String get batteryUsageDescription {
    switch (batteryUsageLevel) {
      case BatteryUsageLevel.low:
        return 'Low battery usage';
      case BatteryUsageLevel.medium:
        return 'Moderate battery usage';
      case BatteryUsageLevel.high:
        return 'High battery usage';
      case BatteryUsageLevel.critical:
        return 'Critical battery usage - consider turning off';
    }
  }

  /// Get battery usage color
  int get batteryUsageColor {
    switch (batteryUsageLevel) {
      case BatteryUsageLevel.low:
        return 0xFF4CAF50; // Green
      case BatteryUsageLevel.medium:
        return 0xFFFF9800; // Orange
      case BatteryUsageLevel.high:
        return 0xFFFF5722; // Deep Orange
      case BatteryUsageLevel.critical:
        return 0xFFF44336; // Red
    }
  }

  /// Calculate session duration in seconds
  int get sessionDuration {
    if (sessionStartTime == null) return 0;
    return DateTime.now().difference(sessionStartTime!).inSeconds;
  }

  /// Get formatted session duration
  String get formattedSessionDuration {
    final duration = sessionDuration;
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Enum representing different flashlight modes
enum FlashlightMode { normal, strobe, sos }

/// Enum representing battery usage levels
enum BatteryUsageLevel { low, medium, high, critical }
