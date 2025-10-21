import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

/// Grid widget for selecting sensors
class SensorSelectionGrid extends StatelessWidget {
  final Set<SensorType> selectedSensors;
  final ValueChanged<SensorType> onSensorToggled;
  final bool enabled;

  const SensorSelectionGrid({
    required this.selectedSensors,
    required this.onSensorToggled,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: SensorType.values.length,
      itemBuilder: (context, index) {
        final sensor = SensorType.values[index];
        final isSelected = selectedSensors.contains(sensor);

        return InkWell(
          onTap: enabled ? () => onSensorToggled(sensor) : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getSensorIcon(sensor),
                  size: 32,
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 8),
                Text(
                  _getSensorLabel(sensor),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
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
    }
  }

  String _getSensorLabel(SensorType sensor) {
    switch (sensor) {
      case SensorType.accelerometer:
        return 'Accelero-\nmeter';
      case SensorType.gyroscope:
        return 'Gyroscope';
      case SensorType.magnetometer:
        return 'Magneto-\nmeter';
      case SensorType.barometer:
        return 'Barometer';
      case SensorType.lightMeter:
        return 'Light';
      case SensorType.noiseMeter:
        return 'Noise';
      case SensorType.gps:
        return 'GPS';
      case SensorType.proximity:
        return 'Proximity';
      case SensorType.temperature:
        return 'Temp';
      case SensorType.humidity:
        return 'Humidity';
      case SensorType.pedometer:
        return 'Pedometer';
      case SensorType.compass:
        return 'Compass';
      case SensorType.altimeter:
        return 'Altimeter';
      case SensorType.speedMeter:
        return 'Speed';
      case SensorType.heartBeat:
        return 'Heart Rate';
    }
  }
}
