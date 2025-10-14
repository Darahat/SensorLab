import 'package:hive/hive.dart';

import 'enhanced_noise_data.dart';

part 'acoustic_report.g.dart';

/// Hive adapter type IDs:
/// 0-7 - Already used by existing models
/// 8 - AcousticEventHive
/// 9 - AcousticReportHive

/// Hive-friendly version of AcousticEvent
@HiveType(typeId: 8)
class AcousticEventHive {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final double peakDecibels;

  @HiveField(2)
  final int durationSeconds;

  @HiveField(3)
  final String eventType;

  AcousticEventHive({
    required this.timestamp,
    required this.peakDecibels,
    required this.durationSeconds,
    required this.eventType,
  });

  factory AcousticEventHive.fromEvent(AcousticEvent event) {
    return AcousticEventHive(
      timestamp: event.timestamp,
      peakDecibels: event.peakDecibels,
      durationSeconds: event.duration.inSeconds,
      eventType: event.eventType,
    );
  }

  AcousticEvent toEvent() {
    return AcousticEvent(
      timestamp: timestamp,
      peakDecibels: peakDecibels,
      duration: Duration(seconds: durationSeconds),
      eventType: eventType,
    );
  }

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'peakDecibels': peakDecibels,
    'durationSeconds': durationSeconds,
    'eventType': eventType,
  };
}

/// Acoustic session report stored in Hive
@HiveType(typeId: 9)
class AcousticReportHive {
  @HiveField(0)
  final String id; // Unique identifier for the report

  @HiveField(1)
  final DateTime startTime;

  @HiveField(2)
  final DateTime endTime;

  @HiveField(3)
  final int durationSeconds;

  @HiveField(4)
  final int presetIndex; // Store preset as int for Hive

  @HiveField(5)
  final double averageDecibels;

  @HiveField(6)
  final double minDecibels;

  @HiveField(7)
  final double maxDecibels;

  @HiveField(8)
  final List<AcousticEventHive> events;

  @HiveField(9)
  final Map<String, int> timeInLevels; // Time spent in each noise level

  @HiveField(10)
  final List<double> hourlyAverages;

  @HiveField(11)
  final String environmentQuality; // 'excellent', 'good', 'fair', 'poor'

  @HiveField(12)
  final String recommendation;

  AcousticReportHive({
    String? id,
    required this.startTime,
    required this.endTime,
    required Duration duration,
    required RecordingPreset preset,
    required this.averageDecibels,
    required this.minDecibels,
    required this.maxDecibels,
    required this.events,
    required this.timeInLevels,
    required this.hourlyAverages,
    required this.environmentQuality,
    required this.recommendation,
  }) : id = id ?? '${startTime.millisecondsSinceEpoch}',
       durationSeconds = duration.inSeconds,
       presetIndex = preset.index;

  Duration get duration => Duration(seconds: durationSeconds);
  RecordingPreset get preset => RecordingPreset.values[presetIndex];

  /// Get formatted duration
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDate = DateTime(
      startTime.year,
      startTime.month,
      startTime.day,
    );

    if (sessionDate == today) {
      return 'Today ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    } else if (sessionDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${startTime.day}/${startTime.month}/${startTime.year}';
    }
  }

  /// Get interruption count (events over threshold)
  int get interruptionCount => events.where((e) => e.peakDecibels > 65).length;

  /// Get quality score (0-100)
  int get qualityScore {
    int score = 100;

    // Penalize high average
    if (averageDecibels > 70) {
      score -= 40;
    } else if (averageDecibels > 60) {
      score -= 20;
    } else if (averageDecibels > 50) {
      score -= 10;
    }

    // Penalize interruptions
    score -= interruptionCount * 5;

    // Penalize max peaks
    if (maxDecibels > 85) {
      score -= 15;
    } else if (maxDecibels > 75) {
      score -= 10;
    }

    return score.clamp(0, 100);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'duration': durationSeconds,
    'preset': preset.name,
    'averageDecibels': averageDecibels,
    'minDecibels': minDecibels,
    'maxDecibels': maxDecibels,
    'events': events.map((e) => e.toJson()).toList(),
    'timeInLevels': timeInLevels,
    'hourlyAverages': hourlyAverages,
    'environmentQuality': environmentQuality,
    'recommendation': recommendation,
    'qualityScore': qualityScore,
    'interruptionCount': interruptionCount,
  };
}
