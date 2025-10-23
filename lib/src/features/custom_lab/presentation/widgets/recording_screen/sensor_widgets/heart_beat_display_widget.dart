import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/providers.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class HeartBeatDisplayWidget extends ConsumerWidget {
  const HeartBeatDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPoints = ref.watch(
      sensorTimeSeriesProvider(SensorType.heartBeat),
    );
    final heartBeatData = ref.watch(heartBeatProvider);

    return RealtimeLineChart(
      dataPoints: dataPoints,
      title: 'Heart Rate (${heartBeatData.bpm} bpm)',
      lineColor: Colors.red,
      minY: 40,
      maxY: 200,
      horizontalInterval: 40,
      leftTitleBuilder: (value) => '${value.toInt()}',
    );
  }
}
