import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/app_settings/domain/models/app_settings.dart';
import 'package:sensorlab/src/features/app_settings/infrastructure/settings_repository.dart';
import 'package:sensorlab/src/features/app_settings/provider/settings_provider.dart';

/// A Controller class to manage app setting page.
class SettingsController extends AsyncNotifier<AppSettings> {
  /// Required Instances
  late final SettingsRepository _settingsRepository;

  /// The `build` method is called once when the notifier is first created.
  /// It should return a Future that resolves to the initial state.
  @override
  Future<AppSettings> build() async {
    /// Initialize repositories and service
    _settingsRepository = ref.watch(settingsRepositoryProvider);

    /// Load settings from repository
    return await _settingsRepository.loadSettings();
  }

  /// Update Theme mode
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    final currentSettings = state.value;
    if (currentSettings == null) return;

    // state = const AsyncValue.loading();

    try {
      final updatedSettings = currentSettings.copyWith(
        themeMode: themeMode.name,
      );

      await _settingsRepository.saveSettings(updatedSettings);
      state = AsyncValue.data(updatedSettings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Toggle notifications
  Future<void> toggleNotifications() async {
    await _updateSetting(
      (settings) => settings.copyWith(
        notificationsEnabled: !settings.notificationsEnabled,
      ),
    );
  }

  /// Toggle vibration
  Future<void> toggleVibration() async {
    await _updateSetting(
      (settings) =>
          settings.copyWith(vibrationEnabled: !settings.vibrationEnabled),
    );
  }

  /// Toggle sound
  Future<void> toggleSound() async {
    await _updateSetting(
      (settings) => settings.copyWith(soundEnabled: !settings.soundEnabled),
    );
  }

  /// Toggle auto scan
  Future<void> toggleAutoScan() async {
    await _updateSetting(
      (settings) =>
          settings.copyWith(autoScanEnabled: !settings.autoScanEnabled),
    );
  }

  /// Update sensor frequency
  Future<void> updateSensorFrequency(int frequency) async {
    await _updateSetting(
      (settings) => settings.copyWith(sensorUpdateFrequency: frequency),
    );
  }

  /// Toggle data collection
  Future<void> toggleDataCollection() async {
    await _updateSetting(
      (settings) => settings.copyWith(
        dataCollectionEnabled: !settings.dataCollectionEnabled,
      ),
    );
  }

  /// Toggle privacy mode
  Future<void> togglePrivacyMode() async {
    await _updateSetting(
      (settings) => settings.copyWith(privacyMode: !settings.privacyMode),
    );
  }

  /// Toggle ads
  Future<void> toggleAds() async {
    await _updateSetting(
      (settings) => settings.copyWith(adsEnabled: !settings.adsEnabled),
    );
  }

  /// Update language
  Future<void> updateLanguage(String languageCode) async {
    await _updateSetting(
      (settings) => settings.copyWith(languageCode: languageCode),
    );
  }

  /// Reset settings to defaults
  Future<void> resetToDefaults() async {
    state = const AsyncValue.loading();

    try {
      await _settingsRepository.clearSettings();
      final defaultSettings = const AppSettings();
      await _settingsRepository.saveSettings(defaultSettings);
      state = AsyncValue.data(defaultSettings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Helper method to update settings
  Future<void> _updateSetting(AppSettings Function(AppSettings) updater) async {
    final currentSettings = state.value;
    if (currentSettings == null) return;

    // state = const AsyncValue.loading();

    try {
      final updatedSettings = updater(currentSettings);
      await _settingsRepository.saveSettings(updatedSettings);
      state = AsyncValue.data(updatedSettings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
