import 'package:shared_preferences/shared_preferences.dart';
import '../models/health_data.dart';

class ProfileManager {
  static const String _keyName = 'profile_name';
  static const String _keyAge = 'profile_age';
  static const String _keyGender = 'profile_gender';
  static const String _keyWeightKg = 'profile_weight_kg';
  static const String _keyHeightFeet = 'profile_height_feet';
  static const String _keyHeightInches = 'profile_height_inches';

  Future<void> saveProfile(HealthData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, data.name);
    await prefs.setDouble(_keyWeightKg, data.weightKg);
    await prefs.setDouble(_keyHeightFeet, data.heightFeet);
    await prefs.setDouble(_keyHeightInches, data.heightInches);
    await prefs.setInt(_keyAge, data.age);
    await prefs.setString(_keyGender, data.gender);
  }

  Future<HealthData> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return HealthData()
      ..name = prefs.getString(_keyName) ?? 'User'
      ..weightKg = prefs.getDouble(_keyWeightKg) ?? 70.0
      ..heightFeet = prefs.getDouble(_keyHeightFeet) ?? 5.0
      ..heightInches = prefs.getDouble(_keyHeightInches) ?? 7.0
      ..age = prefs.getInt(_keyAge) ?? 30
      ..gender = prefs.getString(_keyGender) ?? 'male';
  }
}
