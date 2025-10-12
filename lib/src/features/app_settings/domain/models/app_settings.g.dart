// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 0;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      themeMode: fields[0] as String,
      notificationsEnabled: fields[1] as bool,
      vibrationEnabled: fields[2] as bool,
      soundEnabled: fields[3] as bool,
      autoScanEnabled: fields[4] as bool,
      sensorUpdateFrequency: fields[5] as int,
      languageCode: fields[6] as String,
      dataCollectionEnabled: fields[7] as bool,
      adsEnabled: fields[8] as bool,
      privacyMode: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.notificationsEnabled)
      ..writeByte(2)
      ..write(obj.vibrationEnabled)
      ..writeByte(3)
      ..write(obj.soundEnabled)
      ..writeByte(4)
      ..write(obj.autoScanEnabled)
      ..writeByte(5)
      ..write(obj.sensorUpdateFrequency)
      ..writeByte(6)
      ..write(obj.languageCode)
      ..writeByte(7)
      ..write(obj.dataCollectionEnabled)
      ..writeByte(8)
      ..write(obj.adsEnabled)
      ..writeByte(9)
      ..write(obj.privacyMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      themeMode: json['theme_mode'] as String? ?? 'system',
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      vibrationEnabled: json['vibration_enabled'] as bool? ?? true,
      soundEnabled: json['sound_enabled'] as bool? ?? true,
      autoScanEnabled: json['auto_scan_enabled'] as bool? ?? false,
      sensorUpdateFrequency:
          (json['sensor_update_frequency'] as num?)?.toInt() ?? 100,
      languageCode: json['language_code'] as String? ?? 'en',
      dataCollectionEnabled: json['data_collection_enabled'] as bool? ?? false,
      adsEnabled: json['ads_enabled'] as bool? ?? true,
      privacyMode: json['privacy_mode'] as bool? ?? false,
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'theme_mode': instance.themeMode,
      'notifications_enabled': instance.notificationsEnabled,
      'vibration_enabled': instance.vibrationEnabled,
      'sound_enabled': instance.soundEnabled,
      'auto_scan_enabled': instance.autoScanEnabled,
      'sensor_update_frequency': instance.sensorUpdateFrequency,
      'language_code': instance.languageCode,
      'data_collection_enabled': instance.dataCollectionEnabled,
      'ads_enabled': instance.adsEnabled,
      'privacy_mode': instance.privacyMode,
    };
