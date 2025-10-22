import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/data/providers/lab_repository_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';

class AddDataPointUseCase {
  final LabRepository _repository;

  AddDataPointUseCase(this._repository);

  Future<void> call({
    required String sessionId,
    required Map<String, dynamic> dataPoint,
  }) async {
    await _repository.addSensorDataPoint(sessionId: sessionId, dataPoint: dataPoint);
  }
}

final addDataPointUseCaseProvider = Provider<AddDataPointUseCase>(
  (ref) => AddDataPointUseCase(ref.read(labRepositoryProvider)),
);
