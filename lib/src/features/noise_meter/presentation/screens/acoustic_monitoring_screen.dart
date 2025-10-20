import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_monitoring/acoustic_monitoring_content.dart';

class AcousticMonitoringScreen extends ConsumerWidget {
  final RecordingPreset preset;
  final CustomPresetConfig? customConfig;

  const AcousticMonitoringScreen({
    super.key,
    required this.preset,
    this.customConfig,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: AcousticMonitoringContent(
          preset: preset,
          customConfig: customConfig,
        ),
      ),
    );
  }
}
