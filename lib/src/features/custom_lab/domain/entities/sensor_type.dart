import 'package:hive/hive.dart';

part 'sensor_type.g.dart';

/// Enum representing available sensor types that can be included in a lab
@HiveType(typeId: 20)
enum SensorType {
  @HiveField(0)
  accelerometer,

  @HiveField(1)
  gyroscope,

  @HiveField(2)
  magnetometer,

  @HiveField(3)
  barometer,

  @HiveField(4)
  lightMeter,

  @HiveField(5)
  noiseMeter,

  @HiveField(6)
  gps,

  @HiveField(7)
  proximity,

  @HiveField(8)
  temperature,

  @HiveField(9)
  humidity,

  @HiveField(10)
  pedometer,

  @HiveField(11)
  compass,

  @HiveField(12)
  altimeter,

  @HiveField(13)
  speedMeter,

  @HiveField(14)
  heartBeat;

  /// Get display name for the sensor
  String get displayName {
    switch (this) {
      case SensorType.accelerometer:
        return 'Accelerometer';
      case SensorType.gyroscope:
        return 'Gyroscope';
      case SensorType.magnetometer:
        return 'Magnetometer';
      case SensorType.barometer:
        return 'Barometer';
      case SensorType.lightMeter:
        return 'Light Meter';
      case SensorType.noiseMeter:
        return 'Noise Meter';
      case SensorType.gps:
        return 'GPS';
      case SensorType.proximity:
        return 'Proximity';
      case SensorType.temperature:
        return 'Temperature';
      case SensorType.humidity:
        return 'Humidity';
      case SensorType.pedometer:
        return 'Pedometer';
      case SensorType.compass:
        return 'Compass';
      case SensorType.altimeter:
        return 'Altimeter';
      case SensorType.speedMeter:
        return 'Speed Meter';
      case SensorType.heartBeat:
        return 'Heart Rate';
    }
  }

  /// Get icon name for the sensor
  String get iconName {
    switch (this) {
      case SensorType.accelerometer:
        return 'accelerometer';
      case SensorType.gyroscope:
        return 'gyroscope';
      case SensorType.magnetometer:
        return 'magnetometer';
      case SensorType.barometer:
        return 'barometer';
      case SensorType.lightMeter:
        return 'light_meter';
      case SensorType.noiseMeter:
        return 'noise_meter';
      case SensorType.gps:
        return 'gps';
      case SensorType.proximity:
        return 'proximity';
      case SensorType.temperature:
        return 'temperature';
      case SensorType.humidity:
        return 'humidity';
      case SensorType.pedometer:
        return 'pedometer';
      case SensorType.compass:
        return 'compass';
      case SensorType.altimeter:
        return 'altimeter';
      case SensorType.speedMeter:
        return 'speed_meter';
      case SensorType.heartBeat:
        return 'heart_rate';
    }
  }
}
