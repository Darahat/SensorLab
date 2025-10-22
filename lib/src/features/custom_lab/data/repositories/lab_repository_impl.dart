import 'dart:io';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_data_point.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';

/// Implementation of LabRepository using Hive for local storage
class LabRepositoryImpl implements LabRepository {
  final Box<Lab> _labsBox;
  final Box<LabSession> _sessionsBox;
  final Box<SensorDataPoint> _dataBox;

  LabRepositoryImpl(this._labsBox, this._sessionsBox, this._dataBox);

  // ==================== Lab CRUD Operations ====================

  @override
  Future<List<Lab>> getAllLabs() async {
    return _labsBox.values.toList();
  }

  @override
  Future<Lab?> getLabById(String id) async {
    return _labsBox.get(id);
  }

  @override
  Future<void> createLab(Lab lab) async {
    await _labsBox.put(lab.id, lab);
  }

  @override
  Future<void> updateLab(Lab lab) async {
    await _labsBox.put(lab.id, lab);
  }

  @override
  Future<void> deleteLab(String id) async {
    // Delete lab
    await _labsBox.delete(id);

    // Also delete all sessions for this lab
    final sessions = await getSessionsByLabId(id);
    for (final session in sessions) {
      await deleteSession(session.id);
    }
  }

  // ==================== Session Operations ====================

  @override
  Future<List<LabSession>> getAllSessions() async {
    final sessions = _sessionsBox.values.toList();
    // Sort by start time, most recent first
    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sessions;
  }

  @override
  Future<List<LabSession>> getSessionsByLabId(String labId) async {
    final sessions = _sessionsBox.values
        .where((s) => s.labId == labId)
        .toList();
    // Sort by start time, most recent first
    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sessions;
  }

  @override
  Future<LabSession?> getSessionById(String id) async {
    return _sessionsBox.get(id);
  }

  @override
  Future<void> createSession(LabSession session) async {
    await _sessionsBox.put(session.id, session);
  }

  @override
  Future<void> updateSession(LabSession session) async {
    await _sessionsBox.put(session.id, session);
  }

  @override
  Future<void> deleteSession(String id) async {
    // Delete session
    await _sessionsBox.delete(id);

    // Also delete all data points for this session
    await deleteDataPointsBySessionId(id);
  }

  // ==================== Data Point Operations ====================

  @override
  Future<void> saveDataPoint(SensorDataPoint dataPoint) async {
    // Use a composite key: sessionId_sequenceNumber
    final key = '${dataPoint.sessionId}_${dataPoint.sequenceNumber}';
    await _dataBox.put(key, dataPoint);
    AppLogger.log(
      'LabRepositoryImpl: saved data point key=$key',
      level: LogLevel.debug,
    );
  }

  @override
  Future<List<SensorDataPoint>> getDataPointsBySessionId(
    String sessionId,
  ) async {
    final dataPoints = _dataBox.values
        .where((dp) => dp.sessionId == sessionId)
        .toList();

    // Sort by sequence number
    dataPoints.sort((a, b) => a.sequenceNumber.compareTo(b.sequenceNumber));
    return dataPoints;
  }

  @override
  Future<void> deleteDataPointsBySessionId(String sessionId) async {
    final keysToDelete = <String>[];

    // Find all keys for this session
    for (final key in _dataBox.keys) {
      final dataPoint = _dataBox.get(key);
      if (dataPoint?.sessionId == sessionId) {
        keysToDelete.add(key.toString());
      }
    }

    // Delete all found keys
    await _dataBox.deleteAll(keysToDelete);
  }

  // ==================== Bulk Operations ====================

  @override
  Future<void> saveBatchDataPoints(List<SensorDataPoint> dataPoints) async {
    final Map<String, SensorDataPoint> batchData = {};

    for (final dataPoint in dataPoints) {
      final key = '${dataPoint.sessionId}_${dataPoint.sequenceNumber}';
      batchData[key] = dataPoint;
    }

    await _dataBox.putAll(batchData);
  }

  // ==================== Export Operations ====================

