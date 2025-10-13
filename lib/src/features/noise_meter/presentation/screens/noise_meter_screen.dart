import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

import '../../../../core/providers.dart';

class NoiseMeterScreen extends ConsumerStatefulWidget {
  const NoiseMeterScreen({super.key});

  @override
  ConsumerState<NoiseMeterScreen> createState() => _NoiseMeterScreenState();
}

class _NoiseMeterScreenState extends ConsumerState<NoiseMeterScreen> {
  @override
  void initState() {
    super.initState();
    // Check permission when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(noiseMeterProvider.notifier).checkPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    final noiseMeterData = ref.watch(noiseMeterProvider);
    final noiseMeterNotifier = ref.read(noiseMeterProvider.notifier);

    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.noiseMeter),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => noiseMeterNotifier.resetData(),
                tooltip: l10n.resetData,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Permission Status
                if (!noiseMeterData.hasPermission)
                  Card(
                    color: Colors.orange.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.mic_off,
                            size: 48,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.permissionRequired,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Grant microphone permission to measure noise levels',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                noiseMeterNotifier.checkPermission(),
                            child: Text(l10n.grantPermission),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Current Reading Card
                if (noiseMeterData.hasPermission) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                noiseMeterData.isRecording
                                    ? Icons.mic
                                    : Icons.mic_off,
                                size: 32,
                                color: noiseMeterData.isRecording
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                noiseMeterData.isRecording
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

                          // Current Decibel Reading
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(
                                noiseMeterData.noiseLevelColor,
                              ).withOpacity(0.1),
                              border: Border.all(
                                color: Color(noiseMeterData.noiseLevelColor),
                                width: 4,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  noiseMeterData.formattedCurrentDecibels,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(
                                      noiseMeterData.noiseLevelColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  noiseMeterData.noiseLevelDescription,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(
                                      noiseMeterData.noiseLevelColor,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Control Button
                          ElevatedButton.icon(
                            onPressed: () =>
                                noiseMeterNotifier.toggleMeasurement(),
                            icon: Icon(
                              noiseMeterData.isRecording
                                  ? Icons.stop
                                  : Icons.play_arrow,
                            ),
                            label: Text(
                              noiseMeterData.isRecording
                                  ? l10n.stop
                                  : l10n.start,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: noiseMeterData.isRecording
                                  ? Colors.red
                                  : Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Statistics Card
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
                                  noiseMeterData.formattedSessionDuration,
                                  Icons.timer,
                                  Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStatCard(
                                  l10n.readings,
                                  '${noiseMeterData.totalReadings}',
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
                                  noiseMeterData.formattedMinDecibels,
                                  Icons.keyboard_arrow_down,
                                  Colors.green,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStatCard(
                                  l10n.average,
                                  noiseMeterData.formattedAverageDecibels,
                                  Icons.remove,
                                  Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStatCard(
                                  l10n.maxStat,
                                  noiseMeterData.formattedMaxDecibels,
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

                  // Real-time Chart
                  if (noiseMeterData.recentReadings.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Real-time Noise Levels',
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
                                        reservedSize: 40,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${value.toInt()}',
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
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
                                      spots: noiseMeterData.recentReadings
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
                                        noiseMeterData.noiseLevelColor,
                                      ),
                                      barWidth: 2,
                                      dotData: const FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: Color(
                                          noiseMeterData.noiseLevelColor,
                                        ).withOpacity(0.1),
                                      ),
                                    ),
                                  ],
                                  minY: 0,
                                  maxY: 120,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Noise Level Guide
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.noiseLevelGuide,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildNoiseGuideItem(
                            l10n.quiet,
                            '0-30 dB',
                            l10n.whisperLibrary,
                            Colors.green,
                          ),
                          _buildNoiseGuideItem(
                            l10n.moderate,
                            '30-60 dB',
                            l10n.normalConversation,
                            Colors.lightGreen,
                          ),
                          _buildNoiseGuideItem(
                            l10n.loud,
                            '60-85 dB',
                            l10n.trafficOffice,
                            Colors.orange,
                          ),
                          _buildNoiseGuideItem(
                            l10n.veryLoud,
                            '85-100 dB',
                            l10n.motorcycleShouting,
                            Colors.deepOrange,
                          ),
                          _buildNoiseGuideItem(
                            l10n.dangerous,
                            '100+ dB',
                            l10n.rockConcertChainsaw,
                            Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Error Message
                if (noiseMeterData.errorMessage != null)
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
                              noiseMeterData.errorMessage!,
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

  Widget _buildNoiseGuideItem(
    String level,
    String range,
    String examples,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$level ($range)',
                  style: const TextStyle(fontWeight: FontWeight.w500),
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
