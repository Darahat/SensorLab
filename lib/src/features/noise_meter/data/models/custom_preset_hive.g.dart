// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_preset_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomPresetHiveAdapter extends TypeAdapter<CustomPresetHive> {
  @override
  final int typeId = 15;

  @override
  CustomPresetHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomPresetHive(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      durationInMinutes: fields[3] as int,
      iconCodePoint: fields[4] as int,
      colorValue: fields[5] as int,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CustomPresetHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.durationInMinutes)
      ..writeByte(4)
      ..write(obj.iconCodePoint)
      ..writeByte(5)
      ..write(obj.colorValue)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomPresetHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
