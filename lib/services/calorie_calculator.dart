import '../models/activity_type.dart';
import '../models/health_data.dart';

class CalorieCalculator {
  static double calculate(HealthData data) {
    // Changed to positional parameter
    final durationHours =
        data.trackingStartTime != null
            ? DateTime.now().difference(data.trackingStartTime!).inMinutes / 60
            : 0;

    // Harris-Benedict BMR Calculation
    double bmr;
    if (data.gender == 'male') {
      bmr =
          88.362 +
          (13.397 * data.weightKg) +
          (4.799 * data.heightCm) -
          (5.677 * data.age);
    } else {
      // female or other
      bmr =
          447.593 +
          (9.247 * data.weightKg) +
          (3.098 * data.heightCm) -
          (4.330 * data.age);
    }

    // Activity Multipliers
    final activityFactors = {
      ActivityType.walking: 1.55,
      ActivityType.running: 1.725,
      ActivityType.cycling: 1.65,
      ActivityType.treadmill: 1.5,
    };

    // MET-based adjustment
    final metValues = {
      ActivityType.walking: 3.0,
      ActivityType.running: 7.0,
      ActivityType.cycling: 6.0,
      ActivityType.treadmill: 4.0,
    };

    final adjustedCalories =
        bmr * activityFactors[data.selectedActivity]! / 24 * durationHours;
    final metCalories =
        metValues[data.selectedActivity]! * data.weightKg * durationHours;

    // Average both methods for better accuracy
    return (adjustedCalories + metCalories) / 2;
  }
}
