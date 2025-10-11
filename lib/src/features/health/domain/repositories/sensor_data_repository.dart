import '../entities/activity_session.dart';

/// Repository interface for Sensor Data operations
/// Defines the contract for accessing device sensors
abstract class SensorDataRepository {
  /// Start listening to accelerometer data
  Stream<MovementData> getAccelerometerStream();

  /// Start listening to gyroscope data
  Stream<GyroscopeData> getGyroscopeStream();

  /// Stop all sensor streams
  Future<void> stopSensorStreams();

  /// Check if sensors are available
  Future<bool> areSensorsAvailable();

  /// Get sensor sampling rate
  Future<SensorSamplingRate> getSamplingRate();

  /// Set sensor sampling rate
  Future<void> setSamplingRate(SensorSamplingRate rate);

  /// Calibrate sensors
  Future<void> calibrateSensors();

  /// Get sensor accuracy
  Future<SensorAccuracy> getSensorAccuracy();
}

class GyroscopeData {
  final DateTime timestamp;
  final double x, y, z;

  const GyroscopeData({
    required this.timestamp,
    required this.x,
    required this.y,
    required this.z,
  });
}

enum SensorSamplingRate {
  slow,
  normal,
  fast,
  fastest;

  Duration get interval {
    switch (this) {
      case SensorSamplingRate.slow:
        return Duration(milliseconds: 200);
      case SensorSamplingRate.normal:
        return Duration(milliseconds: 100);
      case SensorSamplingRate.fast:
        return Duration(milliseconds: 50);
      case SensorSamplingRate.fastest:
        return Duration(milliseconds: 20);
    }
  }
}

enum SensorAccuracy {
  unreliable,
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case SensorAccuracy.unreliable:
        return 'Unreliable';
      case SensorAccuracy.low:
        return 'Low';
      case SensorAccuracy.medium:
        return 'Medium';
      case SensorAccuracy.high:
        return 'High';
    }
  }
}
