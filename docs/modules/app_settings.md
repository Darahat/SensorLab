# ⚙️ App Settings Module Documentation

## Overview

The app settings module provides centralized configuration management for user preferences, sensor settings, localization options, and application behavior customization.

## Features

- User preference management
- Theme and appearance settings
- Language and localization
- Sensor configuration options
- Data export/import settings

## Integration

```yaml
dependencies:
  shared_preferences: ^2.2.2
  flutter_riverpod: ^2.4.9
```

```dart
// Entity
class AppSettings {
  final String language;
  final bool isDarkMode;
  final bool enableVibration;
  final bool enableNotifications;
  final double sensorUpdateRate;
  final String exportFormat;

  const AppSettings({
    this.language = 'en',
    this.isDarkMode = false,
    this.enableVibration = true,
    this.enableNotifications = true,
    this.sensorUpdateRate = 1.0,
    this.exportFormat = 'csv',
  });
}

// Repository
class SettingsRepository {
  static const _languageKey = 'language';
  static const _darkModeKey = 'dark_mode';
  static const _vibrationKey = 'enable_vibration';

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      language: prefs.getString(_languageKey) ?? 'en',
      isDarkMode: prefs.getBool(_darkModeKey) ?? false,
      enableVibration: prefs.getBool(_vibrationKey) ?? true,
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, settings.language);
    await prefs.setBool(_darkModeKey, settings.isDarkMode);
    await prefs.setBool(_vibrationKey, settings.enableVibration);
  }
}

// Provider
final settingsProvider = StateNotifierProvider<SettingsController, AppSettings>((ref) {
  return SettingsController(SettingsRepository());
});
```

## Settings Categories

### Appearance

- Dark/Light theme toggle
- Color scheme selection
- Font size adjustment
- UI animation preferences

### Sensors

- Update frequency settings
- Calibration options
- Unit preferences (metric/imperial)
- Sensor enable/disable toggles

### Data & Privacy

- Export format selection
- Data retention policies
- Analytics preferences
- Permission management

### Localization

- Language selection
- Region-specific formatting
- Measurement unit preferences
- Cultural adaptations

## Use Cases

- Personalized user experience
- Accessibility customization
- Performance optimization
- Privacy control
- Backup and sync preferences

