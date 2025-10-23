import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sensorlab/src/core/utils/logger.dart';

/// Service responsible for exporting session data to various formats
class DataExportService {
  /// Exports session data to CSV format
  Future<String> exportToCSV(
    String sessionId,
    List<Map<String, dynamic>> dataPoints,
  ) async {
    if (dataPoints.isEmpty) {
      throw Exception('No data points to export for session $sessionId');
    }

    final csv = _generateCSV(dataPoints);
    final path = await _saveToDisk(sessionId, csv);

    AppLogger.log(
      'Exported session $sessionId to CSV: $path',
      level: LogLevel.info,
    );

    return path;
  }

  /// Generates CSV content from data points
  String _generateCSV(List<Map<String, dynamic>> dataPoints) {
    // Determine all unique keys (column headers)
    final Set<String> headers = {};
    for (final dp in dataPoints) {
      headers.addAll(dp.keys);
    }
    final sortedHeaders = headers.toList()..sort();

    // Build CSV manually
    final csvLines = <String>[];

    // Add header row
    csvLines.add('timestamp,${sortedHeaders.join(',')}');

    // Add data rows
    for (var i = 0; i < dataPoints.length; i++) {
      final dp = dataPoints[i];
      final row = <String>[
        i.toString(),
        ...sortedHeaders.map((header) => _escapeCsvValue(dp[header])),
      ];
      csvLines.add(row.join(','));
    }

    return csvLines.join('\n');
  }

  /// Escapes CSV value to handle commas, quotes, and newlines
  String _escapeCsvValue(dynamic value) {
    if (value == null) return '';
    final str = value.toString();
    if (str.contains(',') || str.contains('"') || str.contains('\n')) {
      return '"${str.replaceAll('"', '""')}"';
    }
    return str;
  }

  /// Saves CSV content to disk
  Future<String> _saveToDisk(String sessionId, String csvContent) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/lab_session_$sessionId.csv';
    final file = File(path);
    await file.writeAsString(csvContent);
    return path;
  }
}
