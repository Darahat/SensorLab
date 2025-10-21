import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import 'sensor_type.dart';

part 'lab.freezed.dart';
part 'lab.g.dart';

/// Represents a custom lab configuration
/// A lab defines which sensors to record together and how to organize the data
@freezed
@HiveType(typeId: 21)
class Lab with _$Lab {
  const factory Lab({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String description,
    @HiveField(3) required List<SensorType> sensors,
    @HiveField(4) required DateTime createdAt,
    @HiveField(5) required DateTime updatedAt,
    @HiveField(6) @Default(false) bool isPreset,
    @HiveField(7) String? iconName,
    @HiveField(8) int? colorValue,
    @HiveField(9) @Default(100) int recordingInterval, // milliseconds
  }) = _Lab;

  factory Lab.fromJson(Map<String, dynamic> json) => _$LabFromJson(json);
}
