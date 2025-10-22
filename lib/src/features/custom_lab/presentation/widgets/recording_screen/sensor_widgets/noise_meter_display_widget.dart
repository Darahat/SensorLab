import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class NoiseMeterDisplayWidget extends ConsumerWidget {
  const NoiseMeterDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPoints = ref.watch(sensorTimeSeriesProvider(SensorType.noiseMeter));

    return RealtimeLineChart(
      dataPoints: dataPoints,
      title: 'Noise Level (dB)',
      lineColor: Colors.red,
      minY: 0,
      maxY: 120,
      horizontalInterval: 20,
      leftTitleBuilder: (value) => '${value.toInt()}',
    );
  }
}
