import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/custom_lab/data/providers/lab_repository_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';

class AddDataPointUseCase {
  final LabRepository _repository;

  AddDataPointUseCase(this._repository);

  Future<void> call({
    required String sessionId,
    required Map<String, dynamic> dataPoint,
  }) async {
    AppLogger.log(
      '➕ [AddDataPointUseCase] Saving data point for session: $sessionId',
      level: LogLevel.debug,
    );
    AppLogger.log(
      '   Data point has ${dataPoint.length} entries',
      level: LogLevel.debug,
    );
    await _repository.addSensorDataPoint(
      sessionId: sessionId,
      dataPoint: dataPoint,
    );
    AppLogger.log(
      '✅ [AddDataPointUseCase] Data point saved successfully',
      level: LogLevel.debug,
    );
  }
}

final addDataPointUseCaseProvider = Provider<AddDataPointUseCase>(
  (ref) => AddDataPointUseCase(ref.read(labRepositoryProvider)),
);
