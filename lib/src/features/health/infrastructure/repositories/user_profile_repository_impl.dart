import 'package:hive_flutter/hive_flutter.dart';
import 'package:sensorlab/src/features/health/domain/entities/user_profile.dart';
import 'package:sensorlab/src/features/health/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final Box<UserProfile> _userProfileBox;
  static const String _currentUserKey = 'currentUser';

  UserProfileRepositoryImpl(this._userProfileBox);

  @override
  Future<UserProfile> createDefaultProfile(
    String name,
    int age,
    double weight,
    double height,
    Gender gender,
  ) async {
    final now = DateTime.now();
    final profile = UserProfile(
      id: 'default_user', // Assuming a single user for now
      name: name,
      age: age,
      weight: weight,
      height: height,
      gender: gender,
      createdAt: now,
      updatedAt: now,
    );
    await saveUserProfile(profile);
    return profile;
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    await _userProfileBox.delete(_currentUserKey);
  }

  @override
  Future<List<UserProfile>> getAllUserProfiles() async {
    return _userProfileBox.values.toList();
  }

  @override
  Future<UserProfile?> getCurrentUserProfile() async {
    return _userProfileBox.get(_currentUserKey);
  }

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    // Assuming single user, so ignoring userId for now
    return getCurrentUserProfile();
  }

  @override
  Future<bool> hasUserProfile(String userId) async {
    return _userProfileBox.containsKey(_currentUserKey);
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    await _userProfileBox.put(_currentUserKey, profile);
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    await saveUserProfile(profile);
  }
}
