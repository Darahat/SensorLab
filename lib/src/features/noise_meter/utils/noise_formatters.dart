import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/utils/context_extensions.dart';

class NoiseFormatters {
  static String formatDuration(Duration duration) {
    return duration.toMinutesSeconds();
  }

  static String getNoiseLevelDescription(NoiseLevel level) {
    switch (level) {
      case NoiseLevel.quiet:
        return 'Quiet (0-30 dB)';
      case NoiseLevel.moderate:
        return 'Moderate (30-60 dB)';
      case NoiseLevel.loud:
        return 'Loud (60-85 dB)';
      case NoiseLevel.veryLoud:
        return 'Very Loud (85-100 dB)';
      case NoiseLevel.dangerous:
        return 'Dangerous (100+ dB)';
    }
  }

  static Color getNoiseLevelColor(NoiseLevel level) {
    switch (level) {
      case NoiseLevel.quiet:
        return Colors.green;
      case NoiseLevel.moderate:
        return Colors.lightGreen;
      case NoiseLevel.loud:
        return Colors.orange;
      case NoiseLevel.veryLoud:
        return Colors.deepOrange;
      case NoiseLevel.dangerous:
        return Colors.red;
    }
  }

  static IconData getNoiseLevelIcon(NoiseLevel level) {
    switch (level) {
      case NoiseLevel.quiet:
        return Icons.volume_mute;
      case NoiseLevel.moderate:
        return Icons.volume_down;
      case NoiseLevel.loud:
        return Icons.volume_up;
      case NoiseLevel.veryLoud:
        return Icons.volume_up_rounded;
      case NoiseLevel.dangerous:
        return Icons.warning;
    }
  }

  static String formatDecibelValue(double decibels) {
    return decibels.toDecibelString();
  }
}
