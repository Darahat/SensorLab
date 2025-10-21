import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/noise_meter/application/services/custom_preset_service.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/acoustic_monitoring_screen.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/custom_preset_creation_screen.dart';

class PresetSelectionUtils extends ChangeNotifier {
  Map<String, CustomPresetConfig> customPresets = {};
  bool isLoading = true;

  Future<void> loadCustomPresets(BuildContext context) async {
    setState(() => isLoading = true);
    try {
      final presets = await CustomPresetService.getAllPresetsWithIds();
      if (!context.mounted) {
        return;
      }
      if (_isContextValid(context)) {
        setState(() {
          customPresets = presets;
          isLoading = false;
        });
      }
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      if (_isContextValid(context)) {
        setState(() => isLoading = false);
        _showErrorSnackbar(context, 'Failed to load presets: $e');
      }
    }
  }

  Future<void> createCustomPreset(BuildContext context) async {
    final customPreset = await Navigator.push<CustomPresetConfig>(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomPresetCreationScreen(),
      ),
    );

    if (!context.mounted) {
      return;
    }

    if (customPreset != null && _isContextValid(context)) {
      try {
        final id = await CustomPresetService.savePreset(customPreset);
        if (!context.mounted) {
          return;
        }
        setState(() {
          customPresets[id] = customPreset;
        });
        _showSuccessSnackbar(context, 'Created "${customPreset.title}"!');
      } catch (e) {
        if (!context.mounted) {
          return;
        }
        _showErrorSnackbar(context, 'Failed to save preset: $e');
      }
    }
  }

  void startRecording(
    BuildContext context,
    RecordingPreset preset, {
    CustomPresetConfig? customConfig,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcousticMonitoringScreen(
          preset: preset,
          customConfig: customConfig,
        ),
      ),
    );
  }

  Future<void> deleteCustomPreset(String id) async {
    final preset = customPresets[id];
    if (preset == null) {
      return;
    }

    // Optimistic deletion
    setState(() {
      customPresets.remove(id);
    });

    try {
      await CustomPresetService.deletePreset(id);
    } catch (e) {
      // Restore on error
      setState(() {
        customPresets[id] = preset;
      });
      rethrow;
    }
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  bool _isContextValid(BuildContext context) {
    return context.mounted;
  }

  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