  @override
  Future<String> exportSessionToCSV(String sessionId) async {
    final session = await getSessionById(sessionId);
    if (session == null) {
      throw Exception('Session not found: $sessionId');
    }

    final dataPoints = await getDataPointsBySessionId(sessionId);
    if (dataPoints.isEmpty) {
      throw Exception('No data points found for session: $sessionId');
    }

    // Generate CSV content
    final csv = _generateCSVContent(session, dataPoints);

    // Get app documents directory
    final directory = await getApplicationDocumentsDirectory();
    final customLabDir = Directory('${directory.path}/CustomLab');
    if (!await customLabDir.exists()) {
      await customLabDir.create(recursive: true);
    }

    // Create filename: LabName_YYYY-MM-DD_HH-MM-SS.csv
    final timestamp = DateFormat(
      'yyyy-MM-dd_HH-mm-ss',
    ).format(session.startTime);
    final labNameClean = session.labName
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_');
    final filename = '${labNameClean}_$timestamp.csv';
    final filePath = '${customLabDir.path}/$filename';

    // Write CSV file
    final file = File(filePath);
    await file.writeAsString(csv, flush: true);

    return filePath;
  }

  /// Generate CSV content from session and data points
  String _generateCSVContent(
    LabSession session,
    List<SensorDataPoint> dataPoints,
  ) {
    final buffer = StringBuffer();

    // ==================== Metadata Section ====================
    buffer.writeln('# ==================================================');
    buffer.writeln('# Custom Lab Session Export');
    buffer.writeln('# ==================================================');
    buffer.writeln('# Lab Name: ${session.labName}');
    buffer.writeln('# Lab ID: ${session.labId}');
    buffer.writeln('# Session ID: ${session.id}');
    buffer.writeln('# Session Status: ${session.status.name}');
    buffer.writeln('# ==================================================');
    buffer.writeln('# Recording Details');
    buffer.writeln('# ==================================================');
    buffer.writeln('# Start Time: ${session.startTime.toIso8601String()}');
    if (session.endTime != null) {
      buffer.writeln('# End Time: ${session.endTime!.toIso8601String()}');
    }
    buffer.writeln(
      '# Duration: ${session.duration} seconds (${_formatDuration(session.duration)})',
    );
    buffer.writeln('# Total Data Points: ${session.dataPointsCount}');
    buffer.writeln('# ==================================================');
    buffer.writeln('# Sensor Configuration');
    buffer.writeln('# ==================================================');
    buffer.writeln('# Sensors: ${session.sensorTypes.join(", ")}');

    // Add session notes if available
    if (session.notes != null && session.notes!.isNotEmpty) {
      buffer.writeln('# ==================================================');
      buffer.writeln('# Session Notes');
      buffer.writeln('# ==================================================');
      final noteLines = session.notes!.split('\n');
      for (final line in noteLines) {
        buffer.writeln('# $line');
      }
    }

    buffer.writeln('# ==================================================');
    buffer.writeln('# Data Section');
    buffer.writeln('# ==================================================');

    // ==================== Header Row ====================
    // Get all unique sensor keys from first data point
    if (dataPoints.isEmpty) {
      return buffer.toString();
    }

    final sensorKeys = dataPoints.first.sensorValues.keys.toList()..sort();
    buffer.write('Timestamp,Sequence');
    for (final key in sensorKeys) {
      buffer.write(',$key');
    }
    buffer.writeln();

    // ==================== Data Rows ====================
    for (final dataPoint in dataPoints) {
      buffer.write(
        '${dataPoint.timestamp.toIso8601String()},${dataPoint.sequenceNumber}',
      );

      for (final key in sensorKeys) {
        final value = dataPoint.sensorValues[key];
        if (value == null) {
          buffer.write(',');
        } else if (value is num) {
          // Format numbers with appropriate precision
          if (value is int) {
            buffer.write(',$value');
          } else {
            buffer.write(',${value.toStringAsFixed(6)}');
          }
        } else {
          // Escape strings containing commas
          final valueStr = value.toString();
          if (valueStr.contains(',')) {
            buffer.write(',"${valueStr.replaceAll('"', '""')}"');
          } else {
            buffer.write(',$valueStr');
          }
        }
      }
      buffer.writeln();
    }

    return buffer.toString();
  }

  /// Format duration in human-readable format
  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds seconds';
    } else if (seconds < 3600) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return '$minutes minutes $remainingSeconds seconds';
    } else {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      final remainingSeconds = seconds % 60;
      return '$hours hours $minutes minutes $remainingSeconds seconds';
    }
  }

  // ==================== Cleanup ====================

  @override
  Future<void> clearAllData() async {
    await _labsBox.clear();
    await _sessionsBox.clear();
    await _dataBox.clear();
  }
}
