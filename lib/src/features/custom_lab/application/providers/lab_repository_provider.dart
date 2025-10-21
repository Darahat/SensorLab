import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/services/hive_service.dart';
import 'package:sensorlab/src/features/custom_lab/data/repositories/lab_repository_impl.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';

/// Provider for LabRepository
final labRepositoryProvider = Provider<LabRepository>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return LabRepositoryImpl(
    hiveService.customLabsBox,
    hiveService.labSessionsBox,
    hiveService.sensorDataBox,
  );
});

/// Provider for fetching all labs
final labListProvider = FutureProvider<List<Lab>>((ref) async {
  final repository = ref.watch(labRepositoryProvider);
  return repository.getAllLabs();
});

/// Provider for fetching labs with auto-refresh
final labListAutoRefreshProvider = StreamProvider<List<Lab>>((ref) async* {
  final repository = ref.watch(labRepositoryProvider);

  // Initial fetch
  yield await repository.getAllLabs();

  // Refresh every 5 seconds when actively watching
  while (true) {
    await Future.delayed(const Duration(seconds: 5));
    yield await repository.getAllLabs();
  }
});
