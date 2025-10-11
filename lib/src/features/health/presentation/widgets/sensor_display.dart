import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorDisplay extends StatelessWidget {
  final UserAccelerometerEvent? accelEvent;
  final GyroscopeEvent? gyroEvent;
  final int steps;

  const SensorDisplay({
    super.key,
    required this.accelEvent,
    required this.gyroEvent,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SENSOR DATA',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Steps: $steps'),
            const SizedBox(height: 8),
            Text('Accel X: ${accelEvent?.x.toStringAsFixed(2) ?? '-'}'),
            Text('Accel Y: ${accelEvent?.y.toStringAsFixed(2) ?? '-'}'),
            Text('Accel Z: ${accelEvent?.z.toStringAsFixed(2) ?? '-'}'),
            if (gyroEvent != null) ...[
              const SizedBox(height: 8),
              Text('Gyro X: ${gyroEvent!.x.toStringAsFixed(2)}'),
              Text('Gyro Y: ${gyroEvent!.y.toStringAsFixed(2)}'),
              Text('Gyro Z: ${gyroEvent!.z.toStringAsFixed(2)}'),
            ],
          ],
        ),
      ),
    );
  }
}
