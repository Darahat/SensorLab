import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import 'sensor_type.dart';

part 'lab_session.freezed.dart';
part 'lab_session.g.dart';

/// Recording status for a lab session
@HiveType(typeId: 22)
enum RecordingStatus {
  @HiveField(0)
  idle,

  @HiveField(1)
  recording,

  @HiveField(2)
  paused,

  @HiveField(3)
  completed,

  @HiveField(4)
  failed,
}

/// Represents an active or completed recording session for a lab
@freezed
@HiveType(typeId: 23)
class LabSession with _$LabSession {
  const factory LabSession({
    @HiveField(0) required String id,
    @HiveField(1) required String labId,
    @HiveField(2) required String labName,
    @HiveField(3) required DateTime startTime,
    @HiveField(4) DateTime? endTime,
    @HiveField(5) required RecordingStatus status,
    @HiveField(6) @Default(0) int dataPointsCount,
    @HiveField(7) @Default(0) int duration, // seconds
    @HiveField(8) String? notes,
    @HiveField(9) String? exportPath, // Path to exported CSV file
    @HiveField(10) @Default([]) List<SensorType> sensorTypes,
  }) = _LabSession;

  factory LabSession.fromJson(Map<String, dynamic> json) =>
      _$LabSessionFromJson(json);
}
