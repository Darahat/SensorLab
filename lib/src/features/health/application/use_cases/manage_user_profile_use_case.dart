import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';

/// Use Case: Manage User Profile
/// Contains business logic for user profile operations
class ManageUserProfileUseCase {
  final UserProfileRepository _userRepository;

  ManageUserProfileUseCase(this._userRepository);

  Future<UserProfileResult> createProfile(CreateProfileParams params) async {
    try {
      // Business Validation: Validate input data
      final validationErrors = _validateProfileData(
        params.name,
        params.age,
        params.weight,
        params.height,
      );

      if (validationErrors.isNotEmpty) {
        return UserProfileResult.failure(
          'Validation failed: ${validationErrors.join(', ')}',
        );
      }

      // Business Rule: Check if profile already exists
      final existingProfile = await _userRepository.getCurrentUserProfile();
      if (existingProfile != null) {
        return UserProfileResult.failure('User profile already exists');
      }

      // Create new profile
      final profile = await _userRepository.createDefaultProfile(
        params.name,
        params.age,
        params.weight,
        params.height,
        params.gender,
      );

      return UserProfileResult.success(profile);
    } catch (e) {
      return UserProfileResult.failure('Failed to create profile: $e');
    }
  }

  Future<UserProfileResult> updateProfile(UpdateProfileParams params) async {
    try {
      // Get existing profile
      final existingProfile = await _userRepository.getCurrentUserProfile();
      if (existingProfile == null) {
        return UserProfileResult.failure('No profile found to update');
      }

      // Business Validation
      final validationErrors = _validateProfileData(
        params.name ?? existingProfile.name,
        params.age ?? existingProfile.age,
        params.weight ?? existingProfile.weight,
        params.height ?? existingProfile.height,
      );

      if (validationErrors.isNotEmpty) {
        return UserProfileResult.failure(
          'Validation failed: ${validationErrors.join(', ')}',
        );
      }

      // Update profile
      final updatedProfile = existingProfile.copyWith(
        name: params.name,
        age: params.age,
        weight: params.weight,
        height: params.height,
        gender: params.gender,
        updatedAt: DateTime.now(),
      );

      await _userRepository.updateUserProfile(updatedProfile);

      return UserProfileResult.success(updatedProfile);
    } catch (e) {
      return UserProfileResult.failure('Failed to update profile: $e');
    }
  }

  Future<UserProfileResult> getProfile() async {
    try {
      final profile = await _userRepository.getCurrentUserProfile();
      if (profile == null) {
        return UserProfileResult.failure('No user profile found');
      }
      return UserProfileResult.success(profile);
    } catch (e) {
      return UserProfileResult.failure('Failed to get profile: $e');
    }
  }

  Future<HealthMetricsResult> calculateHealthMetrics(String userId) async {
    try {
      final profile = await _userRepository.getCurrentUserProfile();
      if (profile == null) {
        return HealthMetricsResult.failure('No user profile found');
      }

      // Business Logic: Calculate health metrics
      final metrics = HealthMetrics(
        bmi: profile.bmi,
        bmiCategory: profile.bmiCategory,
        basalMetabolicRate: profile.basalMetabolicRate,
        idealWeightRange: profile.idealWeightRange,
        dailyCalorieNeeds: profile.getDailyCalorieNeeds(
          ActivityLevel.moderatelyActive,
        ),
      );

      return HealthMetricsResult.success(metrics);
    } catch (e) {
      return HealthMetricsResult.failure('Failed to calculate metrics: $e');
    }
  }

  List<String> _validateProfileData(
    String name,
    int age,
    double weight,
    double height,
  ) {
    final errors = <String>[];

    if (name.trim().isEmpty) {
      errors.add('Name cannot be empty');
    }

    if (age < 1 || age > 150) {
      errors.add('Age must be between 1 and 150');
    }

    if (weight < 1 || weight > 1000) {
      errors.add('Weight must be between 1 and 1000 kg');
    }

    if (height < 30 || height > 300) {
      errors.add('Height must be between 30 and 300 cm');
    }

    return errors;
  }
}

class CreateProfileParams {
  final String name;
  final int age;
  final double weight;
  final double height;
  final Gender gender;

  CreateProfileParams({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
  });
}

class UpdateProfileParams {
  final String? name;
  final int? age;
  final double? weight;
  final double? height;
  final Gender? gender;

  UpdateProfileParams({
    this.name,
    this.age,
    this.weight,
    this.height,
    this.gender,
  });
}

class UserProfileResult {
  final bool isSuccess;
  final UserProfile? profile;
  final String? errorMessage;

  UserProfileResult._({
    required this.isSuccess,
    this.profile,
    this.errorMessage,
  });

  factory UserProfileResult.success(UserProfile profile) {
    return UserProfileResult._(isSuccess: true, profile: profile);
  }

  factory UserProfileResult.failure(String message) {
    return UserProfileResult._(isSuccess: false, errorMessage: message);
  }
}

class HealthMetrics {
  final double bmi;
  final BmiCategory bmiCategory;
  final double basalMetabolicRate;
  final ({double min, double max}) idealWeightRange;
  final double dailyCalorieNeeds;

  HealthMetrics({
    required this.bmi,
    required this.bmiCategory,
    required this.basalMetabolicRate,
    required this.idealWeightRange,
    required this.dailyCalorieNeeds,
  });
}

class HealthMetricsResult {
  final bool isSuccess;
  final HealthMetrics? metrics;
  final String? errorMessage;

  HealthMetricsResult._({
    required this.isSuccess,
    this.metrics,
    this.errorMessage,
  });

  factory HealthMetricsResult.success(HealthMetrics metrics) {
    return HealthMetricsResult._(isSuccess: true, metrics: metrics);
  }

  factory HealthMetricsResult.failure(String message) {
    return HealthMetricsResult._(isSuccess: false, errorMessage: message);
  }
}
