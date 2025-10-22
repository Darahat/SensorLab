import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/services/hive_service.dart';
import 'package:sensorlab/src/features/custom_lab/data/repositories/lab_repository_impl.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';

final labRepositoryProvider = Provider<LabRepository>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return LabRepositoryImpl(
    hiveService.customLabsBox,
    hiveService.labSessionsBox,
    hiveService.sensorDataBox,
  );
});