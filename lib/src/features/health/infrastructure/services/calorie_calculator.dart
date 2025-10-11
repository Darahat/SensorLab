import '../../domain/entities/activity_type.dart';
import '../../domain/entities/user_profile.dart';
import '../../models/health_data.dart';

class CalorieCalculator {
  static double calculate(HealthData data) {
    // Changed to positional parameter
    final durationHours = data.sessionDuration.inMinutes / 60;

    // Harris-Benedict BMR Calculation
    double bmr;
    if (data.profile.gender == Gender.male) {
      bmr =
          88.362 +
          (13.397 * data.profile.weight) +
          (4.799 * data.profile.height) -
          (5.677 * data.profile.age);
    } else {
      // female or other
      bmr =
          447.593 +
          (9.247 * data.profile.weight) +
          (3.098 * data.profile.height) -
          (4.330 * data.profile.age);
    }

    // Activity Multipliers
    final activityFactors = {
      ActivityType.walking: 1.55,
      ActivityType.running: 1.725,
      ActivityType.cycling: 1.65,
      ActivityType.sitting: 1.2,
      ActivityType.standing: 1.4,
      ActivityType.stairs: 1.8,
      ActivityType.workout: 1.7,
    };

    // MET-based adjustment
    final metValues = {
      ActivityType.walking: 3.0,
      ActivityType.running: 7.0,
      ActivityType.cycling: 6.0,
      ActivityType.sitting: 1.2,
      ActivityType.standing: 1.8,
      ActivityType.stairs: 8.5,
      ActivityType.workout: 7.0,
    };

    final adjustedCalories =
        bmr * activityFactors[data.selectedActivity]! / 24 * durationHours;
    final metCalories =
        metValues[data.selectedActivity]! * data.profile.weight * durationHours;

    // Average both methods for better accuracy
    return (adjustedCalories + metCalories) / 2;
  }
}
