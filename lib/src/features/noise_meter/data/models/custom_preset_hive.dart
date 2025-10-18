import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';

part 'custom_preset_hive.g.dart';

/// Hive model for custom acoustic analysis presets
@HiveType(typeId: 15) // Using typeId 15 (next available after 14)
class CustomPresetHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  int durationInMinutes;

  @HiveField(4)
  int iconCodePoint;

  @HiveField(5)
  int colorValue;

  @HiveField(6)
  DateTime createdAt;

  CustomPresetHive({
    required this.id,
    required this.title,
    required this.description,
    required this.durationInMinutes,
    required this.iconCodePoint,
    required this.colorValue,
    required this.createdAt,
  });

  /// Convert from CustomPresetConfig to CustomPresetHive
  factory CustomPresetHive.fromConfig(CustomPresetConfig config) {
    return CustomPresetHive(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: config.title,
      description: config.description,
      durationInMinutes: config.duration.inMinutes,
      iconCodePoint: config.icon.codePoint,
      colorValue: config.color.value,
      createdAt: DateTime.now(),
    );
  }

  /// Convert from CustomPresetHive to CustomPresetConfig
  CustomPresetConfig toConfig() {
    return CustomPresetConfig(
      title: title,
      description: description,
      duration: Duration(minutes: durationInMinutes),
      icon: IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
      color: Color(colorValue),
    );
  }

  /// Copy with method for updates
  CustomPresetHive copyWith({
    String? title,
    String? description,
    int? durationInMinutes,
    int? iconCodePoint,
    int? colorValue,
  }) {
    return CustomPresetHive(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      durationInMinutes: durationInMinutes ?? this.durationInMinutes,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt,
    );
  }
}
