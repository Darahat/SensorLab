import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_data_point.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';

/// Abstract repository for all custom lab data operations.
///
/// This contract defines the boundary between the domain and data layers for the
/// custom lab feature. It ensures that the application logic (Controllers/
/// Notifiers) is completely decoupled from the implementation of data sources,
/// such as sensor streams or the Hive database.
abstract class LabRepository {
  // Lab CRUD operations
  /// Creates a new lab configuration.
  Future<Lab> createLab(Lab lab);

  /// Updates an existing lab configuration.
  Future<Lab> updateLab(Lab lab);

  /// Retrieves a specific lab configuration by its ID.
  Future<Lab?> getLabById(String labId);

  /// Retrieves all saved [Lab] configurations.
  Future<List<Lab>> getAllLabs();

  /// Deletes a specific lab configuration by its ID.
  Future<void> deleteLab(String labId);

  // Session CRUD operations
  /// Creates a new lab session.
  Future<LabSession> createSession(LabSession session);

  /// Updates an existing lab session.
  Future<LabSession> updateSession(LabSession session);

  /// Retrieves a specific lab session by its ID.
  Future<LabSession?> getSessionById(String sessionId);

  /// Retrieves all sessions for a specific lab.
  Future<List<LabSession>> getSessionsByLabId(String labId);

  /// Retrieves a sorted list of all saved [LabSession]s.
  Future<List<LabSession>> getLabSessions();

  /// Deletes a specific lab session by its ID.
  Future<void> deleteSession(String sessionId);

  /// Deletes all saved lab sessions.
  Future<void> deleteAllLabSessions();

  // Data point operations
  /// Saves a single data point for a session.
  Future<void> saveDataPoint(String sessionId, SensorDataPoint dataPoint);

  /// Saves multiple data points in a batch.
  Future<void> saveBatchDataPoints(
    String sessionId,
    List<SensorDataPoint> dataPoints,
  );

  /// Retrieves all data points for a given lab session.
  Future<List<SensorDataPoint>> getDataPointsBySessionId(String sessionId);

  // Legacy methods for backward compatibility
  /// Saves a [LabSession] to the persistent storage.
  Future<void> saveLabSession(LabSession session);

  /// Adds a data point for a specific sensor to a lab session.
  /// The implementation will handle how this data is stored (e.g., in Hive).
  Future<void> addSensorDataPoint({
    required String sessionId,
    required Map<String, dynamic> dataPoint,
  });

  /// Retrieves all data points for a given lab session.
  /// This might return a large dataset, so consider pagination or streaming for large sessions.
  Future<List<Map<String, dynamic>>> getSensorDataPoints(String sessionId);

  /// Provides a stream of real-time data for a given sensor type.
  /// The implementation will handle subscribing to the actual hardware sensor.
  Stream<Map<String, dynamic>> getSensorStream(SensorType sensorType);

  /// Exports a lab session's data to a CSV file.
  Future<String> exportSessionToCSV(
    String sessionId,
    List<Map<String, dynamic>> dataPoints,
  );

  /// Exports multiple lab sessions' data to a single file (e.g., Excel with multiple sheets).
  Future<String> exportMultipleSessionsToFile(
    String labName,
    Map<String, List<Map<String, dynamic>>> sessionsData,
  );
}
