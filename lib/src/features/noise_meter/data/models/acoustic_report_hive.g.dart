// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acoustic_report_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AcousticEventHiveAdapter extends TypeAdapter<AcousticEventHive> {
  @override
  final int typeId = 8;

  @override
  AcousticEventHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AcousticEventHive(
      timestamp: fields[0] as DateTime,
      peakDecibels: fields[1] as double,
      durationSeconds: fields[2] as int,
      eventType: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AcousticEventHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.peakDecibels)
      ..writeByte(2)
      ..write(obj.durationSeconds)
      ..writeByte(3)
      ..write(obj.eventType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AcousticEventHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AcousticReportHiveAdapter extends TypeAdapter<AcousticReportHive> {
  @override
  final int typeId = 9;

  @override
  AcousticReportHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AcousticReportHive(
      id: fields[0] as String,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as DateTime,
      durationSeconds: fields[3] as int,
      presetIndex: fields[4] as int,
      averageDecibels: fields[5] as double,
      minDecibels: fields[6] as double,
      maxDecibels: fields[7] as double,
      events: (fields[8] as List).cast<AcousticEventHive>(),
      timeInLevels: (fields[9] as Map).cast<String, int>(),
      hourlyAverages: (fields[10] as List).cast<double>(),
      environmentQuality: fields[11] as String,
      recommendation: fields[12] as String,
      qualityScore: fields[13] as int?,
      interruptionCount: fields[14] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, AcousticReportHive obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.durationSeconds)
      ..writeByte(4)
      ..write(obj.presetIndex)
      ..writeByte(5)
      ..write(obj.averageDecibels)
      ..writeByte(6)
      ..write(obj.minDecibels)
      ..writeByte(7)
      ..write(obj.maxDecibels)
      ..writeByte(8)
      ..write(obj.events)
      ..writeByte(9)
      ..write(obj.timeInLevels)
      ..writeByte(10)
      ..write(obj.hourlyAverages)
      ..writeByte(11)
      ..write(obj.environmentQuality)
      ..writeByte(12)
      ..write(obj.recommendation)
      ..writeByte(13)
      ..write(obj.qualityScore)
      ..writeByte(14)
      ..write(obj.interruptionCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AcousticReportHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
