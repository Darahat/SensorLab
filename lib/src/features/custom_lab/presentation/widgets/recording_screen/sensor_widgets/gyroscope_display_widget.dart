import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class GyroscopeDisplayWidget extends ConsumerWidget {
  const GyroscopeDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPoints = ref.watch(sensorTimeSeriesProvider(SensorType.gyroscope));

    return RealtimeLineChart(
      dataPoints: dataPoints,
      title: 'Gyroscope (rad/s)',
      lineColor: Colors.teal,
      minY: -10,
      maxY: 10,
      horizontalInterval: 5,
      leftTitleBuilder: (value) => '${value.toInt()}',
    );
  }
}
