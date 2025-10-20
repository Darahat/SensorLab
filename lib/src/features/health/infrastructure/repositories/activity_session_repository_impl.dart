import 'package:hive_flutter/hive_flutter.dart';
import 'package:sensorlab/src/features/health/domain/entities/activity_session.dart';
import 'package:sensorlab/src/features/health/domain/entities/activity_type.dart';
import 'package:sensorlab/src/features/health/domain/repositories/activity_session_repository.dart';

class ActivitySessionRepositoryImpl implements ActivitySessionRepository {
  final Box<ActivitySession> _sessionBox;

  ActivitySessionRepositoryImpl(this._sessionBox);

  @override
  Future<void> cancelSession(String sessionId) async {
    final session = await getSessionById(sessionId);
    if (session != null) {
      await updateActivitySession(
        session.copyWith(status: SessionStatus.cancelled),
      );
    }
  }

  @override
  Future<void> completeSession(String sessionId) async {
    final session = await getSessionById(sessionId);
    if (session != null) {
      await updateActivitySession(
        session.copyWith(
          status: SessionStatus.completed,
          endTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await _sessionBox.delete(sessionId);
  }

  @override
  Future<ActivitySession?> getActiveSession() async {
    try {
      return _sessionBox.values.firstWhere(
        (session) => session.status == SessionStatus.active,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ActivitySession>> getSessionsByActivity(
    ActivityType activityType,
  ) async {
    return _sessionBox.values
        .where((session) => session.activityType == activityType)
        .toList();
  }

  @override
  Future<List<ActivitySession>> getSessionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return _sessionBox.values
        .where(
          (session) =>
              session.startTime.isAfter(start) &&
              session.startTime.isBefore(end),
        )
        .toList();
  }

  @override
  Future<ActivitySession?> getSessionById(String sessionId) async {
    return _sessionBox.get(sessionId);
  }

  @override
  Future<SessionStatistics> getSessionStatistics(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final sessions = await getUserSessions(userId);
    final sessionsInDateRange = sessions
        .where((s) => s.startTime.isAfter(start) && s.startTime.isBefore(end))
        .toList();

    final totalSessions = sessionsInDateRange.length;
    final completedSessions = sessionsInDateRange
        .where((s) => s.status == SessionStatus.completed)
        .length;
    final totalActiveTime = sessionsInDateRange.fold<Duration>(
      Duration.zero,
      (p, s) => p + s.activeDuration,
    );
    final totalSteps = sessionsInDateRange.fold<int>(0, (p, s) => p + s.steps);
    final totalDistance = sessionsInDateRange.fold<double>(
      0,
      (p, s) => p + s.distance,
    );
    final totalCalories = sessionsInDateRange.fold<double>(
      0,
      (p, s) => p + s.calories,
    );

    final activityBreakdown = <ActivityType, int>{};
    for (final session in sessionsInDateRange) {
      activityBreakdown.update(
        session.activityType,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    final averageSessionDuration = totalSessions > 0
        ? totalActiveTime.inMinutes / totalSessions
        : 0.0;
    final averageCaloriesPerSession = totalSessions > 0
        ? totalCalories / totalSessions
        : 0.0;

    return SessionStatistics(
      totalSessions: totalSessions,
      completedSessions: completedSessions,
      totalActiveTime: totalActiveTime,
      totalSteps: totalSteps,
      totalDistance: totalDistance,
      totalCalories: totalCalories,
      activityBreakdown: activityBreakdown,
      averageSessionDuration: averageSessionDuration,
      averageCaloriesPerSession: averageCaloriesPerSession,
    );
  }

  @override
  Future<List<ActivitySession>> getUserSessions(String userId) async {
    // Since we are not implementing multi-user, we return all sessions.
    return _sessionBox.values.toList();
  }

  @override
  Future<bool> hasActiveSession() async {
    return await getActiveSession() != null;
  }

  @override
  Future<void> saveActivitySession(ActivitySession session) async {
    await _sessionBox.put(session.id, session);
  }

  @override
  Future<void> updateActivitySession(ActivitySession session) async {
    await saveActivitySession(session);
  }
}
