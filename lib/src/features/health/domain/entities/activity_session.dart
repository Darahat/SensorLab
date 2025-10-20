import 'package:hive/hive.dart';

import 'activity_type.dart';

part 'activity_session.g.dart';

/// Core business entity for Activity Session
/// Contains pure business logic for health tracking
@HiveType(typeId: 3)
class ActivitySession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final ActivityType activityType;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  final DateTime? endTime;

  @HiveField(4)
  final SessionStatus status;

  @HiveField(5)
  final int steps;

  @HiveField(6)
  final double distance; // in meters

  @HiveField(7)
  final double calories;

  @HiveField(8)
  final Duration activeDuration;

  @HiveField(9)
  final double averageIntensity;

  @HiveField(10)
  final double peakIntensity;

  @HiveField(11)
  final List<MovementData> movements;

  @HiveField(12)
  final Goals goals;

  const ActivitySession({
    required this.id,
    required this.activityType,
    required this.startTime,
    this.endTime,
    required this.status,
    this.steps = 0,
    this.distance = 0.0,
    this.calories = 0.0,
    this.activeDuration = Duration.zero,
    this.averageIntensity = 0.0,
    this.peakIntensity = 0.0,
    this.movements = const [],
    required this.goals,
  });

  ActivitySession copyWith({
    String? id,
    ActivityType? activityType,
    DateTime? startTime,
    DateTime? endTime,
    SessionStatus? status,
    int? steps,
    double? distance,
    double? calories,
    Duration? activeDuration,
    double? averageIntensity,
    double? peakIntensity,
    List<MovementData>? movements,
    Goals? goals,
  }) {
    return ActivitySession(
      id: id ?? this.id,
      activityType: activityType ?? this.activityType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      steps: steps ?? this.steps,
      distance: distance ?? this.distance,
      calories: calories ?? this.calories,
      activeDuration: activeDuration ?? this.activeDuration,
      averageIntensity: averageIntensity ?? this.averageIntensity,
      peakIntensity: peakIntensity ?? this.peakIntensity,
      movements: movements ?? this.movements,
      goals: goals ?? this.goals,
    );
  }

  /// Business Logic: Calculate total session duration
  Duration get totalDuration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Business Logic: Check if session is active
  bool get isActive => status == SessionStatus.active;

  /// Business Logic: Check if session is completed
  bool get isCompleted => status == SessionStatus.completed;

  /// Business Logic: Calculate pace (minutes per km)
  double get pace {
    if (distance == 0 || activeDuration.inMinutes == 0) return 0.0;
    final distanceKm = distance / 1000;
    return activeDuration.inMinutes / distanceKm;
  }

  /// Business Logic: Calculate average speed (km/h)
  double get averageSpeed {
    if (distance == 0 || activeDuration.inHours == 0) return 0.0;
    return (distance / 1000) / activeDuration.inHours;
  }

  /// Business Logic: Goal achievement checking
  bool get hasAchievedStepsGoal => steps >= goals.targetSteps;
  bool get hasAchievedCaloriesGoal => calories >= goals.targetCalories;
  bool get hasAchievedDurationGoal => activeDuration >= goals.targetDuration;
  bool get hasAchievedDistanceGoal => distance >= goals.targetDistance;

  /// Business Logic: Overall goal completion percentage
  double get goalCompletionPercentage {
    int achievedGoals = 0;
    int totalGoals = 0;

    if (goals.targetSteps > 0) {
      totalGoals++;
      if (hasAchievedStepsGoal) achievedGoals++;
    }

    if (goals.targetCalories > 0) {
      totalGoals++;
      if (hasAchievedCaloriesGoal) achievedGoals++;
    }

    if (goals.targetDuration.inSeconds > 0) {
      totalGoals++;
      if (hasAchievedDurationGoal) achievedGoals++;
    }

    if (goals.targetDistance > 0) {
      totalGoals++;
      if (hasAchievedDistanceGoal) achievedGoals++;
    }

    return totalGoals > 0 ? achievedGoals / totalGoals : 0.0;
  }

  /// Business Logic: Calculate estimated calories burned
  double calculateEstimatedCalories(double userWeight) {
    // METs × weight × time calculation
    final timeInHours = activeDuration.inMinutes / 60.0;
    return activityType.metValue * userWeight * timeInHours;
  }

  /// Business Logic: Session validation
  bool get isValid {
    return id.isNotEmpty &&
        startTime.isBefore(DateTime.now()) &&
        (endTime == null || endTime!.isAfter(startTime)) &&
        steps >= 0 &&
        distance >= 0 &&
        calories >= 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivitySession &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ActivitySession{id: $id, activityType: $activityType, status: $status, steps: $steps, calories: $calories}';
  }
}

