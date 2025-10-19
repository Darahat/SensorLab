import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart';

class GetFilterChip extends StatelessWidget {
  final RecordingPreset preset;
  final VoidCallback onClear;

  const GetFilterChip({super.key, required this.preset, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(ReportFormatters.getPresetIcon(preset), size: 18),
      label: Text(ReportFormatters.getPresetName(preset)),
      onDeleted: onClear,
      deleteIcon: const Icon(Iconsax.close_circle, size: 18),
    );
  }
}
