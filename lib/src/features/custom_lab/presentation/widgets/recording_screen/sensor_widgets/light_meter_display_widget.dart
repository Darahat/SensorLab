import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/providers.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class LightMeterDisplayWidget extends ConsumerWidget {
  const LightMeterDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPoints = ref.watch(
      sensorTimeSeriesProvider(SensorType.lightMeter),
    );
    final lightMeterData = ref.watch(lightMeterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Current Reading Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(
                      lightMeterData.lightLevelColor,
                    ).withOpacity(0.2),
                    border: Border.all(
                      color: Color(lightMeterData.lightLevelColor),
                      width: 4,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lightMeterData.lightLevelIcon,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lightMeterData.formattedCurrentLux,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(lightMeterData.lightLevelColor),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lightMeterData.lightLevelDescription,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(lightMeterData.lightLevelColor),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                RealtimeLineChart(
                  dataPoints: dataPoints,
                  title: 'Light Level (lux)',
                  lineColor: Colors.yellow,
                  minY: 0,
                  maxY: dataPoints.isNotEmpty
                      ? dataPoints.reduce((a, b) => a > b ? a : b) * 1.2
                      : 1000,
                  horizontalInterval: 200,
                  leftTitleBuilder: (value) => '${value.toInt()}',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
