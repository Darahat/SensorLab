import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/data/datasources/session_local_datasource.dart';

/// Provider for Session local data source
final sessionLocalDataSourceProvider = Provider<SessionLocalDataSource>(
  (ref) => SessionLocalDataSource(),
);
