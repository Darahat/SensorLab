import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/data/providers/create_lab_state_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

class CreateLabValidationState {
  final String? nameError;
  final String? intervalError;
  final bool hasSensorError;

  const CreateLabValidationState({
    this.nameError,
    this.intervalError,
    this.hasSensorError = false,
  });

  bool get isValid =>
      nameError == null && intervalError == null && !hasSensorError;
}

final createLabValidationProvider =
    Provider.family<CreateLabValidationState, CreateLabFormData>(
      (ref, context, formData) {
            String? nameError;
            String? intervalError;
            bool hasSensorError = false;
            // Removed unused variable to satisfy analyzer
            final l10n = AppLocalizations.of(context)!;
            // Name validation
            if (formData.name.trim().isEmpty) {
              nameError = l10n.pleaseEnterLabName;
            }

            // Interval validation
            if (formData.interval.isEmpty) {
              intervalError = l10n.pleaseEnterInterval;
            } else {
              final intervalValue = double.tryParse(formData.interval);
              if (intervalValue == null ||
                  intervalValue < 0.1 ||
                  intervalValue > 10) {
                intervalError = l10n.intervalMustBeBetween;
              }
            }

            // Sensor validation
            if (formData.selectedSensors.isEmpty) {
              hasSensorError = true;
            }

            return CreateLabValidationState(
              nameError: nameError,
              intervalError: intervalError,
              hasSensorError: hasSensorError,
            );
          }
          as FamilyCreate<
            CreateLabValidationState,
            ProviderRef<CreateLabValidationState>,
            CreateLabFormData
          >,
    );

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

// Helper provider to get form data from state
final createLabFormDataProvider = Provider<CreateLabFormData>((ref) {
  final state = ref.watch(createLabStateProvider);
  return CreateLabFormData(
    name: state.name,
    description: state.description,
    interval: state.interval,
    selectedSensors: state.selectedSensors,
  );
});
