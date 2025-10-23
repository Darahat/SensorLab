import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/data/providers/data_export_service_provider.dart';
import 'package:sensorlab/src/features/custom_lab/data/providers/lab_datasource_provider.dart';
import 'package:sensorlab/src/features/custom_lab/data/providers/sensor_stream_service_provider.dart';
import 'package:sensorlab/src/features/custom_lab/data/providers/session_datasource_provider.dart';
import 'package:sensorlab/src/features/custom_lab/data/repositories/lab_repository_impl.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';

/// Main repository provider that orchestrates all data sources and services
/// Following clean architecture and dependency injection principles
final labRepositoryProvider = Provider<LabRepository>(
  (ref) => LabRepositoryImpl(
    labDataSource: ref.watch(labLocalDataSourceProvider),
    sessionDataSource: ref.watch(sessionLocalDataSourceProvider),
    sensorStreamService: ref.watch(sensorStreamServiceProvider),
    exportService: ref.watch(dataExportServiceProvider),
  ),
);
