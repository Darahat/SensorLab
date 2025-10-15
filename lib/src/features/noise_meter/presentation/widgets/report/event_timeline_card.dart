import 'package:flutter/material.dart';
import '../../models/event_item.dart';

/// Event timeline card for report detail
class EventTimelineCard extends StatelessWidget {
  final List<EventItem> events;
  final String emptyMessage;

  const EventTimelineCard({
    super.key,
    required this.events,
    this.emptyMessage = 'No events recorded',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Timeline',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (events.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.event_available, size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        emptyMessage,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final event = events[index];
                  return _EventTimelineItem(event: event);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _EventTimelineItem extends StatelessWidget {
  final EventItem event;

  const _EventTimelineItem({required this.event});

  Color _getColor() {
    if (event.severity == EventSeverity.low) return Colors.blue;
    if (event.severity == EventSeverity.medium) return Colors.orange;
    return Colors.red;
  }

  IconData _getIcon() {
    if (event.severity == EventSeverity.low) return Icons.volume_down_rounded;
    if (event.severity == EventSeverity.medium) return Icons.volume_up_rounded;
    return Icons.warning_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor();
    final timeStr =
        '${event.timestamp.hour.toString().padLeft(2, '0')}:${event.timestamp.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_getIcon(), color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$timeStr • ${event.duration.inSeconds}s',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                event.peakDecibels.toStringAsFixed(1),
                style: theme.textTheme.titleSmall?.copyWith(
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
        ],
      ),
    );
  }
}
