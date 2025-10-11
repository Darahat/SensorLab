/// Core business entity for Activity Types
/// Contains no external dependencies - pure business logic
enum ActivityType {
  walking,
  running,
  cycling,
  sitting,
  standing,
  stairs,
  workout;

  String get displayName {
    switch (this) {
      case ActivityType.walking:
        return 'Walking';
      case ActivityType.running:
        return 'Running';
      case ActivityType.cycling:
        return 'Cycling';
      case ActivityType.sitting:
        return 'Sitting';
      case ActivityType.standing:
        return 'Standing';
      case ActivityType.stairs:
        return 'Stairs';
      case ActivityType.workout:
        return 'Workout';
    }
  }

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

  /// Metabolic Equivalent of Task (METs) for calorie calculation
  double get metValue {
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
