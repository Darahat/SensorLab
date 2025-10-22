import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_repository_provider.dart';
import 'package:sensorlab/src/features/custom_lab/application/use_cases/record_session_use_case.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_data_point.dart';

/// Provider for record session use case
final recordSessionUseCaseProvider = Provider<RecordSessionUseCase>((ref) {
  final repository = ref.watch(labRepositoryProvider);
  return RecordSessionUseCase(repository);
});

/// Provider for fetching sessions by lab ID
final labSessionsProvider = FutureProvider.family<List<LabSession>, String>((
  ref,
  labId,
) async {
  final repository = ref.watch(labRepositoryProvider);
  return repository.getSessionsByLabId(labId);
});

/// Provider for fetching data points for a session
final sessionDataPointsProvider =
    FutureProvider.family<List<SensorDataPoint>, String>((
      ref,
      sessionId,
    ) async {
      final repository = ref.watch(labRepositoryProvider);
      return repository.getDataPointsBySessionId(sessionId);
    });
