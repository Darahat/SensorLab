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

    return HealthData()
      ..name = prefs.getString(_keyName) ?? 'User'
      ..weightKg = readDoubleFallback(_keyWeightKg, 70.0)
      ..heightFeet = readDoubleFallback(_keyHeightFeet, 5.0)
      ..heightInches = readDoubleFallback(_keyHeightInches, 7.0)
      ..age = prefs.getInt(_keyAge) ?? 30
      ..gender = prefs.getString(_keyGender) ?? 'male';
  }
}
