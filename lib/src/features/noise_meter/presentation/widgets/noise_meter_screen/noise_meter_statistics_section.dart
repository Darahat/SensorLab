import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/utils/utils_index.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart'; // ← Add this

class NoiseMeterStatisticsSection extends StatelessWidget {
  final EnhancedNoiseMeterData data;
  final AppLocalizations l10n;

  const NoiseMeterStatisticsSection({
    super.key,
    required this.data,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
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
            _buildBasicStats(),
            const SizedBox(height: 20),
            _buildDecibelStats(theme),
            const SizedBox(height: 16),
            Center(child: _buildNoiseLevelBadge()),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatBadge(
            icon: Icons.timer_outlined,
            value: data.sessionDuration.toMinutesSeconds(),
            label: l10n.duration,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatBadge(
            icon: Icons.analytics_outlined,
            value: '${data.totalReadings}',
            label: l10n.readings,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDecibelStats(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Decibel Statistics',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 16),
        InfoRow(
          // ← Using shared InfoRow
          label: 'Minimum',
          value: data.minDecibels == double.infinity
              ? '-- dB'
              : '${data.minDecibels.toStringAsFixed(1)} dB',
          icon: Icons.arrow_downward,
          valueColor: Colors.green,
        ),
        InfoRow(
          // ← Using shared InfoRow
          label: 'Average',
          value: '${data.averageDecibels.toStringAsFixed(1)} dB',
          icon: Icons.show_chart,
          valueColor: Colors.orange,
        ),
        InfoRow(
          // ← Using shared InfoRow
          label: 'Maximum',
          value: data.maxDecibels == double.negativeInfinity
              ? '-- dB'
              : '${data.maxDecibels.toStringAsFixed(1)} dB',
          icon: Icons.arrow_upward,
          valueColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildNoiseLevelBadge() {
    final noiseLevel = data.noiseLevel;
    final color = _getNoiseLevelColor(noiseLevel);
    final description = _getNoiseLevelDescription(noiseLevel);

    return BadgeWidget(
      // ← Using shared BadgeWidget
      label: description,
      color: color,
      icon: _getNoiseLevelIcon(noiseLevel),
    );
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

  String _getNoiseLevelDescription(NoiseLevel level) {
    switch (level) {
      case NoiseLevel.quiet:
        return 'Quiet Environment';
      case NoiseLevel.moderate:
        return 'Moderate Noise';
      case NoiseLevel.loud:
        return 'Loud Environment';
      case NoiseLevel.veryLoud:
        return 'Very Loud - Caution';
      case NoiseLevel.dangerous:
        return 'Dangerous Levels';
    }
  }

  IconData _getNoiseLevelIcon(NoiseLevel level) {
    switch (level) {
      case NoiseLevel.quiet:
        return Icons.volume_mute;
      case NoiseLevel.moderate:
        return Icons.volume_down;
      case NoiseLevel.loud:
        return Icons.volume_up;
      case NoiseLevel.veryLoud:
        return Icons.volume_up;
      case NoiseLevel.dangerous:
        return Icons.warning;
    }
  }
}
