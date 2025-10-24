import 'package:sensorlab/src/core/utils/logger.dart';
import 'package:sensorlab/src/features/custom_lab/data/datasources/lab_local_datasource.dart';
import 'package:sensorlab/src/features/custom_lab/data/datasources/session_local_datasource.dart';
import 'package:sensorlab/src/features/custom_lab/data/services/data_export_service.dart';
import 'package:sensorlab/src/features/custom_lab/data/services/sensor_stream_service.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_data_point.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';

/// Clean implementation of LabRepository following separation of concerns
/// Orchestrates data sources and services without implementing business logic directly
class LabRepositoryImpl implements LabRepository {
  final LabLocalDataSource _labDataSource;
  final SessionLocalDataSource _sessionDataSource;
  final SensorStreamService _sensorStreamService;
  final DataExportService _exportService;

  LabRepositoryImpl({
    LabLocalDataSource? labDataSource,
    SessionLocalDataSource? sessionDataSource,
    SensorStreamService? sensorStreamService,
    DataExportService? exportService,
  }) : _labDataSource = labDataSource ?? LabLocalDataSource(),
       _sessionDataSource = sessionDataSource ?? SessionLocalDataSource(),
       _sensorStreamService = sensorStreamService ?? SensorStreamService(),
       _exportService = exportService ?? DataExportService();

  // ==================== Lab CRUD Operations ====================

  @override
  Future<Lab> createLab(Lab lab) async {
    return await _labDataSource.create(lab);
  }

  @override
  Future<Lab> updateLab(Lab lab) async {
    return await _labDataSource.update(lab);
  }

  @override
  Future<Lab?> getLabById(String labId) async {
    return await _labDataSource.getById(labId);
  }

  @override
  Future<List<Lab>> getAllLabs() async {
    return await _labDataSource.getAll();
  }

  @override
  Future<void> deleteLab(String labId) async {
    await _labDataSource.delete(labId);

    // Cascade delete: Remove all sessions and their data for this lab
    try {
      final sessions = await _sessionDataSource.getByLabId(labId);
      for (final session in sessions) {
        await _sessionDataSource.delete(session.id);
      }
    } catch (e) {
      AppLogger.log(
        'Error during cascade delete of sessions for lab $labId: $e',
        level: LogLevel.warning,
      );
    }
  }

  // ==================== Session CRUD Operations ====================

  @override
  Future<LabSession> createSession(LabSession session) async {
    return await _sessionDataSource.create(session);
  }

  @override
  Future<LabSession> updateSession(LabSession session) async {
    return await _sessionDataSource.update(session);
  }

  @override
  Future<LabSession?> getSessionById(String sessionId) async {
    return await _sessionDataSource.getById(sessionId);
  }

  @override
  Future<List<LabSession>> getLabSessions() async {
    return await _sessionDataSource.getAll();
  }

  @override
  Future<List<LabSession>> getSessionsByLabId(String labId) async {
    return await _sessionDataSource.getByLabId(labId);
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await _sessionDataSource.delete(sessionId);
  }

  @override
  Future<void> deleteAllLabSessions() async {
    await _sessionDataSource.deleteAll();
  }

  // ==================== Legacy Session Methods (Compatibility) ====================

  Future<void> saveLabSession(LabSession session) async {
    await _sessionDataSource.create(session);
  }

  Future<void> updateLabSession(LabSession session) async {
    await _sessionDataSource.update(session);
  }

  Future<void> deleteLabSession(String sessionId) async {
    await _sessionDataSource.delete(sessionId);
  }

  // ==================== Sensor Data Operations ====================

  @override
  Future<void> addSensorDataPoint({
    required String sessionId,
    required Map<String, dynamic> dataPoint,
  }) async {
    await _sessionDataSource.addDataPoint(
      sessionId: sessionId,
      dataPoint: dataPoint,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getSensorDataPoints(
    String sessionId,
  ) async {
    AppLogger.log(
      '🔍 [Repository] Getting data points for session: $sessionId',
      level: LogLevel.info,
    );
    final dataPoints = await _sessionDataSource.getDataPoints(sessionId);
    AppLogger.log(
      '🔍 [Repository] Retrieved ${dataPoints.length} data points from datasource',
      level: LogLevel.info,
    );
    if (dataPoints.isNotEmpty) {
      AppLogger.log(
        '   First data point: ${dataPoints.first}',
        level: LogLevel.debug,
      );
    }
    return dataPoints;
  }

  @override
  Future<void> saveDataPoint(
    String sessionId,
    SensorDataPoint dataPoint,
  ) async {
    await _sessionDataSource.addDataPoint(
      sessionId: sessionId,
      dataPoint: {
        'timestamp': dataPoint.timestamp.toIso8601String(),
        'sequenceNumber': dataPoint.sequenceNumber,
        'sensorValues': dataPoint.sensorValues.map(
          (key, value) => MapEntry(key.name, value),
        ),
      },
    );
  }

  @override
  Future<void> saveBatchDataPoints(
    String sessionId,
    List<SensorDataPoint> dataPoints,
  ) async {
    for (final dataPoint in dataPoints) {
      await saveDataPoint(sessionId, dataPoint);
    }
  }

  @override
  Future<List<SensorDataPoint>> getDataPointsBySessionId(
    String sessionId,
  ) async {
    final rawData = await _sessionDataSource.getDataPoints(sessionId);
    return rawData.map((data) {
      return SensorDataPoint(
        sessionId: sessionId,
        timestamp: DateTime.parse(data['timestamp'] as String),
        sequenceNumber: data['sequenceNumber'] as int,
        sensorValues: (data['sensorValues'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            SensorType.values.firstWhere((e) => e.name == key),
            value,
          ),
        ),
      );
    }).toList();
  }

  // ==================== Sensor Stream Operations ====================

  @override
  Stream<Map<String, dynamic>> getSensorStream(SensorType sensorType) {
    return _sensorStreamService.getStream(sensorType);
  }

  /// Disposes all active sensor streams
  void disposeSensorStreams() {
    _sensorStreamService.dispose();
  }

  // ==================== Data Export Operations ====================

  @override
  Future<String> exportSessionToCSV(
    String sessionId,
    List<Map<String, dynamic>> dataPoints,
  ) async {
    return await _exportService.exportToCSV(sessionId, dataPoints);
  }

  @override
  Future<String> exportMultipleSessionsToFile(
    String labName,
    Map<String, List<Map<String, dynamic>>> sessionsData,
  ) async {
    // Assuming you want to export to Excel for multiple sessions
    return await _exportService.exportMultipleSessionsToExcel(
      labName as Map<String, List<Map<String, dynamic>>>,
      sessionsData,
    );
  }
}
