import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_management_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

class SaveLabService {
  final Ref ref;

  SaveLabService(this.ref);

  Future<Lab?> saveLab({
    required String name,
    required String description,
    required Set<SensorType> selectedSensors,
    required Color selectedColor,
    required String interval,
    required String? labId,
    required bool isEditing,
  }) async {
    // Convert seconds to milliseconds
    final intervalInSeconds = double.parse(interval);
    final recordingInterval = (intervalInSeconds * 1000).round();

    final labManagementNotifier = ref.read(labManagementProvider.notifier);

    if (isEditing && labId != null) {
      return await labManagementNotifier.updateLab(
        id: labId,
        name: name,
        description: description,
        sensors: selectedSensors.toList(),
        color: selectedColor,
        recordingInterval: recordingInterval,
      );
    } else {
      return await labManagementNotifier.createLab(
        name: name,
        description: description,
        sensors: selectedSensors.toList(),
        color: selectedColor,
        recordingInterval: recordingInterval,
      );
    }
  }

  Future<bool> deleteLab(String labId) async {
    final labManagementNotifier = ref.read(labManagementProvider.notifier);
    return await labManagementNotifier.deleteLab(labId);
  }
}

final saveLabServiceProvider = Provider<SaveLabService>((ref) {
  return SaveLabService(ref);
});
