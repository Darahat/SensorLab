import './activity_type.dart';

class HealthData {
  // Personal Info
  String name = 'User';
  double weightKg = 70.0;
  double heightFeet = 5.0; // Height feet part
  double heightInches = 7.0; // Height inches part

  int age = 30;
  String gender = 'male'; // 'male', 'female', 'other'

  // Activity Tracking
  ActivityType selectedActivity = ActivityType.walking;
  int steps = 0;
  double caloriesBurned = 0.0;
  double distanceKm = 0.0;
  bool isTracking = false;
  DateTime? trackingStartTime;
  double get heightCm => (heightFeet * 30.48) + (heightInches * 2.54);
  set heightCm(double value) {
    // Convert centimeters to feet + inches. We keep feet as whole number
    // and inches as fractional (0..<12). If value is non-positive we keep
    // sensible defaults.
    if (value <= 0) return;
    final totalInches = value / 2.54;
    final feet = (totalInches ~/ 12); // integer feet
    final inches = totalInches - (feet * 12); // fractional inches
    heightFeet = feet.toDouble();
    heightInches = double.parse(inches.toStringAsFixed(2));
  }

  double get heightMeters => heightCm / 100;
  // Health Metrics
  double get bmi {
    final meters = heightMeters;
    if (meters <= 0) return 0.0;
    return weightKg / (meters * meters);
  }

  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  HealthData copyWith({
    String? name,
    double? weightKg,
    double? heightFeet,
    double? heightInches,
    int? age,
    String? gender,
    ActivityType? selectedActivity,
    int? steps,
    double? caloriesBurned,
    double? distanceKm,
    bool? isTracking,
    DateTime? trackingStartTime,
  }) {
    return HealthData()
      ..name = name ?? this.name
      ..weightKg = weightKg ?? this.weightKg
      ..heightFeet = heightFeet ?? this.heightFeet
      ..heightInches = heightInches ?? this.heightInches
      ..age = age ?? this.age
      ..gender = gender ?? this.gender
      ..selectedActivity = selectedActivity ?? this.selectedActivity
      ..steps = steps ?? this.steps
      ..caloriesBurned = caloriesBurned ?? this.caloriesBurned
      ..distanceKm = distanceKm ?? this.distanceKm
      ..isTracking = isTracking ?? this.isTracking
      ..trackingStartTime = trackingStartTime ?? this.trackingStartTime;
  }
}
