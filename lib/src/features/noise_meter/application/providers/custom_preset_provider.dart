import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/noise_meter/application/notifiers/custom_preset_notifier.dart';

final customPresetProvider =
    StateNotifierProvider<CustomPresetNotifier, CustomPresetState>((ref) {
      return CustomPresetNotifier();
    });
