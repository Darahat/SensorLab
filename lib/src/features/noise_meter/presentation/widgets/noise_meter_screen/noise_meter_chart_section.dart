import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/noise_meter/utils/utils_index.dart'; // ← Use shared widgets
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart'; // ← Use shared widgets

class NoiseMeterChartSection extends StatelessWidget {
  final EnhancedNoiseMeterData data;

  const NoiseMeterChartSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final noiseColor = NoiseFormatters.getNoiseLevelColor(data.noiseLevel);

    return RealtimeLineChart(
      // ← This now uses the shared widget
      title: 'Real-time Noise Levels',
      dataPoints: data.decibelHistory,
      lineColor: noiseColor,
      minY: 0,
      maxY: 120,
      horizontalInterval: 30,
      leftTitleBuilder: (value) => '${value.toInt()} dB',
    );
  }
}
