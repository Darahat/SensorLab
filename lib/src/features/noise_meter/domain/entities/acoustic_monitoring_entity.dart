import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';

class MonitoringSession {
  final RecordingPreset preset;
  final CustomPresetConfig? customConfig;
  final Duration totalDuration;
  final bool isCustomPreset;

  const MonitoringSession({
    required this.preset,
    this.customConfig,
    required this.totalDuration,
    required this.isCustomPreset,
  });
}
