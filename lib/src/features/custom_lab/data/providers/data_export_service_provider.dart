import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/data/services/data_export_service.dart';

/// Provider for Data Export service
final dataExportServiceProvider = Provider<DataExportService>(
  (ref) => DataExportService(),
);
