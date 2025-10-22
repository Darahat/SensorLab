import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/data/repositories/lab_repository_impl.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';

final labRepositoryProvider = Provider<LabRepository>(
  (ref) => LabRepositoryImpl(),
);
