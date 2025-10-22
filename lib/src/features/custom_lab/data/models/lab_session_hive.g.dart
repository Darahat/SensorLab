// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_session_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LabSessionHiveAdapter extends TypeAdapter<LabSessionHive> {
  @override
  final int typeId = 24;

  @override
  LabSessionHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LabSessionHive()
      ..id = fields[0] as String
      ..labId = fields[1] as String
      ..labName = fields[2] as String
      ..startTime = fields[3] as DateTime
      ..endTime = fields[4] as DateTime?
      ..status = fields[5] as RecordingStatus
      ..dataPointsCount = fields[6] as int
      ..duration = fields[7] as int
      ..notes = fields[8] as String?
      ..exportPath = fields[9] as String?
      ..sensorTypes = (fields[10] as List).cast<SensorType>();
  }

  @override
  void write(BinaryWriter writer, LabSessionHive obj) {
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
      other is LabSessionHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
