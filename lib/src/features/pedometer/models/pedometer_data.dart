import 'dart:math' as math;

class PedometerData {
  final int steps; // Current step count
  final int totalSteps; // Total steps in session
  final int previousSteps; // Previous step count (for delta calculation)
  final double distance; // Estimated distance traveled in meters
  final double calories; // Estimated calories burned
  final Duration duration; // Time elapsed since start
  final DateTime startTime; // Session start time
  final DateTime? lastStepTime; // Time of last step detected
  final bool isActive; // Whether pedometer is actively counting
  final int dailyGoal; // Daily step goal
  final double avgSpeed; // Average speed in m/s
  final int cadence; // Steps per minute

  PedometerData({
    this.steps = 0,
    this.totalSteps = 0,
    this.previousSteps = 0,
    this.distance = 0,
    this.calories = 0,
    this.duration = Duration.zero,
    DateTime? startTime,
    this.lastStepTime,
    this.isActive = false,
    this.dailyGoal = 10000,
    this.avgSpeed = 0,
    this.cadence = 0,
  }) : startTime = startTime ?? DateTime.now();

  PedometerData copyWith({
    int? steps,
    int? totalSteps,
    int? previousSteps,
    double? distance,
    double? calories,
    Duration? duration,
    DateTime? startTime,
    DateTime? lastStepTime,
    bool? isActive,
    int? dailyGoal,
    double? avgSpeed,
    int? cadence,
  }) {
    return PedometerData(
      steps: steps ?? this.steps,
      totalSteps: totalSteps ?? this.totalSteps,
      previousSteps: previousSteps ?? this.previousSteps,
      distance: distance ?? this.distance,
      calories: calories ?? this.calories,
      duration: duration ?? this.duration,
      startTime: startTime ?? this.startTime,
      lastStepTime: lastStepTime ?? this.lastStepTime,
      isActive: isActive ?? this.isActive,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      avgSpeed: avgSpeed ?? this.avgSpeed,
      cadence: cadence ?? this.cadence,
    );
  }

  /// Reset all values
  PedometerData reset() {
    return PedometerData(dailyGoal: dailyGoal, startTime: DateTime.now());
  }

  /// Calculate new step count from sensor
  PedometerData updateSteps(int newStepCount) {
    // Calculate delta
    final stepDelta = newStepCount - previousSteps;
    final newTotalSteps = totalSteps + stepDelta;

    // Calculate new distance (assuming average stride length)
    const strideLength = 0.78; // Average stride length in meters
    final newDistance = newTotalSteps * strideLength;

    // Calculate calories (rough estimate: 0.04 calories per step)
    final newCalories = newTotalSteps * 0.04;

    // Calculate duration
    final now = DateTime.now();
    final newDuration = now.difference(startTime);

    // Calculate average speed (m/s)
    final durationSeconds = newDuration.inSeconds.toDouble();
    final newAvgSpeed = durationSeconds > 0 ? newDistance / durationSeconds : 0;

    // Calculate cadence (steps per minute)
    final durationMinutes = newDuration.inMinutes.toDouble();
    final newCadence = durationMinutes > 0
        ? (newTotalSteps / durationMinutes).round()
        : 0;

    return copyWith(
      steps: newStepCount,
      totalSteps: newTotalSteps,
      previousSteps: newStepCount,
      distance: newDistance,
      calories: newCalories,
      duration: newDuration,
      lastStepTime: now,
      isActive: true,
      avgSpeed: newAvgSpeed.toDouble(),
      cadence: newCadence,
    );
  }

  /// Set daily goal
  PedometerData setDailyGoal(int goal) {
    return copyWith(dailyGoal: goal);
  }

  // Distance conversions
  /// Get distance in kilometers
  double get distanceKm => distance / 1000;

  /// Get distance in miles
  double get distanceMiles => distance / 1609.34;

  // Speed conversions
  /// Get average speed in km/h
  double get avgSpeedKmh => avgSpeed * 3.6;

  /// Get average speed in mph
  double get avgSpeedMph => avgSpeed * 2.23694;

  // Goal tracking
  /// Get progress percentage towards daily goal
  double get goalProgress => totalSteps / dailyGoal;

