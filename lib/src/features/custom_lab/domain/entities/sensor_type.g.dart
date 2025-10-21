// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SensorTypeAdapter extends TypeAdapter<SensorType> {
  @override
  final int typeId = 20;

  @override
  SensorType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SensorType.accelerometer;
      case 1:
        return SensorType.gyroscope;
      case 2:
        return SensorType.magnetometer;
      case 3:
        return SensorType.barometer;
      case 4:
        return SensorType.lightMeter;
      case 5:
        return SensorType.noiseMeter;
      case 6:
        return SensorType.gps;
      case 7:
        return SensorType.proximity;
      case 8:
        return SensorType.temperature;
      case 9:
        return SensorType.humidity;
      case 10:
        return SensorType.pedometer;
      case 11:
        return SensorType.compass;
      case 12:
        return SensorType.altimeter;
      case 13:
        return SensorType.speedMeter;
      case 14:
        return SensorType.heartBeat;
      default:
        return SensorType.accelerometer;
    }
  }

  @override
  void write(BinaryWriter writer, SensorType obj) {
    switch (obj) {
      case SensorType.accelerometer:
        writer.writeByte(0);
        break;
      case SensorType.gyroscope:
        writer.writeByte(1);
        break;
      case SensorType.magnetometer:
        writer.writeByte(2);
        break;
      case SensorType.barometer:
        writer.writeByte(3);
        break;
      case SensorType.lightMeter:
        writer.writeByte(4);
        break;
      case SensorType.noiseMeter:
        writer.writeByte(5);
        break;
      case SensorType.gps:
        writer.writeByte(6);
        break;
      case SensorType.proximity:
        writer.writeByte(7);
        break;
      case SensorType.temperature:
        writer.writeByte(8);
        break;
      case SensorType.humidity:
        writer.writeByte(9);
        break;
      case SensorType.pedometer:
        writer.writeByte(10);
        break;
      case SensorType.compass:
        writer.writeByte(11);
        break;
      case SensorType.altimeter:
        writer.writeByte(12);
        break;
      case SensorType.speedMeter:
        writer.writeByte(13);
        break;
      case SensorType.heartBeat:
        writer.writeByte(14);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
