import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/application/services/monitoring_service.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';
import 'package:sensorlab/src/features/noise_meter/utils/monitoring_formatters.dart';

class RecordingInitialState extends StatelessWidget {
  final RecordingPreset preset;
  final CustomPresetConfig? customConfig;
  final VoidCallback onStartRecording;

  const RecordingInitialState({
    super.key,
    required this.preset,
    this.customConfig,
    required this.onStartRecording,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final totalDuration = MonitoringService.getPresetDuration(
      preset,
      customConfig: customConfig,
    );
    final isCustomPreset = MonitoringService.isCustomPreset(totalDuration);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildMicrophoneIcon(),
            const SizedBox(height: 24),
            _buildTitle(theme),
            const SizedBox(height: 8),
            _buildDescription(theme, l10n),
            if (!isCustomPreset)
              _buildDurationBadge(theme, totalDuration, l10n),
            const SizedBox(height: 24),
            _buildStartButton(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildMicrophoneIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green.withOpacity(0.1),
        border: Border.all(color: Colors.green, width: 3),
      ),
      child: const Icon(Iconsax.microphone, size: 60, color: Colors.green),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      'Ready to Record',
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDescription(ThemeData theme, AppLocalizations l10n) {
    return Text(
      MonitoringFormatters.getPresetDescription(l10n, preset, customConfig),
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }

  Widget _buildDurationBadge(
    ThemeData theme,
    Duration totalDuration,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Iconsax.clock, size: 18, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Duration: ${MonitoringFormatters.formatTotalDuration(totalDuration, l10n)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onStartRecording,
        icon: const Icon(Iconsax.play, size: 24),
        label: Text(
          l10n.recordingStart,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
