// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data_point.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SensorDataPointAdapter extends TypeAdapter<SensorDataPoint> {
  @override
  final int typeId = 24;

  @override
  SensorDataPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SensorDataPoint(
      sessionId: fields[0] as String,
      timestamp: fields[1] as DateTime,
      sensorValues: (fields[2] as Map).cast<SensorType, dynamic>(),
      sequenceNumber: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SensorDataPoint obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.sensorValues)
      ..writeByte(3)
      ..write(obj.sequenceNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorDataPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SensorDataPointImpl _$$SensorDataPointImplFromJson(
        Map<String, dynamic> json) =>
    _$SensorDataPointImpl(
      sessionId: json['sessionId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      sensorValues:
          _sensorValuesFromJson(json['sensorValues'] as Map<String, dynamic>),
      sequenceNumber: (json['sequenceNumber'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SensorDataPointImplToJson(
        _$SensorDataPointImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'timestamp': instance.timestamp.toIso8601String(),
      'sensorValues': _sensorValuesToJson(instance.sensorValues),
      'sequenceNumber': instance.sequenceNumber,
    };
