import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

/// Reusable widget for displaying sensor chips
class SensorChipList extends StatelessWidget {
  final List<SensorType> sensors;

  const SensorChipList({required this.sensors, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sensors.map((sensor) {
        return Chip(
          avatar: Icon(_getSensorIcon(sensor), size: 18),
          label: Text(
            sensor.name.replaceAll('_', ' ').toUpperCase(),
            style: theme.textTheme.bodySmall,
          ),
        );
      }).toList(),
    );
  }

  IconData _getSensorIcon(SensorType sensor) {
    switch (sensor) {
      case SensorType.accelerometer:
        return Icons.speed;
      case SensorType.gyroscope:
        return Icons.screen_rotation;
      case SensorType.magnetometer:
        return Icons.explore;
      case SensorType.barometer:
        return Icons.compress;
      case SensorType.lightMeter:
        return Icons.light_mode;
      case SensorType.noiseMeter:
        return Icons.volume_up;
      case SensorType.gps:
        return Icons.location_on;
      case SensorType.proximity:
        return Icons.phonelink_ring;
      case SensorType.temperature:
        return Icons.thermostat;
      case SensorType.humidity:
        return Icons.water_drop;
      case SensorType.pedometer:
        return Icons.directions_walk;
      case SensorType.compass:
        return Icons.compass_calibration;
      case SensorType.altimeter:
        return Icons.terrain;
      case SensorType.speedMeter:
        return Icons.speed;
      case SensorType.heartBeat:
        return Icons.favorite;
      default:
        return Icons.sensors;
    }
  }
}
