// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LabAdapter extends TypeAdapter<Lab> {
  @override
  final int typeId = 21;

  @override
  Lab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lab(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      sensors: (fields[3] as List).cast<SensorType>(),
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      isPreset: fields[6] as bool,
      iconName: fields[7] as String?,
      colorValue: fields[8] as int?,
      recordingInterval: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Lab obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.sensors)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.isPreset)
      ..writeByte(7)
      ..write(obj.iconName)
      ..writeByte(8)
      ..write(obj.colorValue)
      ..writeByte(9)
      ..write(obj.recordingInterval);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LabImpl _$$LabImplFromJson(Map<String, dynamic> json) => _$LabImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      sensors: (json['sensors'] as List<dynamic>)
          .map((e) => $enumDecode(_$SensorTypeEnumMap, e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPreset: json['isPreset'] as bool? ?? false,
      iconName: json['iconName'] as String?,
      colorValue: (json['colorValue'] as num?)?.toInt(),
      recordingInterval: (json['recordingInterval'] as num?)?.toInt() ?? 100,
    );

Map<String, dynamic> _$$LabImplToJson(_$LabImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'sensors': instance.sensors.map((e) => _$SensorTypeEnumMap[e]!).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isPreset': instance.isPreset,
      'iconName': instance.iconName,
      'colorValue': instance.colorValue,
      'recordingInterval': instance.recordingInterval,
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
