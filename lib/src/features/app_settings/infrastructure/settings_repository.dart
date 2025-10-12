import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sensorlab/src/core/services/hive_service.dart';
import 'package:sensorlab/src/features/app_settings/domain/models/app_settings.dart';

/// A Repository that handles loading and saving user settings to local storage
class SettingsRepository {
  /// Settings key for storing AppSettings in Hive
  static const String _settingsKey = 'app_settings';

  /// The HiveService instance
  final HiveService hiveService;

  /// The internal hive box for settings
  Box<AppSettings> get _box => hiveService.settingsBox;

  /// SettingsRepository Constructor
  SettingsRepository(this.hiveService);

  /// Loads the current app settings
  /// Returns default settings if none exist
  Future<AppSettings> loadSettings() async {
    final AppSettings? settings = _box.get(_settingsKey);
    return settings ?? const AppSettings();
  }

  /// Saves the app settings to local storage
  Future<void> saveSettings(AppSettings settings) async {
    await _box.put(_settingsKey, settings);
  }

  /// Updates specific settings fields
  Future<void> updateSettings(AppSettings Function(AppSettings) updater) async {
    final currentSettings = await loadSettings();
    final updatedSettings = updater(currentSettings);
    await saveSettings(updatedSettings);
  }

  /// Clears all settings (reset to defaults)
  Future<void> clearSettings() async {
    await _box.delete(_settingsKey);
  }
}
