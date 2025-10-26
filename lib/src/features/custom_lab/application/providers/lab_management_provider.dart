import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_repository_provider.dart';
import 'package:sensorlab/src/features/custom_lab/application/use_cases/manage_lab_use_case.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

/// Provider for ManageLabUseCase
final manageLabUseCaseProvider = Provider<ManageLabUseCase>((ref) {
  final repository = ref.watch(labRepositoryProvider);
  return ManageLabUseCase(repository);
});

/// State for lab management operations
@immutable
class LabManagementState {
  final bool isLoading;
  final String? errorMessage;
  final Lab? selectedLab;

  const LabManagementState({
    this.isLoading = false,
    this.errorMessage,
    this.selectedLab,
  });

  LabManagementState copyWith({
    bool? isLoading,
    String? errorMessage,
    Lab? selectedLab,
  }) {
    return LabManagementState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedLab: selectedLab ?? this.selectedLab,
    );
  }
}

/// StateNotifier for lab management operations
class LabManagementNotifier extends StateNotifier<LabManagementState> {
  final ManageLabUseCase _useCase;
  final Ref _ref;

  LabManagementNotifier(this._useCase, this._ref)
    : super(const LabManagementState());

  /// Create a new lab
  Future<Lab?> createLab({
    required String name,
    required String description,
    required List<SensorType> sensors,
    String? iconName,
    Color? color,
    int recordingInterval = 1000,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final lab = await _useCase.createLab(
        name: name,
        description: description,
        sensors: sensors,
        iconName: iconName,
        color: color,
        recordingInterval: recordingInterval,
      );

      state = state.copyWith(isLoading: false, selectedLab: lab);

      // Refresh the lab list
      _ref.invalidate(allLabsProvider);

      return lab;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return null;
    }
  }

  /// Update an existing lab
  Future<Lab?> updateLab({
    required String id,
    String? name,
    String? description,
    List<SensorType>? sensors,
    String? iconName,
    Color? color,
    int? recordingInterval,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final lab = await _useCase.updateLab(
        id: id,
        name: name,
        description: description,
        sensors: sensors,
        iconName: iconName,
        color: color,
        recordingInterval: recordingInterval,
      );

      state = state.copyWith(isLoading: false, selectedLab: lab);

      // Refresh the lab list
      _ref.invalidate(allLabsProvider);

      return lab;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return null;
    }
  }

  /// Delete a lab
  Future<bool> deleteLab(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _useCase.deleteLab(id);

      state = state.copyWith(
        isLoading: false,
        selectedLab: state.selectedLab?.id == id ? null : state.selectedLab,
      );

      // Refresh the lab list
      _ref.invalidate(allLabsProvider);

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Duplicate a lab
  Future<Lab?> duplicateLab(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final lab = await _useCase.duplicateLab(id);

      state = state.copyWith(isLoading: false, selectedLab: lab);

      // Refresh the lab list
      _ref.invalidate(allLabsProvider);

      return lab;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return null;
    }
  }

  /// Select a lab
  void selectLab(Lab lab) {
    state = state.copyWith(selectedLab: lab);
  }

  /// Clear selection
  void clearSelection() {
    state = state.copyWith(selectedLab: null);
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for lab management state
final labManagementProvider =
    StateNotifierProvider<LabManagementNotifier, LabManagementState>((ref) {
      final useCase = ref.watch(manageLabUseCaseProvider);
      return LabManagementNotifier(useCase, ref);
    });

/// Provider for getting all labs
final allLabsProvider = FutureProvider<List<Lab>>((ref) async {
  final useCase = ref.watch(manageLabUseCaseProvider);
  return useCase.getAllLabs();
});

/// Provider for getting custom labs only
final customLabsProvider = FutureProvider<List<Lab>>((ref) async {
  final useCase = ref.watch(manageLabUseCaseProvider);
  return useCase.getCustomLabs();
});

/// Provider for getting preset labs only
final presetLabsProvider = FutureProvider<List<Lab>>((ref) async {
  final useCase = ref.watch(manageLabUseCaseProvider);
  return useCase.getPresetLabs();
});
