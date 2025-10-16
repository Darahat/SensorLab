// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_tracking_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantTrackingSessionAdapter extends TypeAdapter<PlantTrackingSession> {
  @override
  final int typeId = 10;

  @override
  PlantTrackingSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantTrackingSession(
      id: fields[0] as String,
      plantName: fields[1] as String,
      plantTypeIndex: fields[2] as int,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime?,
      targetDLI: fields[5] as double,
      currentDLI: fields[6] as double,
      readings: (fields[7] as List).cast<LightReadingHive>(),
      isActive: fields[8] as bool,
      notes: fields[9] as String?,
      location: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PlantTrackingSession obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.plantName)
      ..writeByte(2)
      ..write(obj.plantTypeIndex)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.targetDLI)
      ..writeByte(6)
      ..write(obj.currentDLI)
      ..writeByte(7)
      ..write(obj.readings)
      ..writeByte(8)
      ..write(obj.isActive)
      ..writeByte(9)
      ..write(obj.notes)
      ..writeByte(10)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantTrackingSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LightReadingHiveAdapter extends TypeAdapter<LightReadingHive> {
  @override
  final int typeId = 11;

  @override
  LightReadingHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LightReadingHive(
      timestampMillis: fields[0] as int,
      lux: fields[1] as double,
      ppfd: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LightReadingHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timestampMillis)
      ..writeByte(1)
      ..write(obj.lux)
      ..writeByte(2)
      ..write(obj.ppfd);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LightReadingHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PhotoSessionAdapter extends TypeAdapter<PhotoSession> {
  @override
  final int typeId = 12;

  @override
  PhotoSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhotoSession(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      lux: fields[2] as double,
      iso: fields[3] as int,
      shutterSpeed: fields[4] as String,
      aperture: fields[5] as double,
      lightingConditionIndex: fields[6] as int,
      scenarioType: fields[7] as String?,
      notes: fields[8] as String?,
      location: fields[9] as String?,
      wasSuccessful: fields[10] as bool,
      rating: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PhotoSession obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.lux)
      ..writeByte(3)
      ..write(obj.iso)
      ..writeByte(4)
      ..write(obj.shutterSpeed)
      ..writeByte(5)
      ..write(obj.aperture)
      ..writeByte(6)
      ..write(obj.lightingConditionIndex)
      ..writeByte(7)
      ..write(obj.scenarioType)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.location)
      ..writeByte(10)
      ..write(obj.wasSuccessful)
      ..writeByte(11)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyLightSummaryAdapter extends TypeAdapter<DailyLightSummary> {
  @override
  final int typeId = 13;

  @override
  DailyLightSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyLightSummary(
      date: fields[0] as String,
      maxLux: fields[1] as double,
      minLux: fields[2] as double,
      averageLux: fields[3] as double,
      totalDLI: fields[4] as double,
      totalReadings: fields[5] as int,
      hourlyData: (fields[6] as List).cast<HourlyLightData>(),
      sunriseHour: fields[7] as int,
      sunsetHour: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailyLightSummary obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.maxLux)
      ..writeByte(2)
      ..write(obj.minLux)
      ..writeByte(3)
      ..write(obj.averageLux)
      ..writeByte(4)
      ..write(obj.totalDLI)
      ..writeByte(5)
      ..write(obj.totalReadings)
      ..writeByte(6)
      ..write(obj.hourlyData)
      ..writeByte(7)
      ..write(obj.sunriseHour)
      ..writeByte(8)
      ..write(obj.sunsetHour);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyLightSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HourlyLightDataAdapter extends TypeAdapter<HourlyLightData> {
  @override
  final int typeId = 14;

  @override
  HourlyLightData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HourlyLightData(
      hour: fields[0] as int,
      averageLux: fields[1] as double,
      maxLux: fields[2] as double,
      readingCount: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HourlyLightData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.hour)
      ..writeByte(1)
      ..write(obj.averageLux)
      ..writeByte(2)
      ..write(obj.maxLux)
      ..writeByte(3)
      ..write(obj.readingCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HourlyLightDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
