enum RecordingPreset { sleep, work, focus, custom }

class AcousticReport {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final RecordingPreset preset;
  final double averageDecibels;
  final double minDecibels;
  final double maxDecibels;
  final List<AcousticEvent> events;
  final Map<String, int> timeInLevels;
  final List<double> hourlyAverages;
  final String environmentQuality;
  final String recommendation;
  final int qualityScore;
  final int interruptionCount;

  const AcousticReport({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.preset,
    required this.averageDecibels,
    required this.minDecibels,
    required this.maxDecibels,
    required this.events,
    required this.timeInLevels,
    required this.hourlyAverages,
    required this.environmentQuality,
    required this.recommendation,
    required this.qualityScore,
    required this.interruptionCount,
  });
}

class AcousticEvent {
  final DateTime timestamp;
  final double peakDecibels;
  final Duration duration;
  final String eventType;

  const AcousticEvent({
    required this.timestamp,
    required this.peakDecibels,
    required this.duration,
    required this.eventType,
  });
}
