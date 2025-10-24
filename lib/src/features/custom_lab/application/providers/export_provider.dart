import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_repository_provider.dart';
import 'package:sensorlab/src/features/custom_lab/application/use_cases/export_session_use_case.dart';

/// Provider for ExportSessionUseCase
final exportSessionUseCaseProvider = Provider<ExportSessionUseCase>((ref) {
  final repository = ref.watch(labRepositoryProvider);
  return ExportSessionUseCase(repository);
});

/// State for export operations
class ExportState {
  final bool isExporting;
  final String? exportedFilePath;
  final String? errorMessage;

  const ExportState({
    this.isExporting = false,
    this.exportedFilePath,
    this.errorMessage,
  });

  ExportState copyWith({
    bool? isExporting,
    String? exportedFilePath,
    String? errorMessage,
  }) {
    return ExportState(
      isExporting: isExporting ?? this.isExporting,
      exportedFilePath: exportedFilePath,
      errorMessage: errorMessage,
    );
  }
}

/// StateNotifier for export operations
class ExportNotifier extends StateNotifier<ExportState> {
  final ExportSessionUseCase _useCase;

  ExportNotifier(this._useCase) : super(const ExportState());

  /// Export a session to CSV
  Future<String?> exportSession(String sessionId) async {
    state = state.copyWith(isExporting: true, errorMessage: null);

    try {
      final csvPath = await _useCase.exportToCSV(sessionId);
      state = state.copyWith(isExporting: false, exportedFilePath: csvPath);
      return csvPath;
    } catch (e) {
      state = state.copyWith(isExporting: false, errorMessage: e.toString());
      return null;
    }
  }

  /// Export a session for sharing
  Future<String?> exportForSharing(String sessionId) async {
    state = state.copyWith(isExporting: true, errorMessage: null);

    try {
      final csvPath = await _useCase.exportForSharing(sessionId);
      state = state.copyWith(isExporting: false, exportedFilePath: csvPath);
      return csvPath;
    } catch (e) {
      state = state.copyWith(isExporting: false, errorMessage: e.toString());
      return null;
    }
  }

  Future<String?> exportMultipleForSharing(
    String labId,
    List<String> sessionIds,
  ) async {
    state = state.copyWith(isExporting: true, errorMessage: null);

    try {
      final filePath = await _useCase.exportMultipleForSharing(
        labId,
        sessionIds,
      );
      state = state.copyWith(isExporting: false, exportedFilePath: filePath);
      return filePath;
    } catch (e) {
      state = state.copyWith(isExporting: false, errorMessage: e.toString());
      return null;
    }
  }

  /// Delete an exported file
  Future<bool> deleteExportedFile(String sessionId) async {
    try {
      await _useCase.deleteExportedFile(sessionId);
      state = state.copyWith(exportedFilePath: null);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// Clear export state
  void clear() {
    state = const ExportState();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for export state
final exportProvider = StateNotifierProvider<ExportNotifier, ExportState>((
  ref,
) {
  final useCase = ref.watch(exportSessionUseCaseProvider);
  return ExportNotifier(useCase);
});

/// Provider to check if a session is exported
final isSessionExportedProvider = FutureProvider.family<bool, String>((
  ref,
  sessionId,
) async {
  final useCase = ref.watch(exportSessionUseCaseProvider);
  return useCase.isSessionExported(sessionId);
});

/// Provider to get export path for a session
final sessionExportPathProvider = FutureProvider.family<String?, String>((
  ref,
  sessionId,
) async {
  final useCase = ref.watch(exportSessionUseCaseProvider);
  return useCase.getExportPath(sessionId);
});
