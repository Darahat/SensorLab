/// Represents proximity sensor measurement data and state
class ProximityData {
  /// Whether object is currently near the sensor
  final bool isNear;

  /// Distance value (if available, otherwise boolean near/far)
  final double? distance;

  /// Whether proximity measurement is currently active
  final bool isReading;

  /// Current proximity state
  final ProximityState proximityState;

  /// History of proximity state changes for visualization
  final List<ProximityReading> recentReadings;

  /// Error message if any
  final String? errorMessage;

  /// Whether device has proximity sensor
  final bool hasSensor;

  /// Whether permission is granted
  final bool hasPermission;

  /// Total number of readings taken
  final int totalReadings;

  /// Session duration in seconds
  final int sessionDuration;

  /// Number of near detections in current session
  final int nearDetections;

  /// Number of far detections in current session
  final int farDetections;

  const ProximityData({
    this.isNear = false,
    this.distance,
    this.isReading = false,
    this.proximityState = ProximityState.far,
    this.recentReadings = const [],
    this.errorMessage,
    this.hasSensor = false,
    this.hasPermission = false,
    this.totalReadings = 0,
    this.sessionDuration = 0,
    this.nearDetections = 0,
    this.farDetections = 0,
  });

  /// Create a copy with modified values
  ProximityData copyWith({
    bool? isNear,
    double? distance,
    bool? isReading,
    ProximityState? proximityState,
    List<ProximityReading>? recentReadings,
    String? errorMessage,
    bool? hasSensor,
    bool? hasPermission,
    int? totalReadings,
    int? sessionDuration,
    int? nearDetections,
    int? farDetections,
  }) {
    return ProximityData(
      isNear: isNear ?? this.isNear,
      distance: distance ?? this.distance,
      isReading: isReading ?? this.isReading,
      proximityState: proximityState ?? this.proximityState,
      recentReadings: recentReadings ?? this.recentReadings,
      errorMessage: errorMessage ?? this.errorMessage,
      hasSensor: hasSensor ?? this.hasSensor,
      hasPermission: hasPermission ?? this.hasPermission,
      totalReadings: totalReadings ?? this.totalReadings,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      nearDetections: nearDetections ?? this.nearDetections,
      farDetections: farDetections ?? this.farDetections,
    );
  }

  /// Get proximity state description
  String get proximityStateDescription {
    switch (proximityState) {
      case ProximityState.near:
        return 'Near - Object detected';
      case ProximityState.far:
        return 'Far - No object detected';
      case ProximityState.unknown:
        return 'Unknown state';
    }
  }

  /// Get formatted distance reading
  String get formattedDistance {
    if (distance != null) {
      return '${distance!.toStringAsFixed(2)} cm';
    }
    return isNear ? 'Near' : 'Far';
  }

  /// Get formatted session duration
  String get formattedSessionDuration {
    final minutes = sessionDuration ~/ 60;
    final seconds = sessionDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get proximity detection percentage
  String get nearDetectionPercentage {
    if (totalReadings == 0) return '0%';
    final percentage = (nearDetections / totalReadings * 100);
    return '${percentage.toStringAsFixed(1)}%';
  }

  /// Get far detection percentage
  String get farDetectionPercentage {
    if (totalReadings == 0) return '0%';
    final percentage = (farDetections / totalReadings * 100);
    return '${percentage.toStringAsFixed(1)}%';
  }

  /// Get color representation of current proximity state
  int get proximityStateColor {
    switch (proximityState) {
      case ProximityState.near:
        return 0xFFFF5722; // Deep Orange
      case ProximityState.far:
        return 0xFF4CAF50; // Green
      case ProximityState.unknown:
        return 0xFF9E9E9E; // Grey
    }
  }

  /// Get proximity state icon
  String get proximityStateIcon {
    switch (proximityState) {
      case ProximityState.near:
        return '🔴'; // Red circle
      case ProximityState.far:
        return '🟢'; // Green circle
      case ProximityState.unknown:
        return '⚪'; // White circle
    }
  }

  /// Get proximity state icon data
  String get proximityStateIconData {
    switch (proximityState) {
      case ProximityState.near:
        return 'warning'; // Material icon
      case ProximityState.far:
        return 'check_circle';
      case ProximityState.unknown:
        return 'help';
    }
  }
}

/// Enum representing different proximity states
enum ProximityState { near, far, unknown }

/// Class representing a single proximity reading for history
class ProximityReading {
  final bool isNear;
  final DateTime timestamp;
  final double? distance;

  const ProximityReading({
    required this.isNear,
    required this.timestamp,
    this.distance,
  });

  ProximityState get state => isNear ? ProximityState.near : ProximityState.far;
}
