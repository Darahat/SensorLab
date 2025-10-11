import 'package:sensorlab/src/features/health/domain/entities/user_profile.dart'
    as domain;
import 'package:sensorlab/src/features/health/models/health_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileManager {
  static const String _keyName = 'profile_name';
  static const String _keyAge = 'profile_age';
  static const String _keyGender = 'profile_gender';
  static const String _keyWeightKg = 'profile_weight_kg';
  static const String _keyHeightFeet = 'profile_height_feet';
  static const String _keyHeightInches = 'profile_height_inches';

  Future<void> saveProfile(HealthData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, data.profile.name);
    await prefs.setDouble(_keyWeightKg, data.profile.weight);
    await prefs.setDouble(
      _keyHeightFeet,
      (data.profile.height / 30.48).floor().toDouble(),
    ); // Convert cm to feet
    await prefs.setDouble(
      _keyHeightInches,
      ((data.profile.height / 2.54) % 12),
    ); // Convert cm to remaining inches
    await prefs.setInt(_keyAge, data.profile.age);
    await prefs.setString(_keyGender, data.profile.gender.name);
  }

  Future<HealthData> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    double readDoubleFallback(String key, double fallback) {
      final d = prefs.getDouble(key);
      if (d != null) return d;
      final i = prefs.getInt(key);
      if (i != null) return i.toDouble();
      final s = prefs.getString(key);
      if (s != null) {
        final parsed = double.tryParse(s);
        if (parsed != null) return parsed;
      }
      return fallback;
    }

    // Load user profile data
    final name = prefs.getString(_keyName) ?? 'User';
    final weightKg = readDoubleFallback(_keyWeightKg, 70.0);
    final heightFeet = readDoubleFallback(_keyHeightFeet, 5.0);
    final heightInches = readDoubleFallback(_keyHeightInches, 7.0);
    final age = prefs.getInt(_keyAge) ?? 30;
    final genderString = prefs.getString(_keyGender) ?? 'male';

    // Convert feet/inches to cm
    final heightCm = (heightFeet * 30.48) + (heightInches * 2.54);

    // Convert gender string to enum
    final gender =
        genderString == 'female' ? domain.Gender.female : domain.Gender.male;

    // Create domain UserProfile
    final profile = domain.UserProfile(
      id: '1',
      name: name,
      age: age,
      weight: weightKg,
      height: heightCm,
      gender: gender,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return HealthData(profile: profile);
  }
}
