/* Data models for the event timeline UI. */

enum EventSeverity { low, medium, high }

class EventItem {
  final DateTime timestamp;
  final double peakDecibels;
  final Duration duration;
  final String description;
  final EventSeverity severity;

  const EventItem({
    required this.timestamp,
    required this.peakDecibels,
    required this.duration,
    required this.description,
    required this.severity,
  });
}
