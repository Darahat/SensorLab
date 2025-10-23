import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/providers.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class CompassDisplayWidget extends ConsumerWidget {
  const CompassDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPoints = ref.watch(sensorTimeSeriesProvider(SensorType.compass));
    final compassData = ref.watch(compassProvider);

    return RealtimeLineChart(
      dataPoints: dataPoints,
      title: 'Compass (${compassData.heading?.toStringAsFixed(1) ?? "0.0"}°)',
      lineColor: Colors.cyan,
      minY: 0,
      maxY: 360,
      horizontalInterval: 90,
      leftTitleBuilder: (value) => '${value.toInt()}°',
    );
  }
}
