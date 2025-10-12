import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

import '../../../../core/providers.dart';

class LightMeterScreen extends ConsumerStatefulWidget {
  const LightMeterScreen({super.key});

  @override
  ConsumerState<LightMeterScreen> createState() => _LightMeterScreenState();
}

class _LightMeterScreenState extends ConsumerState<LightMeterScreen> {
  @override
  void initState() {
    super.initState();
    // Get initial reading when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lightMeterProvider.notifier).getSingleReading();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lightMeterData = ref.watch(lightMeterProvider);
    final lightMeterNotifier = ref.read(lightMeterProvider.notifier);

    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.lightMeter),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => lightMeterNotifier.resetData(),
                tooltip: l10n.resetData,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Current Reading Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              lightMeterData.isReading
                                  ? Icons.lightbulb
                                  : Icons.lightbulb_outline,
                              size: 32,
                              color: lightMeterData.isReading
                                  ? Colors.yellow
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              lightMeterData.isReading
                                  ? l10n.measuring
                                  : l10n.stopped,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Current Light Reading Display
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

                        // Control Buttons
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () =>
                                  lightMeterNotifier.getSingleReading(),
                              icon: const Icon(Icons.camera_alt),
                              label: Text(l10n.singleReading),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  lightMeterNotifier.toggleMeasurement(),
                              icon: Icon(
                                lightMeterData.isReading
                                    ? Icons.stop
                                    : Icons.play_arrow,
                              ),
                              label: Text(
                                lightMeterData.isReading
                                    ? l10n.stop
                                    : l10n.continuous,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: lightMeterData.isReading
                                    ? Colors.red
                                    : Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Statistics Card (only show if we have session data)
                if (lightMeterData.totalReadings > 0) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.sessionStatistics,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  l10n.duration,
                                  lightMeterData.formattedSessionDuration,
                                  Icons.timer,
                                  Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStatCard(
                                  l10n.readings,
                                  '${lightMeterData.totalReadings}',
                                  Icons.analytics,
                                  Colors.purple,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  l10n.minStat,
                                  lightMeterData.formattedMinLux,
                                  Icons.keyboard_arrow_down,
                                  Colors.green,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStatCard(
                                  l10n.average,
                                  lightMeterData.formattedAverageLux,
                                  Icons.remove,
                                  Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStatCard(
                                  l10n.maxStat,
                                  lightMeterData.formattedMaxLux,
                                  Icons.keyboard_arrow_up,
                                  Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],

                // Real-time Chart (only show if we have data)
                if (lightMeterData.recentReadings.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Real-time Light Levels',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: true),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 50,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          '${value.toInt()}',
                                          style: const TextStyle(fontSize: 10),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                borderData: FlBorderData(show: true),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: lightMeterData.recentReadings
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          return FlSpot(
                                            entry.key.toDouble(),
                                            entry.value,
                                          );
                                        })
                                        .toList(),
                                    isCurved: true,
                                    color: Color(
                                      lightMeterData.lightLevelColor,
                                    ),
                                    barWidth: 2,
                                    dotData: const FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Color(
                                        lightMeterData.lightLevelColor,
                                      ).withOpacity(0.1),
                                    ),
                                  ),
                                ],
                                minY: 0,
                                maxY: lightMeterData.recentReadings.isNotEmpty
                                    ? lightMeterData.recentReadings.reduce(
                                            (a, b) => a > b ? a : b,
                                          ) *
                                          1.2
                                    : 100,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Light Level Guide
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Light Level Guide',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildLightGuideItem(
                          '🌑',
                          'Dark',
                          '0-10 lux',
                          'Night, no moonlight',
                          Colors.grey[800]!,
                        ),
                        _buildLightGuideItem(
                          '🌘',
                          'Dim',
                          '10-200 lux',
                          'Moonlight, candle',
                          Colors.grey[600]!,
                        ),
                        _buildLightGuideItem(
                          '💡',
                          'Indoor',
                          '200-500 lux',
                          'Living room lighting',
                          Colors.orange,
                        ),
                        _buildLightGuideItem(
                          '🏢',
                          'Office',
                          '500-1000 lux',
                          'Office workspace',
                          Colors.yellow[700]!,
                        ),
                        _buildLightGuideItem(
                          '☀️',
                          'Bright',
                          '1000-10000 lux',
                          'Bright room, cloudy day',
                          Colors.yellow,
                        ),
                        _buildLightGuideItem(
                          '🌞',
                          'Daylight',
                          '10000+ lux',
                          'Direct sunlight',
                          Colors.yellow[200]!,
                        ),
                      ],
                    ),
                  ),
                ),

                // Error Message
                if (lightMeterData.errorMessage != null)
                  Card(
                    color: Colors.red.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              lightMeterData.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLightGuideItem(
    String emoji,
    String level,
    String range,
    String examples,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$level ($range)',
                  style: TextStyle(fontWeight: FontWeight.w500, color: color),
                ),
                Text(
                  examples,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
