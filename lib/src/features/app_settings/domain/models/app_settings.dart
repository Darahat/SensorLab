import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class AppSettings {
  @HiveField(0)
  @JsonKey(name: 'theme_mode')
  final String themeMode;

  @HiveField(1)
  @JsonKey(name: 'notifications_enabled')
  final bool notificationsEnabled;

  @HiveField(2)
  @JsonKey(name: 'vibration_enabled')
  final bool vibrationEnabled;

  @HiveField(3)
  @JsonKey(name: 'sound_enabled')
  final bool soundEnabled;

  @HiveField(4)
  @JsonKey(name: 'auto_scan_enabled')
  final bool autoScanEnabled;

  @HiveField(5)
  @JsonKey(name: 'sensor_update_frequency')
  final int sensorUpdateFrequency; // in milliseconds

  @HiveField(6)
  @JsonKey(name: 'language_code')
  final String languageCode;

  @HiveField(7)
  @JsonKey(name: 'data_collection_enabled')
  final bool dataCollectionEnabled;

  @HiveField(8)
  @JsonKey(name: 'ads_enabled')
  final bool adsEnabled;

  @HiveField(9)
  @JsonKey(name: 'privacy_mode')
  final bool privacyMode;

  const AppSettings({
    this.themeMode = 'system',
    this.notificationsEnabled = true,
    this.vibrationEnabled = true,
    this.soundEnabled = true,
    this.autoScanEnabled = false,
    this.sensorUpdateFrequency = 100,
    this.languageCode = 'en',
    this.dataCollectionEnabled = false,
    this.adsEnabled = true,
    this.privacyMode = false,
  });

  // Default settings
  static const AppSettings defaultSettings = AppSettings();

  // Theme mode helpers
  ThemeMode get themeModeEnum {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  // Update frequency helper
  Duration get updateFrequency => Duration(milliseconds: sensorUpdateFrequency);

  // Copy with method
  AppSettings copyWith({
    String? themeMode,
    bool? notificationsEnabled,
    bool? vibrationEnabled,
    bool? soundEnabled,
    bool? autoScanEnabled,
    int? sensorUpdateFrequency,
    String? languageCode,
    bool? dataCollectionEnabled,
    bool? adsEnabled,
    bool? privacyMode,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      autoScanEnabled: autoScanEnabled ?? this.autoScanEnabled,
      sensorUpdateFrequency:
          sensorUpdateFrequency ?? this.sensorUpdateFrequency,
      languageCode: languageCode ?? this.languageCode,
      dataCollectionEnabled:
          dataCollectionEnabled ?? this.dataCollectionEnabled,
      adsEnabled: adsEnabled ?? this.adsEnabled,
      privacyMode: privacyMode ?? this.privacyMode,
    );
  }

  // JSON serialization
  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.themeMode == themeMode &&
        other.notificationsEnabled == notificationsEnabled &&
        other.vibrationEnabled == vibrationEnabled &&
        other.soundEnabled == soundEnabled &&
        other.autoScanEnabled == autoScanEnabled &&
        other.sensorUpdateFrequency == sensorUpdateFrequency &&
        other.languageCode == languageCode &&
        other.dataCollectionEnabled == dataCollectionEnabled &&
        other.adsEnabled == adsEnabled &&
        other.privacyMode == privacyMode;
  }

  @override
  int get hashCode {
    return Object.hash(
      themeMode,
      notificationsEnabled,
      vibrationEnabled,
      soundEnabled,
      autoScanEnabled,
      sensorUpdateFrequency,
      languageCode,
      dataCollectionEnabled,
      adsEnabled,
      privacyMode,
    );
  }

  @override
  String toString() {
    return 'AppSettings('
        'themeMode: $themeMode, '
        'notificationsEnabled: $notificationsEnabled, '
        'vibrationEnabled: $vibrationEnabled, '
        'soundEnabled: $soundEnabled, '
        'autoScanEnabled: $autoScanEnabled, '
        'sensorUpdateFrequency: $sensorUpdateFrequency, '
        'languageCode: $languageCode, '
        'dataCollectionEnabled: $dataCollectionEnabled, '
        'adsEnabled: $adsEnabled, '
        'privacyMode: $privacyMode'
        ')';
  }
}
