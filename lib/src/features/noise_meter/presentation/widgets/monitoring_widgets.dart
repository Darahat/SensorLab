import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

/// Large decibel display with animated color
class DecibelDisplay extends StatelessWidget {
  final double decibels;
  final String noiseLevel;
  final String unit;

  const DecibelDisplay({
    super.key,
    required this.decibels,
    required this.noiseLevel,
    required this.unit,
  });

  Color _getColor() {
    if (decibels < 30) return Colors.blue;
    if (decibels < 50) return Colors.green;
    if (decibels < 70) return Colors.orange;
    if (decibels < 85) return Colors.deepOrange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
        ),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.monitoringCurrentLevel,
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  decibels.toStringAsFixed(1),
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 8),
                  child: Text(
                    unit,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              noiseLevel,
              style: theme.textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Progress indicator with time remaining
class SessionProgressIndicator extends StatelessWidget {
  final double progress;
  final String remainingTime;
  final String label;
  final Color color;

  const SessionProgressIndicator({
    super.key,
    required this.progress,
    required this.remainingTime,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  remainingTime,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(1)}% complete',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Noise event list item
class NoiseEventItem extends StatelessWidget {
  final DateTime timestamp;
  final double peakDecibels;
  final Duration duration;
  final String eventType;

  const NoiseEventItem({
    super.key,
    required this.timestamp,
    required this.peakDecibels,
    required this.duration,
    required this.eventType,
  });

  Color _getColor() {
    if (peakDecibels < 65) return Colors.blue;
    if (peakDecibels < 75) return Colors.orange;
    return Colors.red;
  }

  IconData _getIcon() {
    if (peakDecibels < 65) return Icons.volume_down_rounded;
    if (peakDecibels < 75) return Icons.volume_up_rounded;
    return Icons.warning_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor();
    final timeStr =
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(_getIcon(), color: color, size: 24),
      ),
      title: Text(
        eventType,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '$timeStr • ${duration.inSeconds}s',
        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            peakDecibels.toStringAsFixed(1),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            'dB',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
