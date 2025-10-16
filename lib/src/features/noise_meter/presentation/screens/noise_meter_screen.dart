import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/enhanced_noise_meter_provider.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/acoustic_preset_selection_screen.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/acoustic_reports_list_screen.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/index.dart';
import 'package:sensorlab/src/shared/widgets/common_cards.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class NoiseMeterScreen extends ConsumerWidget {
  const NoiseMeterScreen({super.key});

  String _getFormattedDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getNoiseLevelDescription(NoiseLevel level) {
    switch (level) {
      case NoiseLevel.quiet:
        return 'Quiet (0-30 dB)';
      case NoiseLevel.moderate:
        return 'Moderate (30-60 dB)';
      case NoiseLevel.loud:
        return 'Loud (60-85 dB)';
      case NoiseLevel.veryLoud:
        return 'Very Loud (85-100 dB)';
      case NoiseLevel.dangerous:
        return 'Dangerous (100+ dB)';
    }
  }

  Color _getNoiseLevelColor(NoiseLevel level) {
    switch (level) {
      case NoiseLevel.quiet:
        return Colors.green;
      case NoiseLevel.moderate:
        return Colors.lightGreen;
      case NoiseLevel.loud:
        return Colors.orange;
      case NoiseLevel.veryLoud:
        return Colors.deepOrange;
      case NoiseLevel.dangerous:
        return Colors.red;
    }
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecibelStat({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'dB',
          style: theme.textTheme.bodySmall?.copyWith(
            color: color.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noiseMeterData = ref.watch(enhancedNoiseMeterProvider);
    final noiseMeterNotifier = ref.read(enhancedNoiseMeterProvider.notifier);

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final noiseColor = _getNoiseLevelColor(noiseMeterData.noiseLevel);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.noiseMeter),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => noiseMeterNotifier.stopRecording(),
            tooltip: l10n.resetData,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                          onPressed: () => noiseMeterNotifier
                              .startRecordingWithPreset(RecordingPreset.custom),
                          child: Text(l10n.grantPermission),
                        ),
                      ],
                    ),
                  ),
                ),

              // Acoustic Environment Analyzer Section
              if (noiseMeterData.hasPermission) ...[
                const SizedBox(height: 16),

                // Feature Cards Row
                Row(
                  children: [
                    Expanded(
                      child: _buildFeatureCard(
                        context: context,
                        icon: Iconsax.chart_21,
                        title: 'Environment Analyzer',
                        subtitle: 'Preset-based analysis',
                        color: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AcousticPresetSelectionScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFeatureCard(
                        context: context,
                        icon: Iconsax.document_text,
                        title: 'View Reports',
                        subtitle: 'Saved analyses',
                        color: Colors.purple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AcousticReportsListScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

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
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: noiseColor.withOpacity(0.1),
                            border: Border.all(color: noiseColor, width: 4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${noiseMeterData.currentDecibels.toStringAsFixed(1)} dB',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: noiseColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getNoiseLevelDescription(
                                  noiseMeterData.noiseLevel,
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: noiseColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (noiseMeterData.isRecording) {
                              noiseMeterNotifier.stopRecording();
                            } else {
                              noiseMeterNotifier.startRecordingWithPreset(
                                RecordingPreset.custom,
                              );
                            }
                          },
                          icon: Icon(
                            noiseMeterData.isRecording
                                ? Icons.stop
                                : Icons.play_arrow,
                          ),
                          label: Text(
                            noiseMeterData.isRecording ? l10n.stop : l10n.start,
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.sessionStatistics,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Duration and Readings Row
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                icon: Icons.timer,
                                label: l10n.duration,
                                value: _getFormattedDuration(
                                  noiseMeterData.sessionDuration,
                                ),
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 12),
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

                        const SizedBox(height: 20),

                        // Decibel Statistics Title
                        Text(
                          'Decibel Statistics',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Min, Avg, Max - Better Layout
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildDecibelStat(
                              context: context,
                              icon: Icons.arrow_downward_rounded,
                              label: l10n.minStat,
                              value:
                                  noiseMeterData.minDecibels == double.infinity
                                  ? '--'
                                  : noiseMeterData.minDecibels.toStringAsFixed(
                                      1,
                                    ),
                              color: Colors.green,
                            ),
                            _buildDecibelStat(
                              context: context,
                              icon: Icons.show_chart,
                              label: l10n.average,
                              value: noiseMeterData.averageDecibels
                                  .toStringAsFixed(1),
                              color: Colors.orange,
                            ),
                            _buildDecibelStat(
                              context: context,
                              icon: Icons.arrow_upward_rounded,
                              label: l10n.maxStat,
                              value:
                                  noiseMeterData.maxDecibels ==
                                      double.negativeInfinity
                                  ? '--'
                                  : noiseMeterData.maxDecibels.toStringAsFixed(
                                      1,
                                    ),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (noiseMeterData.decibelHistory.isNotEmpty)
                  RealtimeLineChart(
                    title: 'Real-time Noise Levels',
                    dataPoints: noiseMeterData.decibelHistory,
                    lineColor: noiseColor,
                    maxY: 120,
                  ),
                const SizedBox(height: 16),
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
                        NoiseGuideItem(
                          level: l10n.quiet,
                          range: '0-30 dB',
                          examples: l10n.whisperLibrary,
                          color: Colors.green,
                        ),
                        NoiseGuideItem(
                          level: l10n.moderate,
                          range: '30-60 dB',
                          examples: l10n.normalConversation,
                          color: Colors.lightGreen,
                        ),
                        NoiseGuideItem(
                          level: l10n.loud,
                          range: '60-85 dB',
                          examples: l10n.trafficOffice,
                          color: Colors.orange,
                        ),
                        NoiseGuideItem(
                          level: l10n.veryLoud,
                          range: '85-100 dB',
                          examples: l10n.motorcycleShouting,
                          color: Colors.deepOrange,
                        ),
                        NoiseGuideItem(
                          level: l10n.dangerous,
                          range: '100+ dB',
                          examples: l10n.rockConcertChainsaw,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
      ),
    );
  }
}
