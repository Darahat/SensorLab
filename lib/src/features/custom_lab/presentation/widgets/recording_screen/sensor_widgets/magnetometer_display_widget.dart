import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class MagnetometerDisplayWidget extends ConsumerWidget {
  const MagnetometerDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPoints = ref.watch(sensorTimeSeriesProvider(SensorType.magnetometer));

    return RealtimeLineChart(
      dataPoints: dataPoints,
      title: 'Magnetic Field (µT)',
      lineColor: Colors.purple,
      minY: -100,
      maxY: 100,
      horizontalInterval: 50,
      leftTitleBuilder: (value) => '${value.toInt()}',
    );
  }
}
