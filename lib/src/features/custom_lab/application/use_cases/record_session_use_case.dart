import 'dart:async';

import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_data_point.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';
import 'package:uuid/uuid.dart';

/// Use case for managing recording sessions
class RecordSessionUseCase {
  final LabRepository _repository;
  final _uuid = const Uuid();

  RecordSessionUseCase(this._repository);

  /// Start a new recording session
  Future<LabSession> startSession({
    required String labId,
    String? notes,
  }) async {
    final lab = await _repository.getLabById(labId);
    if (lab == null) {
      throw Exception('Lab not found: $labId');
    }

    final sessionId = _uuid.v4();
    final session = LabSession(
      id: sessionId,
      labId: labId,
      labName: lab.name,
      startTime: DateTime.now(),
      endTime: null,
      status: RecordingStatus.recording,
      dataPointsCount: 0,
      duration: 0,
      notes: notes ?? '',
      exportPath: null,
      sensorTypes: lab.sensors,
    );

    await _repository.createSession(session);

    // Verify the session was saved correctly
    final savedSession = await _repository.getSessionById(sessionId);
    if (savedSession == null) {
      throw Exception('Failed to save session: $sessionId');
    }

    return savedSession;
  }

  /// Pause an active recording session
  Future<LabSession> pauseSession(String sessionId) async {
    final session = await _repository.getSessionById(sessionId);
    if (session == null) {
      throw Exception('Session not found: $sessionId');
    }

    if (session.status != RecordingStatus.recording) {
      throw Exception('Can only pause recording sessions');
    }

    final now = DateTime.now();
    final updatedSession = LabSession(
      id: session.id,
      labId: session.labId,
      labName: session.labName,
      startTime: session.startTime,
      endTime: session.endTime,
      status: RecordingStatus.paused,
      dataPointsCount: session.dataPointsCount,
      // Store duration in seconds to match the model contract
      duration: now.difference(session.startTime).inSeconds,
      notes: session.notes,
      exportPath: session.exportPath,
      sensorTypes: session.sensorTypes,
    );

    await _repository.updateSession(updatedSession);
    return updatedSession;
  }

  /// Resume a paused recording session
  Future<LabSession> resumeSession(String sessionId) async {
    final session = await _repository.getSessionById(sessionId);
    if (session == null) {
      throw Exception('Session not found: $sessionId');
    }

    if (session.status != RecordingStatus.paused) {
      throw Exception('Can only resume paused sessions');
    }

    final updatedSession = LabSession(
      id: session.id,
      labId: session.labId,
      labName: session.labName,
      startTime: session.startTime,
      endTime: session.endTime,
      status: RecordingStatus.recording,
      dataPointsCount: session.dataPointsCount,
      duration: session.duration,
      notes: session.notes,
      exportPath: session.exportPath,
      sensorTypes: session.sensorTypes,
    );

    await _repository.updateSession(updatedSession);
    return updatedSession;
  }

  /// Stop a recording session
  Future<LabSession> stopSession({
    required String sessionId,
    String? additionalNotes,
  }) async {
    final session = await _repository.getSessionById(sessionId);
    if (session == null) {
      throw Exception('Session not found: $sessionId');
    }

    if (session.status != RecordingStatus.recording &&
        session.status != RecordingStatus.paused) {
      throw Exception('Session already stopped');
    }

    final now = DateTime.now();
    final updatedSession = LabSession(
      id: session.id,
      labId: session.labId,
      labName: session.labName,
      startTime: session.startTime,
      endTime: now,
      status: RecordingStatus.completed,
      dataPointsCount: session.dataPointsCount,
      // Store duration in seconds to match the model contract
      duration: now.difference(session.startTime).inSeconds,
      notes: additionalNotes != null
          ? '${session.notes}\n$additionalNotes'.trim()
          : session.notes,
      exportPath: session.exportPath,
      sensorTypes: session.sensorTypes,
    );

    await _repository.updateSession(updatedSession);
    return updatedSession;
  }

