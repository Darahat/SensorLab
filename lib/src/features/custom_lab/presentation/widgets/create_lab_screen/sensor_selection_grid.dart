import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/notifiers/create_lab_notifier.dart';

/// Reusable sensor selection grid widget
class SensorSelectionGrid extends ConsumerWidget {
  final bool enabled;

  const SensorSelectionGrid({this.enabled = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createLabNotifierProvider);
    final selectedSensors = state.selectedSensors;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: SensorType.values.length,
      itemBuilder: (context, index) {
        final sensor = SensorType.values[index];
        final isSelected = selectedSensors.contains(sensor);

        return _SensorItem(
          sensor: sensor,
          isSelected: isSelected,
          enabled: enabled,
          onTap: () {
            ref.read(createLabNotifierProvider.notifier).toggleSensor(sensor);
          },
        );
      },
    );
  }
}

/// Individual sensor item widget
class _SensorItem extends StatelessWidget {
  final SensorType sensor;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const _SensorItem({
    required this.sensor,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getSensorIcon(sensor),
              size: 32,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              sensor.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSensorIcon(SensorType sensor) {
    switch (sensor) {
      case SensorType.accelerometer:
        return Icons.speed;
      case SensorType.gyroscope:
        return Icons.rotate_right;
      case SensorType.magnetometer:
        return Icons.explore;
      case SensorType.barometer:
        return Icons.speed;
      case SensorType.compass:
        return Icons.explore;
      case SensorType.lightMeter:
        return Icons.lightbulb;
      case SensorType.noiseMeter:
        return Icons.volume_up;
      case SensorType.pedometer:
        return Icons.directions_walk;
      case SensorType.gps:
        return Icons.gps_fixed;
      case SensorType.altimeter:
        return Icons.terrain;
      case SensorType.speedMeter:
        return Icons.speed;
      case SensorType.temperature:
        return Icons.thermostat;
      case SensorType.humidity:
        return Icons.water_drop;
      case SensorType.proximity:
        return Icons.sensors;
      case SensorType.heartBeat:
        return Icons.favorite;
      default:
        return Icons.sensors;
    }
  }
}
