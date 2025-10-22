import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';
import 'package:uuid/uuid.dart';

/// Use case for creating and editing labs
class ManageLabUseCase {
  final LabRepository _repository;
  final _uuid = const Uuid();

  ManageLabUseCase(this._repository);

  /// Create a new lab
  Future<Lab> createLab({
    required String name,
    required String description,
    required List<SensorType> sensors,
    String? iconName,
    Color? color,
    int recordingInterval = 1000,
  }) async {
    if (name.trim().isEmpty) {
      throw Exception('Lab name cannot be empty');
    }

    if (sensors.isEmpty) {
      throw Exception('Please select at least one sensor');
    }

    if (recordingInterval < 100 || recordingInterval > 10000) {
      throw Exception('Recording interval must be between 100ms and 10s');
    }

    final lab = Lab(
      id: _uuid.v4(),
      name: name.trim(),
      description: description.trim(),
      sensors: sensors,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isPreset: false,
      iconName: iconName,
      colorValue: color?.value,
      recordingInterval: recordingInterval,
    );

    await _repository.createLab(lab);
    return lab;
  }

  /// Update an existing lab
  Future<Lab> updateLab({
    required String id,
    String? name,
    String? description,
    List<SensorType>? sensors,
    String? iconName,
    Color? color,
    int? recordingInterval,
  }) async {
    final existingLab = await _repository.getLabById(id);
    if (existingLab == null) {
      throw Exception('Lab not found: $id');
    }

    if (existingLab.isPreset) {
      throw Exception('Cannot modify preset labs');
    }

    if (name != null && name.trim().isEmpty) {
      throw Exception('Lab name cannot be empty');
    }

    if (sensors != null && sensors.isEmpty) {
      throw Exception('Please select at least one sensor');
    }

    if (recordingInterval != null &&
        (recordingInterval < 100 || recordingInterval > 10000)) {
      throw Exception('Recording interval must be between 100ms and 10s');
    }

    final updatedLab = Lab(
      id: existingLab.id,
      name: name?.trim() ?? existingLab.name,
      description: description?.trim() ?? existingLab.description,
      sensors: sensors ?? existingLab.sensors,
      createdAt: existingLab.createdAt,
      updatedAt: DateTime.now(),
      isPreset: existingLab.isPreset,
      iconName: iconName ?? existingLab.iconName,
      colorValue: color?.value ?? existingLab.colorValue,
      recordingInterval: recordingInterval ?? existingLab.recordingInterval,
    );

    await _repository.updateLab(updatedLab);
    return updatedLab;
  }

  /// Delete a lab
  Future<void> deleteLab(String id) async {
    final lab = await _repository.getLabById(id);
    if (lab == null) {
      throw Exception('Lab not found: $id');
    }

    if (lab.isPreset) {
      throw Exception('Cannot delete preset labs');
    }

    await _repository.deleteLab(id);
  }

  /// Duplicate a lab (create a copy)
  Future<Lab> duplicateLab(String id) async {
    final originalLab = await _repository.getLabById(id);
    if (originalLab == null) {
      throw Exception('Lab not found: $id');
    }

    final duplicatedLab = Lab(
      id: _uuid.v4(),
      name: '${originalLab.name} (Copy)',
      description: originalLab.description,
      sensors: originalLab.sensors,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isPreset: false,
      iconName: originalLab.iconName,
      colorValue: originalLab.colorValue,
      recordingInterval: originalLab.recordingInterval,
    );

    await _repository.createLab(duplicatedLab);
    return duplicatedLab;
  }

  /// Get all labs (including presets)
  Future<List<Lab>> getAllLabs() async {
    return _repository.getAllLabs();
  }

  /// Get only custom labs (excluding presets)
  Future<List<Lab>> getCustomLabs() async {
    final allLabs = await _repository.getAllLabs();
    return allLabs.where((lab) => !lab.isPreset).toList();
  }

  /// Get only preset labs
  Future<List<Lab>> getPresetLabs() async {
    final allLabs = await _repository.getAllLabs();
    return allLabs.where((lab) => lab.isPreset).toList();
  }
}
