import 'package:flutter/material.dart';

import '../domain/entities/acoustic_report_entity.dart';

class ReportFormatters {
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  static String formatDecibelValue(double decibel) {
    if (decibel.isNaN ||
        decibel.isInfinite ||
        decibel == double.negativeInfinity) {
      return '--';
    }
    return '${decibel.toStringAsFixed(1)} dB';
  }

  static String formatEventTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static Color getQualityColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.lightGreen;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  static String getQualityLabel(int score) {
    if (score >= 80) return 'EXCELLENT';
    if (score >= 60) return 'GOOD';
    if (score >= 40) return 'FAIR';
    return 'POOR';
  }

  static Color getDecibelColor(double decibel) {
    if (decibel < 40) return Colors.green;
    if (decibel < 55) return Colors.lightGreen;
    if (decibel < 65) return Colors.orange;
    if (decibel < 75) return Colors.deepOrange;
    return Colors.red;
  }

  static String getPresetName(RecordingPreset preset) {
    switch (preset) {
      case RecordingPreset.sleep:
        return 'Sleep Analysis';
      case RecordingPreset.work:
        return 'Work Environment';
      case RecordingPreset.focus:
        return 'Focus Session';
      case RecordingPreset.custom:
        return 'Custom';
    }
  }
}
