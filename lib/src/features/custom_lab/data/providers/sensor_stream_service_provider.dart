import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/data/services/sensor_stream_service.dart';

/// Provider for Sensor Stream service
final sensorStreamServiceProvider = Provider<SensorStreamService>(
  (ref) => SensorStreamService(),
);
