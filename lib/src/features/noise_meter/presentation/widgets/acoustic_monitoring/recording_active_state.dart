import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/enhanced_noise_meter_provider.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart'
    show
        StatusCard,
        DecibelDisplay,
        SessionProgressIndicator,
        NoiseEventItem,
        EmptyStateWidget;
import 'package:sensorlab/src/features/noise_meter/services/monitoring_service.dart';
import 'package:sensorlab/src/features/noise_meter/utils/utils_index.dart';
import 'package:sensorlab/src/shared/widgets/common_cards.dart' show StatCard;
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart'
    show RealtimeLineChart;
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class RecordingActiveState extends StatelessWidget {
  final RecordingPreset preset;
  final CustomPresetConfig? customConfig;
  final EnhancedNoiseMeterData state;
  final EnhancedNoiseMeterNotifier notifier;

  const RecordingActiveState({
    super.key,
    required this.preset,
    this.customConfig,
    required this.state,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalDuration = MonitoringService.getPresetDuration(
      preset,
      customConfig: customConfig,
    );
    final isCustomPreset = MonitoringService.isCustomPreset(totalDuration);
    final progress = MonitoringService.calculateProgress(
      state.sessionDuration,
      totalDuration,
    );
    final remainingTime = MonitoringFormatters.formatRemainingTime(
      state.sessionDuration,
      totalDuration,
      l10n,
    );

    return Column(
      children: [
        StatusCard(
          isActive: state.isRecording,
          title: state.isRecording
              ? l10n.monitoringActive
              : l10n.monitoringStopped,
          subtitle: state.isRecording
              ? l10n.monitoringEnvironment
              : l10n.recordingCompleted,
        ),
        const SizedBox(height: 24),
        DecibelDisplay(
          decibels: state.currentDecibels,
          noiseLevel: MonitoringFormatters.getNoiseLevel(state.currentDecibels),
          unit: l10n.decibelUnit,
        ),
        const SizedBox(height: 24),
        if (!isCustomPreset)
          SessionProgressIndicator(
            progress: progress,
            remainingTime: remainingTime,
            label: l10n.monitoringProgress,
            color: MonitoringFormatters.getDecibelColor(state.averageDecibels),
          ),
        const SizedBox(height: 24),
        RealtimeLineChart(
          dataPoints: state.decibelHistory,
          title: l10n.monitoringLiveChart,
          lineColor: MonitoringFormatters.getDecibelColor(
            state.averageDecibels,
          ),
          maxY: 100,
          horizontalInterval: 20,
        ),
        const SizedBox(height: 24),
        _buildStatistics(l10n, state),
        const SizedBox(height: 24),
        _buildEventsList(context, state, l10n),
      ],
    );
  }

  Widget _buildStatistics(AppLocalizations l10n, EnhancedNoiseMeterData state) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Iconsax.chart,
            label: l10n.reportAverage,
            value:
                '${state.averageDecibels.toStringAsFixed(1)} ${l10n.decibelUnit}',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Iconsax.warning_2,
            label: l10n.reportEvents,
            value: '${state.events.length}',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildEventsList(
    BuildContext context,
    EnhancedNoiseMeterData state,
    AppLocalizations l10n,
  ) {
    if (state.events.isEmpty) {
      return EmptyStateWidget(
        icon: Iconsax.tick_circle,
        title: 'No Interruptions',
        message: 'Your environment has been quiet',
      );
    }

    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Noise Events (${state.events.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.events.length,
              separatorBuilder: (context, index) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final event = state.events[index];
                return NoiseEventItem(
                  timestamp: event.timestamp,
                  peakDecibels: event.peakDecibels,
                  duration: event.duration,
                  eventType: event.eventType,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
