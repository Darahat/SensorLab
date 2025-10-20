import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';

class MonitoringService {
  static Duration getPresetDuration(
    RecordingPreset preset, {
    CustomPresetConfig? customConfig,
  }) {
    if (preset == RecordingPreset.custom && customConfig != null) {
      return customConfig.duration;
    }

    switch (preset) {
      case RecordingPreset.sleep:
        return const Duration(hours: 8);
      case RecordingPreset.work:
        return const Duration(hours: 1);
      case RecordingPreset.focus:
        return const Duration(minutes: 30);
      case RecordingPreset.custom:
        return Duration.zero;
    }
  }

  static bool isCustomPreset(Duration duration) {
    return duration == Duration.zero;
  }

  static double calculateProgress(Duration elapsed, Duration total) {
    if (total.inSeconds == 0) return 0.0;

    double progress = elapsed.inSeconds / total.inSeconds;
    if (progress > 1.0) progress = 1.0;
    if (progress < 0.0) progress = 0.0;
    return progress;
  }
}
