import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';

class ReportFormatters {
  static IconData getPresetIcon(RecordingPreset preset) {
    switch (preset) {
      case RecordingPreset.sleep:
        return Iconsax.moon;
      case RecordingPreset.work:
        return Iconsax.briefcase;
      case RecordingPreset.focus:
        return Iconsax.lamp_charge;
      case RecordingPreset.custom:
        return Iconsax.setting_2;
    }
  }

  static String getPresetName(RecordingPreset preset) {
    switch (preset) {
      case RecordingPreset.sleep:
        return 'Sleep';
      case RecordingPreset.work:
        return 'Work';
      case RecordingPreset.focus:
        return 'Focus';
      case RecordingPreset.custom:
        return 'Custom';
    }
  }

  static String formatListDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDate = DateTime(date.year, date.month, date.day);

    if (sessionDate == today) {
      return 'Today at ${TimeOfDay.fromDateTime(date).format(context)}';
    } else if (sessionDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday at ${TimeOfDay.fromDateTime(date).format(context)}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
