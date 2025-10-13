import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sensorData,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${l10n.stepsLabel}: $steps'),
            const SizedBox(height: 8),
            Text('${l10n.accelX}: ${accelEvent?.x.toStringAsFixed(2) ?? '-'}'),
            Text('${l10n.accelY}: ${accelEvent?.y.toStringAsFixed(2) ?? '-'}'),
            Text('${l10n.accelZ}: ${accelEvent?.z.toStringAsFixed(2) ?? '-'}'),
            if (gyroEvent != null) ...[
              const SizedBox(height: 8),
              Text('${l10n.gyroX}: ${gyroEvent!.x.toStringAsFixed(2)}'),
              Text('${l10n.gyroY}: ${gyroEvent!.y.toStringAsFixed(2)}'),
              Text('${l10n.gyroZ}: ${gyroEvent!.z.toStringAsFixed(2)}'),
            ],
          ],
        ),
      ),
    );
  }
}
