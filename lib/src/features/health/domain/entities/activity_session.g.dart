// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivitySessionAdapter extends TypeAdapter<ActivitySession> {
  @override
  final int typeId = 3;

  @override
  ActivitySession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivitySession(
      id: fields[0] as String,
      activityType: fields[1] as ActivityType,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime?,
      status: fields[4] as SessionStatus,
      steps: fields[5] as int,
      distance: fields[6] as double,
      calories: fields[7] as double,
      activeDuration: fields[8] as Duration,
      averageIntensity: fields[9] as double,
      peakIntensity: fields[10] as double,
      movements: (fields[11] as List).cast<MovementData>(),
      goals: fields[12] as Goals,
    );
  }

  @override
  void write(BinaryWriter writer, ActivitySession obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.activityType)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.steps)
      ..writeByte(6)
      ..write(obj.distance)
      ..writeByte(7)
      ..write(obj.calories)
      ..writeByte(8)
      ..write(obj.activeDuration)
      ..writeByte(9)
      ..write(obj.averageIntensity)
      ..writeByte(10)
      ..write(obj.peakIntensity)
      ..writeByte(11)
      ..write(obj.movements)
      ..writeByte(12)
      ..write(obj.goals);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivitySessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovementDataAdapter extends TypeAdapter<MovementData> {
  @override
  final int typeId = 5;

  @override
  MovementData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovementData(
      timestamp: fields[0] as DateTime,
      x: fields[1] as double,
      y: fields[2] as double,
      z: fields[3] as double,
      intensity: fields[4] as double,
      isStep: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MovementData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.x)
      ..writeByte(2)
      ..write(obj.y)
      ..writeByte(3)
      ..write(obj.z)
      ..writeByte(4)
      ..write(obj.intensity)
      ..writeByte(5)
      ..write(obj.isStep);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovementDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GoalsAdapter extends TypeAdapter<Goals> {
  @override
  final int typeId = 6;

  @override
  Goals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Goals(
      targetSteps: fields[0] as int,
      targetCalories: fields[1] as double,
      targetDuration: fields[2] as Duration,
      targetDistance: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Goals obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.targetSteps)
      ..writeByte(1)
      ..write(obj.targetCalories)
      ..writeByte(2)
      ..write(obj.targetDuration)
      ..writeByte(3)
      ..write(obj.targetDistance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionStatusAdapter extends TypeAdapter<SessionStatus> {
  @override
  final int typeId = 4;

  @override
  SessionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SessionStatus.active;
      case 1:
        return SessionStatus.paused;
      case 2:
        return SessionStatus.completed;
      case 3:
        return SessionStatus.cancelled;
      default:
        return SessionStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, SessionStatus obj) {
    switch (obj) {
      case SessionStatus.active:
        writer.writeByte(0);
        break;
      case SessionStatus.paused:
        writer.writeByte(1);
        break;
      case SessionStatus.completed:
        writer.writeByte(2);
        break;
      case SessionStatus.cancelled:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