  /// Get percentage as 0-100
  double get goalProgressPercent => (goalProgress * 100).clamp(0, 100);

  /// Check if daily goal is reached
  bool get isGoalReached => totalSteps >= dailyGoal;

  /// Get remaining steps to reach goal
  int get stepsToGoal => math.max(0, dailyGoal - totalSteps);

  // Activity level based on steps
  /// Get activity level
  ActivityLevel get activityLevel {
    if (totalSteps < 5000) {
      return ActivityLevel.sedentary;
    } else if (totalSteps < 7500) {
      return ActivityLevel.lightlyActive;
    } else if (totalSteps < 10000) {
      return ActivityLevel.moderatelyActive;
    } else if (totalSteps < 12500) {
      return ActivityLevel.veryActive;
    } else {
      return ActivityLevel.extremelyActive;
    }
  }

  // Pace calculation
  /// Get average pace in minutes per kilometer
  double get paceMinPerKm {
    if (distanceKm <= 0) return 0;
    return duration.inMinutes / distanceKm;
  }

  /// Get average pace in minutes per mile
  double get paceMinPerMile {
    if (distanceMiles <= 0) return 0;
    return duration.inMinutes / distanceMiles;
  }

  // Time tracking
  /// Get time since last step
  Duration? get timeSinceLastStep {
    if (lastStepTime == null) return null;
    return DateTime.now().difference(lastStepTime!);
  }

  /// Check if user is currently walking (step within last 5 seconds)
  bool get isWalking {
    final timeSince = timeSinceLastStep;
    if (timeSince == null) return false;
    return timeSince.inSeconds < 5;
  }

  // Formatted values
  /// Get formatted step count
  String get stepsFormatted => totalSteps.toString();

  /// Get formatted distance in km
  String get distanceKmFormatted => distanceKm.toStringAsFixed(2);

  /// Get formatted distance in miles
  String get distanceMilesFormatted => distanceMiles.toStringAsFixed(2);

  /// Get formatted calories
  String get caloriesFormatted => calories.toStringAsFixed(0);

  /// Get formatted duration (HH:MM:SS)
  String get durationFormatted {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  /// Get formatted average speed in km/h
  String get avgSpeedKmhFormatted => avgSpeedKmh.toStringAsFixed(1);

  /// Get formatted average speed in mph
  String get avgSpeedMphFormatted => avgSpeedMph.toStringAsFixed(1);

  /// Get formatted cadence
  String get cadenceFormatted => '$cadence spm';

  /// Get formatted goal progress percentage
  String get goalProgressFormatted =>
      '${goalProgressPercent.toStringAsFixed(0)}%';

  /// Get formatted pace in min/km
  String get paceMinPerKmFormatted {
    if (paceMinPerKm <= 0) return '--:--';
    final minutes = paceMinPerKm.floor();
    final seconds = ((paceMinPerKm - minutes) * 60).round();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get formatted pace in min/mile
  String get paceMinPerMileFormatted {
    if (paceMinPerMile <= 0) return '--:--';
    final minutes = paceMinPerMile.floor();
    final seconds = ((paceMinPerMile - minutes) * 60).round();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Activity level based on step count
enum ActivityLevel {
  sedentary, // < 5000 steps
  lightlyActive, // 5000-7499 steps
  moderatelyActive, // 7500-9999 steps
  veryActive, // 10000-12499 steps
  extremelyActive, // >= 12500 steps
}

/// Extension for ActivityLevel to get display name
extension ActivityLevelExtension on ActivityLevel {
  String get displayName {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedentary';
      case ActivityLevel.lightlyActive:
        return 'Lightly Active';
      case ActivityLevel.moderatelyActive:
        return 'Moderately Active';
      case ActivityLevel.veryActive:
        return 'Very Active';
      case ActivityLevel.extremelyActive:
        return 'Extremely Active';
    }
  }

  String get emoji {
    switch (this) {
      case ActivityLevel.sedentary:
        return '🪑';
      case ActivityLevel.lightlyActive:
        return '🚶';
      case ActivityLevel.moderatelyActive:
        return '🏃';
      case ActivityLevel.veryActive:
        return '🏃‍♂️';
      case ActivityLevel.extremelyActive:
        return '⚡';
    }
  }
}