@HiveType(typeId: 4)
enum SessionStatus {
  @HiveField(0)
  active,

  @HiveField(1)
  paused,

  @HiveField(2)
  completed,

  @HiveField(3)
  cancelled;

  String get displayName {
    switch (this) {
      case SessionStatus.active:
        return 'Active';
      case SessionStatus.paused:
        return 'Paused';
      case SessionStatus.completed:
        return 'Completed';
      case SessionStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get icon {
    switch (this) {
      case SessionStatus.active:
        return '▶️';
      case SessionStatus.paused:
        return '⏸️';
      case SessionStatus.completed:
        return '✅';
      case SessionStatus.cancelled:
        return '❌';
    }
  }
}

@HiveType(typeId: 5)
class MovementData {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final double x;

  @HiveField(2)
  final double y;

  @HiveField(3)
  final double z; // Accelerometer data

  @HiveField(4)
  final double intensity;

  @HiveField(5)
  final bool isStep;

  const MovementData({
    required this.timestamp,
    required this.x,
    required this.y,
    required this.z,
    required this.intensity,
    this.isStep = false,
  });

  MovementData copyWith({
    DateTime? timestamp,
    double? x,
    double? y,
    double? z,
    double? intensity,
    bool? isStep,
  }) {
    return MovementData(
      timestamp: timestamp ?? this.timestamp,
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      intensity: intensity ?? this.intensity,
      isStep: isStep ?? this.isStep,
    );
  }

  /// Business Logic: Calculate magnitude of movement
  double get magnitude => x * x + y * y + z * z;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovementData &&
          runtimeType == other.runtimeType &&
          timestamp == other.timestamp;

  @override
  int get hashCode => timestamp.hashCode;
}

@HiveType(typeId: 6)
class Goals {
  @HiveField(0)
  final int targetSteps;

  @HiveField(1)
  final double targetCalories;

  @HiveField(2)
  final Duration targetDuration;

  @HiveField(3)
  final double targetDistance; // in meters

  const Goals({
    this.targetSteps = 0,
    this.targetCalories = 0.0,
    this.targetDuration = Duration.zero,
    this.targetDistance = 0.0,
  });

  Goals copyWith({
    int? targetSteps,
    double? targetCalories,
    Duration? targetDuration,
    double? targetDistance,
  }) {
    return Goals(
      targetSteps: targetSteps ?? this.targetSteps,
      targetCalories: targetCalories ?? this.targetCalories,
      targetDuration: targetDuration ?? this.targetDuration,
      targetDistance: targetDistance ?? this.targetDistance,
    );
  }

  bool get hasAnyGoal =>
      targetSteps > 0 ||
      targetCalories > 0 ||
      targetDuration.inSeconds > 0 ||
      targetDistance > 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Goals &&
          runtimeType == other.runtimeType &&
          targetSteps == other.targetSteps &&
          targetCalories == other.targetCalories &&
          targetDuration == other.targetDuration &&
          targetDistance == other.targetDistance;

  @override
  int get hashCode =>
      targetSteps.hashCode ^
      targetCalories.hashCode ^
      targetDuration.hashCode ^
      targetDistance.hashCode;
}
