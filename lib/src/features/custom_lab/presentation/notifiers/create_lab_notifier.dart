import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

/// State for create/edit lab form
class CreateLabState {
  final String name;
  final String description;
  final String interval;
  final Set<SensorType> selectedSensors;
  final Color selectedColor;
  final bool isLoading;
  final String? errorMessage;

  const CreateLabState({
    this.name = '',
    this.description = '',
    this.interval = '1',
    this.selectedSensors = const {},
    this.selectedColor = Colors.blue,
    this.isLoading = false,
    this.errorMessage,
  });

  CreateLabState copyWith({
    String? name,
    String? description,
    String? interval,
    Set<SensorType>? selectedSensors,
    Color? selectedColor,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CreateLabState(
      name: name ?? this.name,
      description: description ?? this.description,
      interval: interval ?? this.interval,
      selectedSensors: selectedSensors ?? this.selectedSensors,
      selectedColor: selectedColor ?? this.selectedColor,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier for managing create/edit lab state and business logic
class CreateLabNotifier extends AutoDisposeNotifier<CreateLabState> {
  @override
  CreateLabState build() {
    return const CreateLabState();
  }

  /// Initialize state when editing a lab
  void initializeForEdit(Lab lab) {
    state = CreateLabState(
      name: lab.name,
      description: lab.description,
      interval: (lab.recordingInterval / 1000)
          .toStringAsFixed(1)
          .replaceAll(RegExp(r'\.0$'), ''),
      selectedSensors: lab.sensors.toSet(),
      selectedColor: lab.colorValue != null
          ? Color(lab.colorValue!)
          : Colors.blue,
    );
  }

  /// Update form fields
  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void updateInterval(String interval) {
    state = state.copyWith(interval: interval);
  }

  void updateColor(Color color) {
    state = state.copyWith(selectedColor: color);
  }

  void toggleSensor(SensorType sensor) {
    final newSensors = Set<SensorType>.from(state.selectedSensors);
    if (newSensors.contains(sensor)) {
      newSensors.remove(sensor);
    } else {
      newSensors.add(sensor);
    }
    state = state.copyWith(selectedSensors: newSensors);
  }

  /// Validate form data
  String? validate() {
    if (state.name.trim().isEmpty) {
      return 'Please enter a lab name';
    }
    if (state.selectedSensors.isEmpty) {
      return 'Please select at least one sensor';
    }
    final interval = double.tryParse(state.interval);
    if (interval == null || interval < 0.1 || interval > 10) {
      return 'Interval must be between 0.1 and 10 seconds';
    }
    return null;
  }

  /// Get recording interval in milliseconds
  int getRecordingInterval() {
    final interval = double.parse(state.interval);
    return (interval * 1000).round();
  }

  /// Reset form
  void reset() {
    state = const CreateLabState();
  }

  /// Set error message
  void setError(String? error) {
    state = state.copyWith(errorMessage: error);
  }

  /// Set loading state
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
}

/// Provider for create/edit lab notifier
final createLabNotifierProvider =
    AutoDisposeNotifierProvider<CreateLabNotifier, CreateLabState>(
      CreateLabNotifier.new,
    );
