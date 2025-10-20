
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';

@immutable
class CustomPresetState {
  const CustomPresetState({
    this.title = '',
    this.description = '',
    this.duration = const Duration(minutes: 30),
    this.selectedIcon = Iconsax.microphone,
    this.selectedColor = Colors.purple,
  });

  final String title;
  final String description;
  final Duration duration;
  final IconData selectedIcon;
  final Color selectedColor;

  CustomPresetState copyWith({
    String? title,
    String? description,
    Duration? duration,
    IconData? selectedIcon,
    Color? selectedColor,
  }) {
    return CustomPresetState(
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}

class CustomPresetNotifier extends StateNotifier<CustomPresetState> {
  CustomPresetNotifier() : super(const CustomPresetState());

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void updateDuration(int hours, int minutes) {
    state = state.copyWith(duration: Duration(hours: hours, minutes: minutes));
  }

  void selectIcon(IconData icon) {
    state = state.copyWith(selectedIcon: icon);
  }

  void selectColor(Color color) {
    state = state.copyWith(selectedColor: color);
  }

  CustomPresetConfig? createPreset() {
    if (state.title.trim().isEmpty ||
        state.description.trim().isEmpty ||
        state.duration.inMinutes == 0) {
      return null;
    }
    return CustomPresetConfig(
      title: state.title,
      description: state.description,
      duration: state.duration,
      icon: state.selectedIcon,
      color: state.selectedColor,
    );
  }
}

final customPresetProvider =
    StateNotifierProvider<CustomPresetNotifier, CustomPresetState>(
  (ref) => CustomPresetNotifier(),
);
