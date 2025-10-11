import '../../domain/entities/activity_session.dart';
import '../../domain/repositories/activity_session_repository.dart';

/// Use Case: Track Movement Data
/// Handles the business logic for processing sensor data and updating session
class TrackMovementDataUseCase {
  final ActivitySessionRepository _sessionRepository;

  TrackMovementDataUseCase(this._sessionRepository);

  Future<TrackMovementResult> execute(TrackMovementParams params) async {
    try {
      // Business Rule: Must have an active session
      final activeSession = await _sessionRepository.getActiveSession();
      if (activeSession == null) {
        return TrackMovementResult.failure('No active session found');
      }

      // Business Logic: Process movement data
      final processedMovement = _processMovementData(
        params.movementData,
        activeSession,
      );

      // Business Logic: Detect if this is a step
      final isStep = _detectStep(params.movementData, activeSession.movements);

      // Business Logic: Calculate new session metrics
      final updatedSession = _updateSessionMetrics(
        activeSession,
        processedMovement.copyWith(isStep: isStep),
      );

      // Save updated session
      await _sessionRepository.updateActivitySession(updatedSession);

      return TrackMovementResult.success(updatedSession, processedMovement);
    } catch (e) {
      return TrackMovementResult.failure('Failed to track movement: $e');
    }
  }

  MovementData _processMovementData(
    MovementData rawData,
    ActivitySession session,
  ) {
    // Business Logic: Calculate movement intensity
    final intensity = _calculateMovementIntensity(rawData);

    return rawData.copyWith(intensity: intensity);
  }

  double _calculateMovementIntensity(MovementData data) {
    // Business Algorithm: Calculate intensity from accelerometer magnitude
    final magnitude = data.magnitude;

    // Normalize to 0-1 range (assuming max meaningful acceleration of 4g)
    return (magnitude / 16.0).clamp(0.0, 1.0);
  }

  bool _detectStep(MovementData currentData, List<MovementData> history) {
    // Business Algorithm: Simple step detection
    if (history.length < 5) return false;

    const double stepThreshold = 2.0;
    const Duration minStepInterval = Duration(milliseconds: 300);

    // Check if magnitude crosses threshold
    if (currentData.magnitude < stepThreshold) return false;

    // Check timing since last step
    final lastStep = history.lastWhere(
      (data) => data.isStep,
      orElse:
          () => MovementData(
            timestamp: DateTime.now().subtract(Duration(seconds: 1)),
            x: 0,
            y: 0,
            z: 0,
            intensity: 0,
          ),
    );

    final timeSinceLastStep = currentData.timestamp.difference(
      lastStep.timestamp,
    );
    return timeSinceLastStep >= minStepInterval;
  }

  ActivitySession _updateSessionMetrics(
    ActivitySession session,
    MovementData newMovement,
  ) {
    // Business Logic: Update movement history
    final updatedMovements = [...session.movements, newMovement];
    if (updatedMovements.length > 1000) {
      updatedMovements.removeAt(0); // Keep last 1000 movements
    }

    // Business Logic: Update step count
    final newSteps = newMovement.isStep ? session.steps + 1 : session.steps;

    // Business Logic: Calculate distance (rough estimation)
    final newDistance = _calculateDistance(newSteps);

    // Business Logic: Calculate calories
    final newCalories = _calculateCalories(session, newDistance);

    // Business Logic: Update intensity metrics
    final intensities = updatedMovements.map((m) => m.intensity).toList();
    final avgIntensity =
        intensities.isNotEmpty
            ? intensities.reduce((a, b) => a + b) / intensities.length
            : 0.0;
    final peakIntensity =
        intensities.isNotEmpty
            ? intensities.reduce((a, b) => a > b ? a : b)
            : 0.0;

    return session.copyWith(
      movements: updatedMovements,
      steps: newSteps,
      distance: newDistance,
      calories: newCalories,
      averageIntensity: avgIntensity,
      peakIntensity: peakIntensity,
    );
  }

  double _calculateDistance(int steps) {
    // Business Logic: Average step length estimation
    const double averageStepLength = 0.7; // meters
    return steps * averageStepLength;
  }

  double _calculateCalories(ActivitySession session, double distance) {
    // Business Logic: Calorie calculation based on activity and distance
    // This is a simplified calculation - would need user weight for accuracy
    const double caloriesPerKm = 60.0; // rough estimate
    return (distance / 1000) *
        caloriesPerKm *
        session.activityType.metValue /
        3.5;
  }
}

class TrackMovementParams {
  final MovementData movementData;

  TrackMovementParams({required this.movementData});
}

class TrackMovementResult {
  final bool isSuccess;
  final ActivitySession? updatedSession;
  final MovementData? processedMovement;
  final String? errorMessage;

  TrackMovementResult._({
    required this.isSuccess,
    this.updatedSession,
    this.processedMovement,
    this.errorMessage,
  });

  factory TrackMovementResult.success(
    ActivitySession session,
    MovementData movement,
  ) {
    return TrackMovementResult._(
      isSuccess: true,
      updatedSession: session,
      processedMovement: movement,
    );
  }

  factory TrackMovementResult.failure(String message) {
    return TrackMovementResult._(isSuccess: false, errorMessage: message);
  }
}
