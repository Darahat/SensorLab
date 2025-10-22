import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_repository_provider.dart';
import 'package:sensorlab/src/features/custom_lab/application/use_cases/record_session_use_case.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_data_point.dart';

/// Provider for RecordSessionUseCase
final recordSessionUseCaseProvider = Provider<RecordSessionUseCase>((ref) {
  final repository = ref.watch(labRepositoryProvider);
  return RecordSessionUseCase(repository);
});

/// State for recording session
class RecordingSessionState {
  final LabSession? activeSession;
  final bool isRecording;
  final bool isPaused;
  final bool isLoading;
  final String? errorMessage;
  final int elapsedSeconds;

  const RecordingSessionState({
    this.activeSession,
    this.isRecording = false,
    this.isPaused = false,
    this.isLoading = false,
    this.errorMessage,
    this.elapsedSeconds = 0,
  });

  RecordingSessionState copyWith({
    LabSession? activeSession,
    bool? isRecording,
    bool? isPaused,
    bool? isLoading,
    String? errorMessage,
    int? elapsedSeconds,
  }) {
    return RecordingSessionState(
      activeSession: activeSession ?? this.activeSession,
      isRecording: isRecording ?? this.isRecording,
      isPaused: isPaused ?? this.isPaused,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }
}

/// StateNotifier for recording session management
class RecordingSessionNotifier extends StateNotifier<RecordingSessionState> {
  final RecordSessionUseCase _useCase;
  Timer? _timer;

  RecordingSessionNotifier(this._useCase)
    : super(const RecordingSessionState());

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Start a new recording session
  Future<bool> startSession({required String labId, String? notes}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final session = await _useCase.startSession(labId: labId, notes: notes);

      state = state.copyWith(
        activeSession: session,
        isRecording: true,
        isPaused: false,
        isLoading: false,
        elapsedSeconds: 0,
      );

      _startTimer();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Pause the active recording session
  Future<bool> pauseSession() async {
    if (state.activeSession == null) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final session = await _useCase.pauseSession(state.activeSession!.id);

      state = state.copyWith(
        activeSession: session,
        isRecording: false,
        isPaused: true,
        isLoading: false,
      );

      _timer?.cancel();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Resume a paused recording session
  Future<bool> resumeSession() async {
    if (state.activeSession == null) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final session = await _useCase.resumeSession(state.activeSession!.id);

      state = state.copyWith(
        activeSession: session,
        isRecording: true,
        isPaused: false,
        isLoading: false,
      );

      _startTimer();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Stop the active recording session
  Future<bool> stopSession({String? additionalNotes}) async {
    if (state.activeSession == null) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final session = await _useCase.stopSession(
        sessionId: state.activeSession!.id,
        additionalNotes: additionalNotes,
      );

      state = state.copyWith(
        activeSession: session,
        isRecording: false,
        isPaused: false,
        isLoading: false,
      );

      _timer?.cancel();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Add a data point to the active session
  Future<void> addDataPoint(Map<String, dynamic> sensorValues) async {
    if (state.activeSession == null || !state.isRecording) {
      return;
    }

    try {
      await _useCase.addDataPoint(
        sessionId: state.activeSession!.id,
        sensorValues: sensorValues,
      );

      // Update the session with new data points count
      final updatedSession = state.activeSession!.copyWith(
        dataPointsCount: state.activeSession!.dataPointsCount + 1,
      );

      state = state.copyWith(activeSession: updatedSession);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Add multiple data points in batch
  Future<void> addDataPointsBatch(
    List<Map<String, dynamic>> sensorValuesList,
  ) async {
    if (state.activeSession == null || !state.isRecording) {
      return;
    }

    try {
      await _useCase.addDataPointsBatch(
        sessionId: state.activeSession!.id,
        sensorValuesList: sensorValuesList,
      );

      // Update the session with new data points count
      final updatedSession = state.activeSession!.copyWith(
        dataPointsCount:
            state.activeSession!.dataPointsCount + sensorValuesList.length,
      );

      state = state.copyWith(activeSession: updatedSession);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Mark the session as failed
  Future<void> markAsFailed(String errorMessage) async {
    if (state.activeSession == null) {
      return;
    }

    try {
      final session = await _useCase.markSessionAsFailed(
        sessionId: state.activeSession!.id,
        errorMessage: errorMessage,
      );

      state = state.copyWith(
        activeSession: session,
        isRecording: false,
        isPaused: false,
        errorMessage: errorMessage,
      );

      _timer?.cancel();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Clear the active session
  void clearSession() {
    _timer?.cancel();
    state = const RecordingSessionState();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Start the elapsed time timer
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isRecording && !state.isPaused) {
        state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
      }
    });
  }
}

/// Provider for recording session state
final recordingSessionProvider =
    StateNotifierProvider<RecordingSessionNotifier, RecordingSessionState>((
      ref,
    ) {
      final useCase = ref.watch(recordSessionUseCaseProvider);
      return RecordingSessionNotifier(useCase);
    });

/// Provider for getting sessions for a specific lab
final labSessionsProvider = FutureProvider.family<List<LabSession>, String>((
  ref,
  labId,
) async {
  final useCase = ref.watch(recordSessionUseCaseProvider);
  return useCase.getLabSessions(labId);
});

/// Provider for getting a single session
final sessionProvider = FutureProvider.family<LabSession?, String>((
  ref,
  sessionId,
) async {
  final useCase = ref.watch(recordSessionUseCaseProvider);
  return useCase.getSession(sessionId);
});

/// Provider for getting data points for a session
final sessionDataPointsProvider =
    FutureProvider.family<List<SensorDataPoint>, String>((
      ref,
      sessionId,
    ) async {
      final useCase = ref.watch(recordSessionUseCaseProvider);
      return useCase.getSessionDataPoints(sessionId);
    });