  /// Add a data point to a session
  Future<void> addDataPoint({
    required String sessionId,
    required Map<SensorType, dynamic> sensorValues,
  }) async {
    final session = await _repository.getSessionById(sessionId);
    if (session == null) {
      throw Exception('Session not found: $sessionId');
    }

    if (session.status != RecordingStatus.recording) {
      throw Exception('Can only add data to recording sessions');
    }

    final dataPoint = SensorDataPoint(
      sessionId: sessionId,
      timestamp: DateTime.now(),
      sensorValues: sensorValues,
      sequenceNumber: session.dataPointsCount + 1,
    );

    await _repository.saveDataPoint(session.id, dataPoint);

    // Update session data points count
    final updatedSession = LabSession(
      id: session.id,
      labId: session.labId,
      labName: session.labName,
      startTime: session.startTime,
      endTime: session.endTime,
      status: session.status,
      dataPointsCount: session.dataPointsCount + 1,
      duration: session.duration,
      notes: session.notes,
      exportPath: session.exportPath,
      sensorTypes: session.sensorTypes,
    );

    await _repository.updateSession(updatedSession);
  }

  /// Add multiple data points in batch
  Future<void> addDataPointsBatch({
    required String sessionId,
    required List<Map<SensorType, dynamic>> sensorValuesList,
  }) async {
    final session = await _repository.getSessionById(sessionId);
    if (session == null) {
      throw Exception('Session not found: $sessionId');
    }

    if (session.status != RecordingStatus.recording) {
      throw Exception('Can only add data to recording sessions');
    }

    final now = DateTime.now();
    final dataPoints = <SensorDataPoint>[];

    for (int i = 0; i < sensorValuesList.length; i++) {
      dataPoints.add(
        SensorDataPoint(
          sessionId: sessionId,
          timestamp: now.add(Duration(milliseconds: i)),
          sensorValues: sensorValuesList[i],
          sequenceNumber: session.dataPointsCount + i + 1,
        ),
      );
    }

    await _repository.saveBatchDataPoints(sessionId, dataPoints);

    // Update session data points count
    final updatedSession = LabSession(
      id: session.id,
      labId: session.labId,
      labName: session.labName,
      startTime: session.startTime,
      endTime: session.endTime,
      status: session.status,
      dataPointsCount: session.dataPointsCount + dataPoints.length,
      duration: session.duration,
      notes: session.notes,
      exportPath: session.exportPath,
      sensorTypes: session.sensorTypes,
    );

    await _repository.updateSession(updatedSession);
  }

  /// Mark a session as failed
  Future<LabSession> markSessionAsFailed({
    required String sessionId,
    required String errorMessage,
  }) async {
    final session = await _repository.getSessionById(sessionId);
    if (session == null) {
      throw Exception('Session not found: $sessionId');
    }

    final now = DateTime.now();
    final updatedSession = LabSession(
      id: session.id,
      labId: session.labId,
      labName: session.labName,
      startTime: session.startTime,
      endTime: now,
      status: RecordingStatus.failed,
      dataPointsCount: session.dataPointsCount,
      // Store duration in seconds to match the model contract
      duration: now.difference(session.startTime).inSeconds,
      notes: '${session.notes}\nError: $errorMessage'.trim(),
      exportPath: session.exportPath,
      sensorTypes: session.sensorTypes,
    );

    await _repository.updateSession(updatedSession);
    return updatedSession;
  }

  /// Get all sessions for a lab
  Future<List<LabSession>> getLabSessions(String labId) async {
    return _repository.getSessionsByLabId(labId);
  }

  /// Get a single session
  Future<LabSession?> getSession(String sessionId) async {
    return _repository.getSessionById(sessionId);
  }

  /// Delete a session (and its data points)
  Future<void> deleteSession(String sessionId) async {
    await _repository.deleteSession(sessionId);
  }

  /// Get data points for a session
  Future<List<SensorDataPoint>> getSessionDataPoints(String sessionId) async {
    return _repository.getDataPointsBySessionId(sessionId);
  }
}
