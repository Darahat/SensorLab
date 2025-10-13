// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityTypeAdapter extends TypeAdapter<ActivityType> {
  @override
  final int typeId = 7;

  @override
  ActivityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityType.walking;
      case 1:
        return ActivityType.running;
      case 2:
        return ActivityType.cycling;
      case 3:
        return ActivityType.sitting;
      case 4:
        return ActivityType.standing;
      case 5:
        return ActivityType.stairs;
      case 6:
        return ActivityType.workout;
      default:
        return ActivityType.walking;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityType obj) {
    switch (obj) {
      case ActivityType.walking:
        writer.writeByte(0);
        break;
      case ActivityType.running:
        writer.writeByte(1);
        break;
      case ActivityType.cycling:
        writer.writeByte(2);
        break;
      case ActivityType.sitting:
        writer.writeByte(3);
        break;
      case ActivityType.standing:
        writer.writeByte(4);
        break;
      case ActivityType.stairs:
        writer.writeByte(5);
        break;
      case ActivityType.workout:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
