import '../entities/user_profile.dart';

/// Repository interface for User Profile operations
/// This is in the domain layer - pure abstraction, no implementation details
abstract class UserProfileRepository {
  /// Get user profile by ID
  Future<UserProfile?> getUserProfile(String userId);

  /// Get current user profile (if exists)
  Future<UserProfile?> getCurrentUserProfile();

  /// Save user profile
  Future<void> saveUserProfile(UserProfile profile);

  /// Update user profile
  Future<void> updateUserProfile(UserProfile profile);

  /// Delete user profile
  Future<void> deleteUserProfile(String userId);

  /// Check if user profile exists
  Future<bool> hasUserProfile(String userId);

  /// Get all user profiles (for multi-user support)
  Future<List<UserProfile>> getAllUserProfiles();

  /// Create default user profile
  Future<UserProfile> createDefaultProfile(
    String name,
    int age,
    double weight,
    double height,
    Gender gender,
  );
}
