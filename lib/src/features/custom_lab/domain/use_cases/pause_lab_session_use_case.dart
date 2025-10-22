import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/data/providers/lab_repository_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';

class PauseLabSessionUseCase {
  final LabRepository _repository;

  PauseLabSessionUseCase(this._repository);

  Future<void> call(LabSession session) async {
    final updatedSession = session.copyWith(
      status: RecordingStatus.paused,
    );
    await _repository.saveLabSession(updatedSession);
  }
}

final pauseLabSessionUseCaseProvider = Provider<PauseLabSessionUseCase>(
  (ref) => PauseLabSessionUseCase(ref.read(labRepositoryProvider)),
);
