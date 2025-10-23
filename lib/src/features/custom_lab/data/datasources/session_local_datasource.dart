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
  Future<Box<Map<String, dynamic>>> _openSensorDataBox(String sessionId) async {
    return await Hive.openBox<Map<String, dynamic>>(
      '$_sensorDataBoxPrefix$sessionId',
    );
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
    final box = await _openSensorDataBox(sessionId);
    await box.add(dataPoint);
  }

  /// Retrieves all sensor data points for a session
  Future<List<Map<String, dynamic>>> getDataPoints(String sessionId) async {
    final box = await _openSensorDataBox(sessionId);
    return box.values.toList();
  }
}
