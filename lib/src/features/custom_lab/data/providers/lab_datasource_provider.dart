import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/data/datasources/lab_local_datasource.dart';

/// Provider for Lab local data source
final labLocalDataSourceProvider = Provider<LabLocalDataSource>(
  (ref) => LabLocalDataSource(),
);
