import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';
import 'package:sensorlab/src/features/custom_lab/data/providers/lab_repository_provider.dart';

class StartLabSessionUseCase {
  final LabRepository _repository;

  StartLabSessionUseCase(this._repository);

  Future<LabSession> call({
    required Lab lab,
    required String sessionId,
  }) async {
    final newSession = LabSession(
      id: sessionId,
      labId: lab.id,
      labName: lab.name,
      startTime: DateTime.now(),
      status: RecordingStatus.recording,
      sensorTypes: lab.sensors,
    );
    await _repository.saveLabSession(newSession);
    return newSession;
  }
}

final startLabSessionUseCaseProvider = Provider<StartLabSessionUseCase>(
  (ref) => StartLabSessionUseCase(ref.read(labRepositoryProvider)),
);
