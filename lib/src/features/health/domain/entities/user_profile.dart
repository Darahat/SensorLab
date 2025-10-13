import 'package:hive/hive.dart';

part 'user_profile.g.dart';

/// Core business entity for User Profile
/// Pure domain entity with business logic for health calculations
@HiveType(typeId: 1)
class UserProfile {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int age;

  @HiveField(3)
  final double weight; // in kg

  @HiveField(4)
  final double height; // in cm

  @HiveField(5)
  final Gender gender;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Copy with method for immutability
  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    double? weight,
    double? height,
    Gender? gender,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Business Logic: Body Mass Index calculation
  double get bmi => weight / ((height / 100) * (height / 100));

  /// Business Logic: BMI category determination
  BmiCategory get bmiCategory {
    if (bmi < 18.5) return BmiCategory.underweight;
    if (bmi < 25) return BmiCategory.normal;
    if (bmi < 30) return BmiCategory.overweight;
    return BmiCategory.obese;
  }

  /// Business Logic: Basal Metabolic Rate calculation (Harris-Benedict Equation)
  double get basalMetabolicRate {
    switch (gender) {
      case Gender.male:
        return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
      case Gender.female:
        return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
  }

  /// Business Logic: Daily calorie needs with activity level
  double getDailyCalorieNeeds(ActivityLevel activityLevel) {
    return basalMetabolicRate * activityLevel.multiplier;
  }

  /// Business Logic: Ideal weight range (based on BMI 18.5-24.9)
  ({double min, double max}) get idealWeightRange {
    final heightM = height / 100;
    final minWeight = 18.5 * heightM * heightM;
    final maxWeight = 24.9 * heightM * heightM;
    return (min: minWeight, max: maxWeight);
  }

  /// Business Logic: Validate profile data
  List<ValidationError> validate() {
    final errors = <ValidationError>[];

    if (name.trim().isEmpty) {
      errors.add(ValidationError.invalidName);
    }

    if (age < 1 || age > 150) {
      errors.add(ValidationError.invalidAge);
    }

    if (weight < 1 || weight > 1000) {
      errors.add(ValidationError.invalidWeight);
    }

    if (height < 30 || height > 300) {
      errors.add(ValidationError.invalidHeight);
    }

    return errors;
  }

  bool get isValid => validate().isEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          age == other.age &&
          weight == other.weight &&
          height == other.height &&
          gender == other.gender;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      age.hashCode ^
      weight.hashCode ^
      height.hashCode ^
      gender.hashCode;

  @override
  String toString() {
    return 'UserProfile{id: $id, name: $name, age: $age, weight: $weight, height: $height, gender: $gender}';
  }
}

@HiveType(typeId: 2)
enum Gender {
  @HiveField(0)
  male,

  @HiveField(1)
  female;

  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
    }
  }
}

enum BmiCategory {
  underweight,
  normal,
  overweight,
  obese;

  String get displayName {
    switch (this) {
      case BmiCategory.underweight:
        return 'Underweight';
      case BmiCategory.normal:
        return 'Normal';
      case BmiCategory.overweight:
        return 'Overweight';
      case BmiCategory.obese:
        return 'Obese';
    }
  }

  String get description {
    switch (this) {
      case BmiCategory.underweight:
        return 'Below normal weight';
      case BmiCategory.normal:
        return 'Healthy weight range';
      case BmiCategory.overweight:
        return 'Above normal weight';
      case BmiCategory.obese:
        return 'Significantly above normal weight';
    }
  }

  int get colorCode {
    switch (this) {
      case BmiCategory.underweight:
        return 0xFF2196F3; // Blue
      case BmiCategory.normal:
        return 0xFF4CAF50; // Green
      case BmiCategory.overweight:
        return 0xFFFF9800; // Orange
      case BmiCategory.obese:
        return 0xFFF44336; // Red
    }
  }
}

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extraActive;

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
      case ActivityLevel.extraActive:
        return 'Extra Active';
    }
  }

  String get description {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Little or no exercise';
      case ActivityLevel.lightlyActive:
        return 'Light exercise 1-3 days/week';
      case ActivityLevel.moderatelyActive:
        return 'Moderate exercise 3-5 days/week';
      case ActivityLevel.veryActive:
        return 'Hard exercise 6-7 days/week';
      case ActivityLevel.extraActive:
        return 'Very hard exercise, physical job';
    }
  }

  double get multiplier {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extraActive:
        return 1.9;
    }
  }
}

enum ValidationError {
  invalidName,
  invalidAge,
  invalidWeight,
  invalidHeight;

  String get message {
    switch (this) {
      case ValidationError.invalidName:
        return 'Name cannot be empty';
      case ValidationError.invalidAge:
        return 'Age must be between 1 and 150';
      case ValidationError.invalidWeight:
        return 'Weight must be between 1 and 1000 kg';
      case ValidationError.invalidHeight:
        return 'Height must be between 30 and 300 cm';
    }
  }
}
