import 'package:sensorlab/src/features/custom_lab/domain/entities/default_lab_presets.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';

/// Use case for initializing default lab presets on first run
class InitializePresetsUseCase {
  final LabRepository _repository;

  InitializePresetsUseCase(this._repository);

  /// Initialize all default lab presets if they don't exist
  Future<void> initializePresets() async {
    final existingLabs = await _repository.getAllLabs();
    final existingPresets = existingLabs.where((lab) => lab.isPreset).toList();

    // If presets already exist, don't re-add them
    if (existingPresets.isNotEmpty) {
      return;
    }

    // Create all default presets
    final presets = [
      DefaultLabPresets.environmentMonitor(),
      DefaultLabPresets.motionAnalysis(),
      DefaultLabPresets.indoorQuality(),
      DefaultLabPresets.outdoorExplorer(),
      DefaultLabPresets.vehicleDynamics(),
      DefaultLabPresets.healthTracker(),
    ];

    for (final preset in presets) {
      await _repository.createLab(preset);
    }
  }

  /// Check if presets have been initialized
  Future<bool> arePresetsInitialized() async {
    final existingLabs = await _repository.getAllLabs();
    final existingPresets = existingLabs.where((lab) => lab.isPreset).toList();
    return existingPresets.isNotEmpty;
  }

  /// Reset presets (delete and recreate all default presets)
  Future<void> resetPresets() async {
    // Delete all existing presets
    final existingLabs = await _repository.getAllLabs();
    final existingPresets = existingLabs.where((lab) => lab.isPreset).toList();

    for (final preset in existingPresets) {
      await _repository.deleteLab(preset.id);
    }

    // Recreate all presets
    await initializePresets();
  }
}
