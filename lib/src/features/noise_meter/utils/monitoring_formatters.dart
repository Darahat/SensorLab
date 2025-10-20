import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';

class MonitoringFormatters {
  static String getPresetTitle(
    AppLocalizations l10n,
    RecordingPreset preset,
    CustomPresetConfig? customConfig,
  ) {
    if (preset == RecordingPreset.custom && customConfig != null) {
      return customConfig.title;
    }

    switch (preset) {
      case RecordingPreset.sleep:
        return l10n.presetSleepAnalysis;
      case RecordingPreset.work:
        return l10n.presetWorkEnvironment;
      case RecordingPreset.focus:
        return l10n.presetFocusSession;
      case RecordingPreset.custom:
        return l10n.presetCustomRecording;
    }
  }

  static String getPresetDescription(
    AppLocalizations l10n,
    RecordingPreset preset,
    CustomPresetConfig? customConfig,
  ) {
    if (preset == RecordingPreset.custom && customConfig != null) {
      return customConfig.description;
    }

    switch (preset) {
      case RecordingPreset.sleep:
        return l10n.presetSleepDescription;
      case RecordingPreset.work:
        return l10n.presetWorkDescription;
      case RecordingPreset.focus:
        return l10n.presetFocusDescription;
      case RecordingPreset.custom:
        return 'Custom recording session';
    }
  }

  static String formatTotalDuration(Duration duration, AppLocalizations l10n) {
    if (duration == Duration.zero) {
      return l10n.presetCustom;
    }

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${l10n.durationHours(hours)} ${l10n.durationMinutes(minutes)}';
    } else if (hours > 0) {
      return l10n.durationHours(hours);
    } else {
      return l10n.durationMinutes(minutes);
    }
  }

  static String formatRemainingTime(
    Duration elapsed,
    Duration total,
    AppLocalizations l10n,
  ) {
    if (total == Duration.zero) {
      return l10n.presetCustomRecording;
    }

    final remaining = total - elapsed;
    if (remaining.isNegative) {
      return l10n.recordingCompleted;
    }

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    final seconds = remaining.inSeconds.remainder(60);

    if (hours > 0) {
      return '${l10n.durationHours(hours)} ${l10n.durationMinutes(minutes)}';
    } else if (minutes > 0) {
      return '${l10n.durationMinutes(minutes)} ${l10n.durationSeconds(seconds)}';
    } else {
      return l10n.durationSeconds(seconds);
    }
  }

  static Color getDecibelColor(double decibel) {
    if (decibel < 40) {
      return Colors.green;
    }
    if (decibel < 55) {
      return Colors.lightGreen;
    }
    if (decibel < 65) {
      return Colors.orange;
    }
    if (decibel < 75) {
      return Colors.deepOrange;
    }
    return Colors.red;
  }

  static String getNoiseLevel(double decibel) {
    if (decibel < 40) {
      return 'Very Quiet';
    }
    if (decibel < 55) {
      return 'Quiet';
    }
    if (decibel < 65) {
      return 'Moderate';
    }
    if (decibel < 75) {
      return 'Loud';
    }
    return 'Very Loud';
  }
}
