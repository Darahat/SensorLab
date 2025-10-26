import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

class CreateLabState {
  final String name;
  final String description;
  final String interval;
  final Set<SensorType> selectedSensors;
  final Color selectedColor;

  const CreateLabState({
    this.name = '',
    this.description = '',
    this.interval = '1',
    this.selectedSensors = const {},
    this.selectedColor = Colors.blue,
  });

  CreateLabState copyWith({
    String? name,
    String? description,
    String? interval,
    Set<SensorType>? selectedSensors,
    Color? selectedColor,
  }) {
    return CreateLabState(
      name: name ?? this.name,
      description: description ?? this.description,
      interval: interval ?? this.interval,
      selectedSensors: selectedSensors ?? this.selectedSensors,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}

final createLabStateProvider = StateProvider<CreateLabState>((ref) {
  return const CreateLabState();
});

final createLabFormDataProvider = Provider<CreateLabFormData>((ref) {
  final state = ref.watch(createLabStateProvider);
  return CreateLabFormData(
    name: state.name,
    description: state.description,
    interval: state.interval,
    selectedSensors: state.selectedSensors,
  );
});

class CreateLabFormData {
  final String name;
  final String description;
  final String interval;
  final Set<SensorType> selectedSensors;

  const CreateLabFormData({
    required this.name,
    required this.description,
    required this.interval,
    required this.selectedSensors,
  });
}
