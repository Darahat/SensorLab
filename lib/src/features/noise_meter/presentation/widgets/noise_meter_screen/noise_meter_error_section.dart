import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/noise_meter/application/state/enhanced_noise_data.dart';

class NoiseMeterErrorSection extends StatelessWidget {
  final EnhancedNoiseMeterData data;

  const NoiseMeterErrorSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(data.errorMessage ?? 'An error occurred.'),
      ),
    );
  }
}
