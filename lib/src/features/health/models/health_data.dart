import 'package:sensors_plus/sensors_plus.dart';

import '../domain/entities/activity_type.dart';
import '../domain/entities/user_profile.dart' as domain;

// Extension methods for ActivityType
extension ActivityTypeExtensions on ActivityType {
  String get icon {
    switch (this) {
      case ActivityType.walking:
        return '🚶';
      case ActivityType.running:
        return '🏃';
      case ActivityType.cycling:
        return '🚴';
      case ActivityType.sitting:
        return '🪑';
      case ActivityType.standing:
        return '🧍';
      case ActivityType.stairs:
        return '⬆️';
      case ActivityType.workout:
        return '💪';
    }
  }

  double get calorieFactor {
    switch (this) {
      case ActivityType.walking:
        return 3.5;
      case ActivityType.running:
        return 8.0;
      case ActivityType.cycling:
        return 6.0;
      case ActivityType.sitting:
        return 1.2;
      case ActivityType.standing:
        return 1.8;
      case ActivityType.stairs:
        return 8.5;
      case ActivityType.workout:
        return 7.0;
    }
  }
}

enum HealthSessionState {
  idle,
  tracking,
  paused;

  String get displayName {
    switch (this) {
      case HealthSessionState.idle:
        return 'Ready';
      case HealthSessionState.tracking:
        return 'Tracking';
      case HealthSessionState.paused:
        return 'Paused';
    }
  }

  String get icon {
    switch (this) {
      case HealthSessionState.idle:
        return '⏹️';
      case HealthSessionState.tracking:
        return '▶️';
      case HealthSessionState.paused:
        return '⏸️';
    }
  }
}

class MovementData {
  final UserAccelerometerEvent? accelerometer;
  final GyroscopeEvent? gyroscope;
  final double movementIntensity;
  final DateTime timestamp;

  const MovementData({
    this.accelerometer,
    this.gyroscope,
    this.movementIntensity = 0.0,
    required this.timestamp,
  });

