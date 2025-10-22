import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class PedometerDisplayWidget extends ConsumerWidget {
  const PedometerDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPoints = ref.watch(sensorTimeSeriesProvider(SensorType.pedometer));

    return RealtimeLineChart(
      dataPoints: dataPoints,
      title: 'Steps',
      lineColor: Colors.pink,
      minY: 0,
      maxY: dataPoints.isNotEmpty
          ? dataPoints.reduce((a, b) => a > b ? a : b) * 1.2
          : 100,
      horizontalInterval: 50,
      leftTitleBuilder: (value) => '${value.toInt()}',
    );
  }
}
