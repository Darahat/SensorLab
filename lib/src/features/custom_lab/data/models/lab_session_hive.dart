import 'package:hive/hive.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

part 'lab_session_hive.g.dart';

@HiveType(typeId: 24) // Ensure unique typeId
class LabSessionHive extends HiveObject {
  @HiveField(0) 
  late String id;
  @HiveField(1) 
  late String labId;
  @HiveField(2) 
  late String labName;
  @HiveField(3) 
  late DateTime startTime;
  @HiveField(4) 
  late DateTime? endTime;
  @HiveField(5) 
  late RecordingStatus status;
  @HiveField(6) 
  late int dataPointsCount;
  @HiveField(7) 
  late int duration;
  @HiveField(8) 
  late String? notes;
  @HiveField(9) 
  late String? exportPath;
  @HiveField(10) 
  late List<SensorType> sensorTypes;

  // Factory constructor to convert from entity to Hive model
  static LabSessionHive fromEntity(LabSession entity) {
    return LabSessionHive()
      ..id = entity.id
      ..labId = entity.labId
      ..labName = entity.labName
      ..startTime = entity.startTime
      ..endTime = entity.endTime
      ..status = entity.status
      ..dataPointsCount = entity.dataPointsCount
      ..duration = entity.duration
      ..notes = entity.notes
      ..exportPath = entity.exportPath
      ..sensorTypes = entity.sensorTypes;
  }

  // Method to convert from Hive model to entity
  LabSession toEntity() {
    return LabSession(
      id: id,
      labId: labId,
      labName: labName,
      startTime: startTime,
      endTime: endTime,
      status: status,
      dataPointsCount: dataPointsCount,
      duration: duration,
      notes: notes,
      exportPath: exportPath,
      sensorTypes: sensorTypes,
    );
  }
}
