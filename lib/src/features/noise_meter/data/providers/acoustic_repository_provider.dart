import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/noise_meter/data/repositories/acoustic_repository_impl.dart';
import 'package:sensorlab/src/features/noise_meter/domain/repositories/acoustic_repository.dart';

/// Riverpod provider that exposes the AcousticRepository abstraction.
/// Kept in the data/providers layer to decouple provider placement
/// from repository implementation.
final acousticRepositoryProvider = Provider<AcousticRepository>((ref) {
  return AcousticRepositoryImpl();
});
