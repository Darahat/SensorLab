import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class AccelerometerDisplayWidget extends ConsumerWidget {
  const AccelerometerDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPoints = ref.watch(sensorTimeSeriesProvider(SensorType.accelerometer));

    return RealtimeLineChart(
      dataPoints: dataPoints,
      title: 'Acceleration (m/s²)',
      lineColor: Colors.green,
      minY: -15,
      maxY: 15,
      horizontalInterval: 5,
      leftTitleBuilder: (value) => '${value.toInt()}',
    );
  }
}
