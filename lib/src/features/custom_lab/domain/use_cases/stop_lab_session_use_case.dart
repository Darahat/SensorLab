import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/data/providers/lab_repository_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';

class StopLabSessionUseCase {
  final LabRepository _repository;

  StopLabSessionUseCase(this._repository);

  Future<void> call(LabSession session) async {
    final updatedSession = session.copyWith(
      endTime: DateTime.now(),
      status: RecordingStatus.completed,
    );
    await _repository.saveLabSession(updatedSession);
  }
}

final stopLabSessionUseCaseProvider = Provider<StopLabSessionUseCase>(
  (ref) => StopLabSessionUseCase(ref.read(labRepositoryProvider)),
);
