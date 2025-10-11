import '../entities/activity_session.dart';
import '../entities/activity_type.dart';

/// Repository interface for Activity Session operations
/// This defines the contract for data persistence and retrieval
abstract class ActivitySessionRepository {
  /// Get active session (if any)
  Future<ActivitySession?> getActiveSession();

  /// Save activity session
  Future<void> saveActivitySession(ActivitySession session);

  /// Update activity session
  Future<void> updateActivitySession(ActivitySession session);

  /// Get session by ID
  Future<ActivitySession?> getSessionById(String sessionId);

  /// Get all sessions for a user
  Future<List<ActivitySession>> getUserSessions(String userId);

  /// Get sessions by date range
  Future<List<ActivitySession>> getSessionsByDateRange(
    DateTime start,
    DateTime end,
  );

  /// Get sessions by activity type
  Future<List<ActivitySession>> getSessionsByActivity(
    ActivityType activityType,
  );

  /// Delete session
  Future<void> deleteSession(String sessionId);

  /// Get session statistics
  Future<SessionStatistics> getSessionStatistics(
    String userId,
    DateTime start,
    DateTime end,
  );

  /// Check if there's an active session
  Future<bool> hasActiveSession();

  /// Complete session
  Future<void> completeSession(String sessionId);

  /// Cancel session
  Future<void> cancelSession(String sessionId);
}

/// Statistics model for session data analysis
class SessionStatistics {
  final int totalSessions;
  final int completedSessions;
  final Duration totalActiveTime;
  final int totalSteps;
  final double totalDistance;
  final double totalCalories;
  final Map<ActivityType, int> activityBreakdown;
  final double averageSessionDuration;
  final double averageCaloriesPerSession;

  const SessionStatistics({
    required this.totalSessions,
    required this.completedSessions,
    required this.totalActiveTime,
    required this.totalSteps,
    required this.totalDistance,
    required this.totalCalories,
    required this.activityBreakdown,
    required this.averageSessionDuration,
    required this.averageCaloriesPerSession,
  });

  double get completionRate =>
      totalSessions > 0 ? completedSessions / totalSessions : 0.0;
}
