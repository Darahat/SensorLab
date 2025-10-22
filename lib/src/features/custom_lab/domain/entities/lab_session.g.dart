// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LabSessionAdapter extends TypeAdapter<LabSession> {
  @override
  final int typeId = 23;

  @override
  LabSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LabSession(
      id: fields[0] as String,
      labId: fields[1] as String,
      labName: fields[2] as String,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime?,
      status: fields[5] as RecordingStatus,
      dataPointsCount: fields[6] as int,
      duration: fields[7] as int,
      notes: fields[8] as String?,
      exportPath: fields[9] as String?,
      sensorTypes: (fields[10] as List).cast<SensorType>(),
    );
  }

  @override
  void write(BinaryWriter writer, LabSession obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.labId)
      ..writeByte(2)
      ..write(obj.labName)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.dataPointsCount)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.exportPath)
      ..writeByte(10)
      ..write(obj.sensorTypes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecordingStatusAdapter extends TypeAdapter<RecordingStatus> {
  @override
  final int typeId = 22;

  @override
  RecordingStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecordingStatus.idle;
      case 1:
        return RecordingStatus.recording;
      case 2:
        return RecordingStatus.paused;
      case 3:
        return RecordingStatus.completed;
      case 4:
        return RecordingStatus.failed;
      default:
        return RecordingStatus.idle;
    }
  }

  @override
  void write(BinaryWriter writer, RecordingStatus obj) {
    switch (obj) {
      case RecordingStatus.idle:
        writer.writeByte(0);
        break;
      case RecordingStatus.recording:
        writer.writeByte(1);
        break;
      case RecordingStatus.paused:
        writer.writeByte(2);
        break;
      case RecordingStatus.completed:
        writer.writeByte(3);
        break;
      case RecordingStatus.failed:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordingStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LabSessionImpl _$$LabSessionImplFromJson(Map<String, dynamic> json) =>
    _$LabSessionImpl(
      id: json['id'] as String,
      labId: json['labId'] as String,
      labName: json['labName'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      status: $enumDecode(_$RecordingStatusEnumMap, json['status']),
      dataPointsCount: (json['dataPointsCount'] as num?)?.toInt() ?? 0,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String?,
      exportPath: json['exportPath'] as String?,
      sensorTypes: (json['sensorTypes'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$SensorTypeEnumMap, e))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$LabSessionImplToJson(_$LabSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'labId': instance.labId,
      'labName': instance.labName,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'status': _$RecordingStatusEnumMap[instance.status]!,
      'dataPointsCount': instance.dataPointsCount,
      'duration': instance.duration,
      'notes': instance.notes,
      'exportPath': instance.exportPath,
      'sensorTypes':
          instance.sensorTypes.map((e) => _$SensorTypeEnumMap[e]!).toList(),
    };

const _$RecordingStatusEnumMap = {
  RecordingStatus.idle: 'idle',
  RecordingStatus.recording: 'recording',
  RecordingStatus.paused: 'paused',
  RecordingStatus.completed: 'completed',
  RecordingStatus.failed: 'failed',
};

const _$SensorTypeEnumMap = {
  SensorType.accelerometer: 'accelerometer',
  SensorType.gyroscope: 'gyroscope',
  SensorType.magnetometer: 'magnetometer',
  SensorType.barometer: 'barometer',
  SensorType.lightMeter: 'lightMeter',
  SensorType.noiseMeter: 'noiseMeter',
  SensorType.gps: 'gps',
  SensorType.proximity: 'proximity',
  SensorType.temperature: 'temperature',
  SensorType.humidity: 'humidity',
  SensorType.pedometer: 'pedometer',
  SensorType.compass: 'compass',
  SensorType.altimeter: 'altimeter',
  SensorType.speedMeter: 'speedMeter',
  SensorType.heartBeat: 'heartBeat',
};
