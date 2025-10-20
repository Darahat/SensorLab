import 'package:hive/hive.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';

part 'acoustic_report_hive.g.dart';

/// Data Transfer Object (DTO) for AcousticEvent, for Hive persistence.
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

  /// Mapper from a domain [AcousticEvent] entity.
  factory AcousticEventHive.fromEntity(AcousticEvent entity) {
    return AcousticEventHive(
      timestamp: entity.timestamp,
      peakDecibels: entity.peakDecibels,
      durationSeconds: entity.duration.inSeconds,
      eventType: entity.eventType,
    );
  }

  /// Mapper to a domain [AcousticEvent] entity.
  AcousticEvent toEntity() {
    return AcousticEvent(
      timestamp: timestamp,
      peakDecibels: peakDecibels,
      duration: Duration(seconds: durationSeconds),
      eventType: eventType,
    );
  }
}

/// Data Transfer Object (DTO) for AcousticReport, for Hive persistence.
@HiveType(typeId: 9)
class AcousticReportHive {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime startTime;
  @HiveField(2)
  final DateTime endTime;
  @HiveField(3)
  final int durationSeconds;
  @HiveField(4)
  final int presetIndex;
  @HiveField(5)
  final double averageDecibels;
  @HiveField(6)
  final double minDecibels;
  @HiveField(7)
  final double maxDecibels;
  @HiveField(8)
  final List<AcousticEventHive> events;
  @HiveField(9)
  final Map<String, int> timeInLevels;
  @HiveField(10)
  final List<double> hourlyAverages;
  @HiveField(11)
  final String environmentQuality;
  @HiveField(12)
  final String recommendation;
  @HiveField(13)
  final int? qualityScore;
  @HiveField(14)
  final int? interruptionCount;

  AcousticReportHive({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationSeconds,
    required this.presetIndex,
    required this.averageDecibels,
    required this.minDecibels,
    required this.maxDecibels,
    required this.events,
    required this.timeInLevels,
    required this.hourlyAverages,
    required this.environmentQuality,
    required this.recommendation,
    this.qualityScore,
    this.interruptionCount,
  });

  /// Mapper from a domain [AcousticReport] entity.
  factory AcousticReportHive.fromEntity(AcousticReport entity) {
    return AcousticReportHive(
      id: entity.id,
      startTime: entity.startTime,
      endTime: entity.endTime,
      durationSeconds: entity.duration.inSeconds,
      presetIndex: entity.preset.index,
      averageDecibels: entity.averageDecibels,
      minDecibels: entity.minDecibels,
      maxDecibels: entity.maxDecibels,
      events: entity.events
          .map((e) => AcousticEventHive.fromEntity(e))
          .toList(),
      timeInLevels: entity.timeInLevels,
      hourlyAverages: entity.hourlyAverages,
      environmentQuality: entity.environmentQuality,
      recommendation: entity.recommendation,
      qualityScore: entity.qualityScore,
      interruptionCount: entity.interruptionCount,
    );
  }

  /// Mapper to a domain [AcousticReport] entity.
  AcousticReport toEntity() {
    return AcousticReport(
      id: id,
      startTime: startTime,
      endTime: endTime,
      duration: Duration(seconds: durationSeconds),
      preset: RecordingPreset.values[presetIndex],
      averageDecibels: averageDecibels,
      minDecibels: minDecibels,
      maxDecibels: maxDecibels,
      events: events.map((e) => e.toEntity()).toList(),
      timeInLevels: timeInLevels,
      hourlyAverages: hourlyAverages,
      environmentQuality: environmentQuality,
      recommendation: recommendation,
      qualityScore: qualityScore ?? 0,
      interruptionCount: interruptionCount ?? 0,
    );
  }
}
