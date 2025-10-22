import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/data/providers/lab_repository_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';

class ResumeLabSessionUseCase {
  final LabRepository _repository;

  ResumeLabSessionUseCase(this._repository);

  Future<void> call(LabSession session) async {
    final updatedSession = session.copyWith(
      status: RecordingStatus.recording,
    );
    await _repository.saveLabSession(updatedSession);
  }
}

final resumeLabSessionUseCaseProvider = Provider<ResumeLabSessionUseCase>(
  (ref) => ResumeLabSessionUseCase(ref.read(labRepositoryProvider)),
);
