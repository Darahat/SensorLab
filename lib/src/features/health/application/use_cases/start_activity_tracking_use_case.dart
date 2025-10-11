import '../../domain/entities/activity_session.dart';
import '../../domain/entities/activity_type.dart';
import '../../domain/repositories/activity_session_repository.dart';
import '../../domain/repositories/sensor_data_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';

/// Use Case: Start Activity Tracking
/// Contains specific business logic for starting an activity session
class StartActivityTrackingUseCase {
  final ActivitySessionRepository _sessionRepository;
  final SensorDataRepository _sensorRepository;
  final UserProfileRepository _userRepository;

  StartActivityTrackingUseCase(
    this._sessionRepository,
    this._sensorRepository,
    this._userRepository,
  );

  Future<StartActivityResult> execute(StartActivityParams params) async {
    try {
      // Business Rule: Check if there's already an active session
      final hasActiveSession = await _sessionRepository.hasActiveSession();
      if (hasActiveSession) {
        return StartActivityResult.failure(
          'There is already an active session',
        );
      }

      // Business Rule: Validate sensors are available
      final sensorsAvailable = await _sensorRepository.areSensorsAvailable();
      if (!sensorsAvailable) {
        return StartActivityResult.failure('Sensors are not available');
      }

      // Get user profile for calorie calculations
      final userProfile = await _userRepository.getCurrentUserProfile();
      if (userProfile == null) {
        return StartActivityResult.failure('User profile not found');
      }

      // Create new activity session
      final session = ActivitySession(
        id: _generateSessionId(),
        activityType: params.activityType,
        startTime: DateTime.now(),
        status: SessionStatus.active,
        goals: params.goals,
      );

      // Save session
      await _sessionRepository.saveActivitySession(session);

      return StartActivityResult.success(session);
    } catch (e) {
      return StartActivityResult.failure('Failed to start activity: $e');
    }
  }

  String _generateSessionId() {
    return 'session_${DateTime.now().millisecondsSinceEpoch}';
  }
}

class StartActivityParams {
  final ActivityType activityType;
  final Goals goals;

  StartActivityParams({required this.activityType, required this.goals});
}

class StartActivityResult {
  final bool isSuccess;
  final ActivitySession? session;
  final String? errorMessage;

  StartActivityResult._({
    required this.isSuccess,
    this.session,
    this.errorMessage,
  });

  factory StartActivityResult.success(ActivitySession session) {
    return StartActivityResult._(isSuccess: true, session: session);
  }

  factory StartActivityResult.failure(String message) {
    return StartActivityResult._(isSuccess: false, errorMessage: message);
  }
}
