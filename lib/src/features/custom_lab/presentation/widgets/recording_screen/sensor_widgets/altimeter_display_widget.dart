import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/providers.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class AltimeterDisplayWidget extends ConsumerWidget {
  const AltimeterDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPoints = ref.watch(
      sensorTimeSeriesProvider(SensorType.altimeter),
    );
    final altimeterData = ref.watch(altimeterProvider);

    return RealtimeLineChart(
      dataPoints: dataPoints,
      title: 'Altitude (${altimeterData.altitude.toStringAsFixed(1)} m)',
      lineColor: Colors.brown,
      minY: dataPoints.isNotEmpty
          ? dataPoints.reduce((a, b) => a < b ? a : b) - 50
          : 0,
      maxY: dataPoints.isNotEmpty
          ? dataPoints.reduce((a, b) => a > b ? a : b) + 50
          : 100,
      horizontalInterval: 50,
      leftTitleBuilder: (value) => '${value.toInt()}',
    );
  }
}
