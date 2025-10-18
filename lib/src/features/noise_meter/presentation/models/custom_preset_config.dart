import 'package:flutter/material.dart';

/// Configuration for a custom acoustic analysis preset
class CustomPresetConfig {
  final String title;
  final String description;
  final Duration duration;
  final IconData icon;
  final Color color;

  const CustomPresetConfig({
    required this.title,
    required this.description,
    required this.duration,
    required this.icon,
    required this.color,
  });

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  CustomPresetConfig copyWith({
    String? title,
    String? description,
    Duration? duration,
    IconData? icon,
    Color? color,
  }) {
    return CustomPresetConfig(
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}
