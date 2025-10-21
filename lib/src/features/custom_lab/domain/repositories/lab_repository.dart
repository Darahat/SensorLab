import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_data_point.dart';

/// Repository interface for lab data management
abstract class LabRepository {
  // Lab CRUD operations
  Future<List<Lab>> getAllLabs();
  Future<Lab?> getLabById(String id);
  Future<void> createLab(Lab lab);
  Future<void> updateLab(Lab lab);
  Future<void> deleteLab(String id);

  // Session operations
  Future<List<LabSession>> getAllSessions();
  Future<List<LabSession>> getSessionsByLabId(String labId);
  Future<LabSession?> getSessionById(String id);
  Future<void> createSession(LabSession session);
  Future<void> updateSession(LabSession session);
  Future<void> deleteSession(String id);

  // Data point operations
  Future<void> saveDataPoint(SensorDataPoint dataPoint);
  Future<List<SensorDataPoint>> getDataPointsBySessionId(String sessionId);
  Future<void> deleteDataPointsBySessionId(String sessionId);

  // Bulk operations
  Future<void> saveBatchDataPoints(List<SensorDataPoint> dataPoints);
  
  // Export operations
  Future<String> exportSessionToCSV(String sessionId);
  
  // Cleanup
  Future<void> clearAllData();
}
