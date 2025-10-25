import 'package:hive/hive.dart';
import 'package:sensorlab/src/core/services/hive_service.dart';
import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';

/// Data source responsible for LabSession CRUD operations in local storage
class SessionLocalDataSource {
  static const String _sessionsBoxName = HiveService.labSessionsBoxName;
  static const String _sensorDataBoxPrefix = 'sensorData_';

  /// Opens the lab sessions box
  Future<Box<LabSession>> _openSessionsBox() async {
    return await Hive.openBox<LabSession>(_sessionsBoxName);
  }

  /// Opens the sensor data box for a specific session
  /// Note: Use dynamic Box typing to avoid runtime cast errors when legacy
  /// entries were written without strict generic types. We'll normalize types
  /// when reading.
  Future<Box> _openSensorDataBox(String sessionId) async {
    return await Hive.openBox('$_sensorDataBoxPrefix$sessionId');
  }

  /// Creates a new session
  Future<LabSession> create(LabSession session) async {
    final box = await _openSessionsBox();
    await box.put(session.id, session);
    return session;
  }

  /// Updates an existing session
  Future<LabSession> update(LabSession session) async {
    final box = await _openSessionsBox();
    await box.put(session.id, session);
    return session;
  }

  /// Retrieves a session by ID
  Future<LabSession?> getById(String sessionId) async {
    final box = await _openSessionsBox();
    return box.get(sessionId);
  }

  /// Retrieves all sessions sorted by start time (most recent first)
  Future<List<LabSession>> getAll() async {
    final box = await _openSessionsBox();
    final sessions = box.values.toList();
    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sessions;
  }

  /// Retrieves sessions for a specific lab
  Future<List<LabSession>> getByLabId(String labId) async {
    final sessions = await getAll();
    return sessions.where((s) => s.labId == labId).toList();
  }

  /// Deletes a session and its associated sensor data
  Future<void> delete(String sessionId) async {
    final box = await _openSessionsBox();
    await box.delete(sessionId);

    // Delete associated sensor data box
    try {
      await Hive.deleteBoxFromDisk('$_sensorDataBoxPrefix$sessionId');
    } catch (e) {
      AppLogger.log(
        'Failed to delete sensor data box for session $sessionId: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// Deletes all sessions and their sensor data
  Future<void> deleteAll() async {
    final box = await _openSessionsBox();
    final sessionIds = box.keys.toList();

    await box.clear();

    // Delete all sensor data boxes
    for (final sessionId in sessionIds) {
      try {
        await Hive.deleteBoxFromDisk('$_sensorDataBoxPrefix$sessionId');
      } catch (e) {
        AppLogger.log(
          'Failed to delete sensor data box for session $sessionId: $e',
          level: LogLevel.warning,
        );
      }
    }
  }

  /// Adds a sensor data point to a session
  Future<void> addDataPoint({
    required String sessionId,
    required Map<String, dynamic> dataPoint,
  }) async {
    AppLogger.log(
      '💾 [Datasource] Adding data point to session: $sessionId',
      level: LogLevel.debug,
    );
    AppLogger.log(
      '   Data point keys: ${dataPoint.keys.toList()}',
      level: LogLevel.debug,
    );
    final box = await _openSensorDataBox(sessionId);
    await box.add(dataPoint);
    AppLogger.log(
      '✅ [Datasource] Data point added. Total in box: ${box.length}',
      level: LogLevel.debug,
    );
  }

  /// Retrieves all sensor data points for a session
  Future<List<Map<String, dynamic>>> getDataPoints(String sessionId) async {
    AppLogger.log(
      '🔍 [Datasource] Opening box for session: $sessionId',
      level: LogLevel.info,
    );
    final box = await _openSensorDataBox(sessionId);
    AppLogger.log(
      '🔍 [Datasource] Box opened. Contains ${box.length} items',
      level: LogLevel.info,
    );

    // Convert box values to List<Map<String, dynamic>> with normalized key types
    final dataPoints = <Map<String, dynamic>>[];
    for (var i = 0; i < box.length; i++) {
      final value = box.getAt(i);
      if (value is Map) {
        // Normalize to Map<String, dynamic>
        final normalized = <String, dynamic>{
          for (final entry in value.entries) entry.key.toString(): entry.value,
        };
        // Also normalize nested 'sensorValues' map if present
        final sv = normalized['sensorValues'];
        if (sv is Map) {
          normalized['sensorValues'] = {
            for (final e in (sv).entries) e.key.toString(): e.value,
          };
        }
        dataPoints.add(normalized);
      }
    }

    if (dataPoints.isNotEmpty) {
      AppLogger.log(
        '   First item keys: ${dataPoints.first.keys.toList()}',
        level: LogLevel.debug,
      );
    }

    AppLogger.log(
      '✅ [Datasource] Returning ${dataPoints.length} data points',
      level: LogLevel.info,
    );

    return dataPoints;
  }
}
