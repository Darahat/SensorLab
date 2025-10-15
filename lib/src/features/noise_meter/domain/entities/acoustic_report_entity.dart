
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/enhanced_noise_data.dart';

part 'acoustic_report_entity.freezed.dart';

@freezed
class AcousticEvent with _$AcousticEvent {
  const factory AcousticEvent({
    required DateTime timestamp,
    required double peakDecibels,
    required Duration duration,
    required String eventType,
  }) = _AcousticEvent;
}

@freezed
class AcousticReport with _$AcousticReport {
  const AcousticReport._(); // Private constructor for custom getters

  const factory AcousticReport({
    required String id,
    required DateTime startTime,
    required DateTime endTime,
    required Duration duration,
    required RecordingPreset preset,
    required double averageDecibels,
    required double minDecibels,
    required double maxDecibels,
    required List<AcousticEvent> events,
    required Map<String, int> timeInLevels,
    required List<double> hourlyAverages,
    required String environmentQuality,
    required String recommendation,
  }) = _AcousticReport;

  // --- Business Logic is here, in the pure domain entity ---

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
}
