import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensorlab/src/core/utils/logger.dart';

/// Service responsible for exporting session data to various formats
class DataExportService {
  /// Exports session data to CSV format
  Future<String> exportToCSV(
    String sessionId,
    List<Map<String, dynamic>> dataPoints,
  ) async {
    AppLogger.log(
      'Starting export for session $sessionId with ${dataPoints.length} data points',
      level: LogLevel.info,
    );

    if (dataPoints.isEmpty) {
      AppLogger.log(
        'No data points to export for session $sessionId',
        level: LogLevel.warning,
      );
      throw Exception('No data points to export for session $sessionId');
    }

    final csv = _generateCSV(dataPoints);
    AppLogger.log(
      'Generated CSV with ${csv.length} characters',
      level: LogLevel.info,
    );

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

  /// Saves CSV content to disk using Storage Access Framework
  Future<String> _saveToDisk(String sessionId, String csvContent) async {
    // Generate filename with timestamp
    final timestamp = DateTime.now();
    final filename =
        'lab_session_${sessionId}_${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')}_${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}.csv';

    AppLogger.log('Attempting to save file: $filename', level: LogLevel.info);

    String? savedPath;

    if (Platform.isAndroid || Platform.isIOS) {
      // Use Storage Access Framework / native saver with proper permissions
      try {
        AppLogger.log(
          'Using FlutterFileDialog for mobile platform',
          level: LogLevel.info,
        );

        final params = SaveFileDialogParams(
          fileName: filename,
          data: Uint8List.fromList(csvContent.codeUnits),
        );
        savedPath = await FlutterFileDialog.saveFile(params: params);

        if (savedPath == null) {
          // User cancelled the save dialog
          AppLogger.log(
            'User cancelled file save dialog',
            level: LogLevel.warning,
          );
          throw Exception('File save cancelled by user');
        }

        AppLogger.log(
          'File saved successfully via FlutterFileDialog: $savedPath',
          level: LogLevel.info,
        );
      } on MissingPluginException catch (e) {
        // Fallback to app documents directory if plugin channel not registered
        AppLogger.log(
          'FlutterFileDialog plugin not available, using fallback: $e',
          level: LogLevel.warning,
        );
        final directory = await getApplicationDocumentsDirectory();
        savedPath = '${directory.path}/$filename';
        final file = File(savedPath);
        await file.writeAsString(csvContent);
        AppLogger.log(
          'File saved to app directory: $savedPath',
          level: LogLevel.info,
        );
      } catch (e) {
        AppLogger.log(
          'Error saving file via FlutterFileDialog: $e',
          level: LogLevel.error,
        );
        rethrow;
      }
    } else {
      // Desktop platforms - save to documents directory
      AppLogger.log(
        'Using documents directory for desktop platform',
        level: LogLevel.info,
      );
      final directory = await getApplicationDocumentsDirectory();
      savedPath = '${directory.path}/$filename';
      final file = File(savedPath);
      await file.writeAsString(csvContent);
      AppLogger.log(
        'File saved to documents: $savedPath',
        level: LogLevel.info,
      );
    }

    return savedPath;
  }
}
