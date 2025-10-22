import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class LightMeterDisplayWidget extends ConsumerWidget {
  const LightMeterDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPoints = ref.watch(sensorTimeSeriesProvider(SensorType.lightMeter));

    return RealtimeLineChart(
      dataPoints: dataPoints,
      title: 'Light Level (lux)',
      lineColor: Colors.yellow,
      minY: 0,
      maxY: dataPoints.isNotEmpty
          ? dataPoints.reduce((a, b) => a > b ? a : b) * 1.2
          : 1000,
      horizontalInterval: 200,
      leftTitleBuilder: (value) => '${value.toInt()}',
    );
  }
}
