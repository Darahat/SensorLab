import 'package:flutter/material.dart';

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
