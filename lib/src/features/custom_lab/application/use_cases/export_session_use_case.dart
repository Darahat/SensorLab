import 'dart:io';

import 'package:sensorlab/src/features/custom_lab/domain/repositories/lab_repository.dart';

/// Use case for exporting recording sessions to CSV
class ExportSessionUseCase {
  final LabRepository _repository;

  ExportSessionUseCase(this._repository);

  /// Export a session to CSV file
  Future<String> exportToCSV(String sessionId) async {
    final session = await _repository.getSessionById(sessionId);
    if (session == null) {
      throw Exception('Session not found: $sessionId');
    }

    final csvPath = await _repository.exportSessionToCSV(sessionId);

    // Update session with export path
    final updatedSession = session.copyWith(exportPath: csvPath);
    await _repository.updateSession(updatedSession);

    return csvPath;
  }

  /// Export a session and return the file path for sharing
  /// (UI layer can use share_plus or other sharing mechanism)
  Future<String> exportForSharing(String sessionId) async {
    final csvPath = await exportToCSV(sessionId);
    final file = File(csvPath);

    if (!await file.exists()) {
      throw Exception('Exported file not found');
    }

    return csvPath;
  }

  /// Get the export path for a session (if already exported)
  Future<String?> getExportPath(String sessionId) async {
    final session = await _repository.getSessionById(sessionId);
    return session?.exportPath;
  }

  /// Check if a session has been exported
  Future<bool> isSessionExported(String sessionId) async {
    final session = await _repository.getSessionById(sessionId);
    if (session == null) {
      return false;
    }

    if (session.exportPath == null) {
      return false;
    }

    // Check if file still exists
    final file = File(session.exportPath!);
    return await file.exists();
  }

  /// Delete exported CSV file
  Future<void> deleteExportedFile(String sessionId) async {
    final session = await _repository.getSessionById(sessionId);
    if (session == null || session.exportPath == null) {
      return;
    }

    final file = File(session.exportPath!);
    if (await file.exists()) {
      await file.delete();
    }

    // Update session to remove export path
    final updatedSession = session.copyWith(exportPath: null);
    await _repository.updateSession(updatedSession);
  }
}
