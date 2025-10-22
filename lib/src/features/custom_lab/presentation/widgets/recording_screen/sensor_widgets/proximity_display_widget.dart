import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class ProximityDisplayWidget extends ConsumerWidget {
  const ProximityDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPoints = ref.watch(sensorTimeSeriesProvider(SensorType.proximity));

    return RealtimeLineChart(
      dataPoints: dataPoints,
      title: 'Proximity (cm)',
      lineColor: Colors.amber,
      minY: 0,
      maxY: 10,
      horizontalInterval: 2,
      leftTitleBuilder: (value) => '${value.toInt()}',
    );
  }
}
