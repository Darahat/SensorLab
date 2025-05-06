enum ActivityType { walking, running, cycling, treadmill }

extension ActivityTypeExtension on ActivityType {
  String get displayName {
    switch (this) {
      case ActivityType.walking:
        return 'Walking';
      case ActivityType.running:
        return 'Running';
      case ActivityType.cycling:
        return 'Cycling';
      case ActivityType.treadmill:
        return 'Treadmill';
    }
  }

  bool get requiresLocation {
    return this == ActivityType.walking ||
        this == ActivityType.running ||
        this == ActivityType.cycling;
  }
}