  MovementData copyWith({
    UserAccelerometerEvent? accelerometer,
    GyroscopeEvent? gyroscope,
    double? movementIntensity,
    DateTime? timestamp,
  }) {
    return MovementData(
      accelerometer: accelerometer ?? this.accelerometer,
      gyroscope: gyroscope ?? this.gyroscope,
      movementIntensity: movementIntensity ?? this.movementIntensity,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  String get formattedAccelerometer {
    if (accelerometer == null) return 'No data';
    return 'X: ${accelerometer!.x.toStringAsFixed(2)}, '
        'Y: ${accelerometer!.y.toStringAsFixed(2)}, '
        'Z: ${accelerometer!.z.toStringAsFixed(2)}';
  }

  String get formattedGyroscope {
    if (gyroscope == null) return 'No data';
    return 'X: ${gyroscope!.x.toStringAsFixed(2)}, '
        'Y: ${gyroscope!.y.toStringAsFixed(2)}, '
        'Z: ${gyroscope!.z.toStringAsFixed(2)}';
  }

  String get formattedIntensity =>
      '${(movementIntensity * 100).toStringAsFixed(1)}%';
}

class HealthData {
  final domain.UserProfile profile;
  final ActivityType selectedActivity;
  final HealthSessionState sessionState;
  final MovementData? currentMovement;
  final List<MovementData> movementHistory;

  // Session tracking
  final DateTime sessionStartTime;
  final Duration sessionDuration;
  final Duration totalActiveTime;
  final int steps;
  final double distance; // in meters
  final double caloriesBurned;

  // Statistics
  final double averageIntensity;
  final double peakIntensity;
  final int movementCount;

  // Session goals
  final int targetSteps;
  final double targetCalories;
  final Duration targetDuration;

  // Error handling
  final String? errorMessage;
  final bool isInitialized;
  final bool isTracking;

  HealthData({
    required this.profile,
    this.selectedActivity = ActivityType.walking,
    this.sessionState = HealthSessionState.idle,
    this.currentMovement,
    this.movementHistory = const [],
    DateTime? sessionStartTime,
    this.sessionDuration = Duration.zero,
    this.totalActiveTime = Duration.zero,
    this.steps = 0,
    this.distance = 0.0,
    this.caloriesBurned = 0.0,
    this.averageIntensity = 0.0,
    this.peakIntensity = 0.0,
    this.movementCount = 0,
    this.targetSteps = 10000,
    this.targetCalories = 300.0,
    this.targetDuration = const Duration(minutes: 30),
    this.errorMessage,
    this.isInitialized = false,
    this.isTracking = false,
  }) : sessionStartTime = sessionStartTime ?? DateTime.now();

  HealthData copyWith({
    domain.UserProfile? profile,
    ActivityType? selectedActivity,
    HealthSessionState? sessionState,
    MovementData? currentMovement,
    List<MovementData>? movementHistory,
    DateTime? sessionStartTime,
    Duration? sessionDuration,
    Duration? totalActiveTime,
    int? steps,
    double? distance,
    double? caloriesBurned,
    double? averageIntensity,
    double? peakIntensity,
    int? movementCount,
    int? targetSteps,
    double? targetCalories,
    Duration? targetDuration,
    String? errorMessage,
    bool? isInitialized,
    bool? isTracking,
  }) {
    return HealthData(
      profile: profile ?? this.profile,
      selectedActivity: selectedActivity ?? this.selectedActivity,
      sessionState: sessionState ?? this.sessionState,
      currentMovement: currentMovement ?? this.currentMovement,
      movementHistory: movementHistory ?? this.movementHistory,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      totalActiveTime: totalActiveTime ?? this.totalActiveTime,
      steps: steps ?? this.steps,
      distance: distance ?? this.distance,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      averageIntensity: averageIntensity ?? this.averageIntensity,
      peakIntensity: peakIntensity ?? this.peakIntensity,
      movementCount: movementCount ?? this.movementCount,
      targetSteps: targetSteps ?? this.targetSteps,
      targetCalories: targetCalories ?? this.targetCalories,
      targetDuration: targetDuration ?? this.targetDuration,
      errorMessage: errorMessage,
      isInitialized: isInitialized ?? this.isInitialized,
      isTracking: isTracking ?? this.isTracking,
    );
  }

  // Formatted getters
  String get formattedSessionDuration {
    final hours = sessionDuration.inHours;
    final minutes = sessionDuration.inMinutes % 60;
    final seconds = sessionDuration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  String get formattedActiveTime {
    final hours = totalActiveTime.inHours;
    final minutes = totalActiveTime.inMinutes % 60;
    final seconds = totalActiveTime.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  String get formattedDistance {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} m';
    } else {
      return '${(distance / 1000).toStringAsFixed(2)} km';
    }
  }

  String get formattedCalories => '${caloriesBurned.toStringAsFixed(0)} cal';
  String get formattedSteps => '$steps steps';
  String get formattedAverageIntensity =>
      '${(averageIntensity * 100).toStringAsFixed(1)}%';
  String get formattedPeakIntensity =>
      '${(peakIntensity * 100).toStringAsFixed(1)}%';

  // Progress calculations
  double get stepsProgress =>
      targetSteps > 0 ? (steps / targetSteps).clamp(0.0, 1.0) : 0.0;
  double get caloriesProgress =>
      targetCalories > 0
          ? (caloriesBurned / targetCalories).clamp(0.0, 1.0)
          : 0.0;
  double get durationProgress =>
      targetDuration.inSeconds > 0
          ? (totalActiveTime.inSeconds / targetDuration.inSeconds).clamp(
            0.0,
            1.0,
          )
          : 0.0;

  // Status indicators
  String get sessionStateIcon => sessionState.icon;
  String get sessionStateDescription => sessionState.displayName;
  String get activityIcon => selectedActivity.icon;
  String get activityDescription => selectedActivity.displayName;

  // Goal achievements
  bool get hasAchievedStepsGoal => steps >= targetSteps;
  bool get hasAchievedCaloriesGoal => caloriesBurned >= targetCalories;
  bool get hasAchievedDurationGoal => totalActiveTime >= targetDuration;

  int get achievedGoalsCount {
    int count = 0;
    if (hasAchievedStepsGoal) count++;
    if (hasAchievedCaloriesGoal) count++;
    if (hasAchievedDurationGoal) count++;
    return count;
  }

  String get goalSummary => '$achievedGoalsCount/3 goals achieved';

  // Health metrics
  double get currentPace {
    if (totalActiveTime.inMinutes == 0 || distance == 0) return 0.0;
    return totalActiveTime.inMinutes / (distance / 1000); // minutes per km
  }

  String get formattedPace {
    if (currentPace == 0) return '--:--';
    final minutes = currentPace.floor();
    final seconds = ((currentPace - minutes) * 60).round();
    return '$minutes:${seconds.toString().padLeft(2, '0')} /km';
  }

  double get estimatedCaloriesPerHour {
    final hourlyRate =
        profile.basalMetabolicRate / 24 * selectedActivity.calorieFactor;
    return hourlyRate;
  }

  String get intensityDescription {
    if (averageIntensity < 0.2) return 'Low intensity';
    if (averageIntensity < 0.5) return 'Moderate intensity';
    if (averageIntensity < 0.8) return 'High intensity';
    return 'Very high intensity';
  }

  int get intensityColor {
    if (averageIntensity < 0.2) return 0xFF4CAF50; // Green
    if (averageIntensity < 0.5) return 0xFFFF9800; // Orange
    if (averageIntensity < 0.8) return 0xFFFF5722; // Deep Orange
    return 0xFFE91E63; // Pink
  }
}
