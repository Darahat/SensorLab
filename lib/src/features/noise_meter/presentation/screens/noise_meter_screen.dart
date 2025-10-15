import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/shared/widgets/common_cards.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

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
                                child: StatCard(
                                  icon: Icons.timer,
                                  label: l10n.duration,
                                  value:
                                      noiseMeterData.formattedSessionDuration,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: StatCard(
                                  icon: Icons.analytics,
                                  label: l10n.readings,
                                  value: '${noiseMeterData.totalReadings}',
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  icon: Icons.keyboard_arrow_down,
                                  label: l10n.minStat,
                                  value: noiseMeterData.formattedMinDecibels,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: StatCard(
                                  icon: Icons.remove,
                                  label: l10n.average,
                                  value:
                                      noiseMeterData.formattedAverageDecibels,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: StatCard(
                                  icon: Icons.keyboard_arrow_up,
                                  label: l10n.maxStat,
                                  value: noiseMeterData.formattedMaxDecibels,
                                  color: Colors.red,
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
                    RealtimeLineChart(
                      title: 'Real-time Noise Levels',
                      dataPoints: noiseMeterData.recentReadings,
                      lineColor: Color(noiseMeterData.noiseLevelColor),
                      maxY: 120,
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
