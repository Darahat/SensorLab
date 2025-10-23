import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/providers.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class BarometerDisplayWidget extends ConsumerWidget {
  const BarometerDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPoints = ref.watch(
      sensorTimeSeriesProvider(SensorType.barometer),
    );
    final altimeterData = ref.watch(altimeterProvider);

    return RealtimeLineChart(
      dataPoints: dataPoints,
      title: 'Pressure (${altimeterData.pressure.toStringAsFixed(1)} hPa)',
      lineColor: Colors.indigo,
      minY: 950,
      maxY: 1050,
      horizontalInterval: 25,
      leftTitleBuilder: (value) => '${value.toInt()}',
    );
  }
}
