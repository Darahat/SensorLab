import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/health/domain/entities/activity_session.dart';
import 'package:sensorlab/src/features/health/domain/entities/activity_type.dart';
import 'package:sensorlab/src/features/health/domain/entities/user_profile.dart'
    as domain;
import 'package:sensorlab/src/features/health/domain/repositories/activity_session_repository.dart';
import 'package:sensorlab/src/features/health/domain/repositories/user_profile_repository.dart';
import 'package:sensorlab/src/features/health/infrastructure/providers.dart';
import 'package:sensorlab/src/features/health/models/health_data.dart';
import 'package:sensors_plus/sensors_plus.dart';

final healthProvider = StateNotifierProvider<HealthProvider, HealthData>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final activitySessionRepository = ref.watch(
    activitySessionRepositoryProvider,
  );
  return HealthProvider(userProfileRepository, activitySessionRepository);
});

class HealthProvider extends StateNotifier<HealthData> {
  final UserProfileRepository _userProfileRepository;
  final ActivitySessionRepository _activitySessionRepository;

  HealthProvider(this._userProfileRepository, this._activitySessionRepository)
    : super(
        HealthData(
          profile: domain.UserProfile(
            id: '1',
            name: 'User',
            age: 30,
            weight: 70.0,
            height: 175.0,
            gender: domain.Gender.male,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ),
      ) {
    initialize();
  }

  // Stream subscriptions
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  // Timers
  Timer? _sessionTimer;
  Timer? _activeTimeTimer;

  // Movement tracking
  DateTime? _lastMovementTime;
  double _lastIntensity = 0.0;
  final List<double> _intensityBuffer = [];
  static const int _bufferSize = 10;
  static const double _movementThreshold = 0.1;
  static const Duration _activeTimeThreshold = Duration(seconds: 2);

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }

  // Initialize health tracking
  Future<void> initialize() async {
    final profile = await _userProfileRepository.getCurrentUserProfile();
    if (profile != null) {
      state = state.copyWith(profile: profile, isInitialized: true);
    } else {
      final defaultProfile = await _userProfileRepository.createDefaultProfile(
        'User',
        30,
        70.0,
        175.0,
        domain.Gender.male,
      );
      state = state.copyWith(profile: defaultProfile, isInitialized: true);
    }

    final activeSession = await _activitySessionRepository.getActiveSession();
    if (activeSession != null) {
      state = state.copyWith(
        sessionState: HealthSessionState.tracking,
        isTracking: true,
      );
      resumeTracking();
    }
  }

  // Profile management
  Future<void> updateProfile(domain.UserProfile profile) async {
    await _userProfileRepository.updateUserProfile(profile);
    state = state.copyWith(profile: profile);
    _recalculateCalories();
  }

  // Activity selection
  void setActivity(ActivityType activity) {
    state = state.copyWith(selectedActivity: activity);
    _recalculateCalories();
  }

  // Session control
  Future<void> startTracking() async {
    if (state.isTracking) return;

    try {
      final session = ActivitySession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        activityType: state.selectedActivity,
        startTime: DateTime.now(),
        status: SessionStatus.active,
        goals: Goals(
          targetSteps: state.targetSteps,
          targetCalories: state.targetCalories,
          targetDuration: state.targetDuration,
        ),
      );
      await _activitySessionRepository.saveActivitySession(session);

      // Start sensor subscriptions
      _accelerometerSubscription = userAccelerometerEventStream().listen(
        _handleAccelerometerData,
        onError: (error) {
          state = state.copyWith(errorMessage: 'Accelerometer error: $error');
        },
      );

      _gyroscopeSubscription = gyroscopeEventStream().listen(
        _handleGyroscopeData,
        onError: (error) {
          state = state.copyWith(errorMessage: 'Gyroscope error: $error');
        },
      );

      // Start session timer
      _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateSessionDuration();
      });

      state = state.copyWith(
        isTracking: true,
        sessionState: HealthSessionState.tracking,
        sessionStartTime: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to start tracking: $e');
    }
  }

  Future<void> pauseTracking() async {
    if (!state.isTracking) return;

    _stopSensors();
    _sessionTimer?.cancel();
    _activeTimeTimer?.cancel();

    final activeSession = await _activitySessionRepository.getActiveSession();
    if (activeSession != null) {
      await _activitySessionRepository.updateActivitySession(
        activeSession.copyWith(status: SessionStatus.paused),
      );
    }

    state = state.copyWith(sessionState: HealthSessionState.paused);
  }

  Future<void> resumeTracking() async {
    if (state.sessionState != HealthSessionState.paused) return;

    final activeSession = await _activitySessionRepository.getActiveSession();
    if (activeSession != null) {
      await _activitySessionRepository.updateActivitySession(
        activeSession.copyWith(status: SessionStatus.active),
      );
      startTracking();
    }
  }

  Future<void> stopTracking() async {
    _stopSensors();
    _sessionTimer?.cancel();
    _activeTimeTimer?.cancel();

    final activeSession = await _activitySessionRepository.getActiveSession();
    if (activeSession != null) {
      await _activitySessionRepository.completeSession(activeSession.id);
    }

    state = state.copyWith(
      isTracking: false,
      sessionState: HealthSessionState.idle,
    );
  }

  Future<void> resetSession() async {
    await stopTracking();

    state = HealthData(
      profile: state.profile,
      selectedActivity: state.selectedActivity,
      targetSteps: state.targetSteps,
      targetCalories: state.targetCalories,
      targetDuration: state.targetDuration,
      isInitialized: state.isInitialized,
      sessionStartTime: DateTime.now(),
    );
  }

  // Goal setting
  void setStepsGoal(int steps) {
    state = state.copyWith(targetSteps: steps);
  }

  void setCaloriesGoal(double calories) {
    state = state.copyWith(targetCalories: calories);
  }

  void setDurationGoal(Duration duration) {
    state = state.copyWith(targetDuration: duration);
  }

  // Manual step increment (for testing or manual entry)
  void incrementSteps([int count = 1]) {
    final newSteps = state.steps + count;
    final newDistance = _calculateDistance(newSteps);

    state = state.copyWith(steps: newSteps, distance: newDistance);

    _recalculateCalories();
  }

  // Private methods
  void _stopSensors() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription = null;
    _gyroscopeSubscription = null;
  }

  void _handleAccelerometerData(UserAccelerometerEvent event) {
    if (!state.isTracking) return;

    // Calculate movement intensity
    final intensity = _calculateMovementIntensity(event);
    _intensityBuffer.add(intensity);

    if (_intensityBuffer.length > _bufferSize) {
      _intensityBuffer.removeAt(0);
    }

    // Detect steps based on intensity peaks
    if (_detectStep(intensity)) {
      incrementSteps();
    }

    // Update movement data
    final movementData = MovementData(
      timestamp: DateTime.now(),
      x: event.x,
      y: event.y,
      z: event.z,
      intensity: intensity,
    );

    final updatedHistory = List<MovementData>.from(state.movementHistory);
    updatedHistory.add(movementData);

    // Keep only last 100 movements
    if (updatedHistory.length > 100) {
      updatedHistory.removeAt(0);
    }

    // Calculate statistics
    final avgIntensity = _calculateAverageIntensity();
    final peakIntensity = _calculatePeakIntensity();

    state = state.copyWith(
      currentMovement: movementData,
      movementHistory: updatedHistory,
      averageIntensity: avgIntensity,
      peakIntensity: peakIntensity,
      movementCount: state.movementCount + 1,
    );

    // Track active time
    _updateActiveTime(intensity);
  }

  void _handleGyroscopeData(GyroscopeEvent event) {
    if (!state.isTracking) return;

    // Update current movement with gyroscope data
    // state = state.copyWith(
    //   currentMovement: state.currentMovement!.copyWith(gyroscope: event),
    // );
  }

  double _calculateMovementIntensity(UserAccelerometerEvent event) {
    // Calculate total acceleration magnitude
    final magnitude = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );

    // Normalize to 0-1 range (assuming max meaningful acceleration of 4g)
    return (magnitude / 4.0).clamp(0.0, 1.0);
  }

  bool _detectStep(double intensity) {
    // Simple step detection using intensity threshold and timing
    if (intensity > _movementThreshold) {
      final now = DateTime.now();
      if (_lastMovementTime == null ||
          now.difference(_lastMovementTime!) >
              const Duration(milliseconds: 500)) {
        _lastMovementTime = now;
        return intensity > _lastIntensity * 1.2; // 20% increase threshold
      }
    }
    _lastIntensity = intensity;
    return false;
  }

  double _calculateAverageIntensity() {
    if (_intensityBuffer.isEmpty) return 0.0;
    return _intensityBuffer.reduce((a, b) => a + b) / _intensityBuffer.length;
  }

  double _calculatePeakIntensity() {
    if (_intensityBuffer.isEmpty) return 0.0;
    return _intensityBuffer.reduce((a, b) => a > b ? a : b);
  }

  void _updateActiveTime(double intensity) {
    if (intensity > _movementThreshold) {
      _activeTimeTimer?.cancel();
      _activeTimeTimer = Timer(_activeTimeThreshold, () {
        // Add active time
        state = state.copyWith(
          totalActiveTime: state.totalActiveTime + const Duration(seconds: 1),
        );
      });
    }
  }

  void _updateSessionDuration() {
    final now = DateTime.now();
    final duration = now.difference(state.sessionStartTime);

    state = state.copyWith(sessionDuration: duration);
  }

  double _calculateDistance(int steps) {
    // Average step length based on height (rough estimation)
    final stepLength = (state.profile.height * 0.415) / 100; // meters
    return steps * stepLength;
  }

  void _recalculateCalories() {
    if (state.totalActiveTime.inMinutes == 0) return;

    // Calculate calories based on activity and user profile
    final activityFactor = state.selectedActivity.calorieFactor;
    final timeInHours = state.totalActiveTime.inMinutes / 60.0;
    final bodyWeight = state.profile.weight;

    // METs calculation: Calories = METs × weight × time
    final calories = activityFactor * bodyWeight * timeInHours;

    state = state.copyWith(caloriesBurned: calories);
  }

  // Quick actions for testing/demonstration
  void simulateWorkout() {
    if (state.isTracking) return;

    startTracking();

    // Simulate 5 minutes of activity
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick > 300 || !state.isTracking) {
        timer.cancel();
        return;
      }

      // Simulate steps
      if (timer.tick % 2 == 0) {
        incrementSteps();
      }

      // Simulate movement data
      final simulatedAccel = UserAccelerometerEvent(
        Random().nextDouble() * 2 - 1,
        Random().nextDouble() * 2 - 1,
        Random().nextDouble() * 2 - 1,
        DateTime.now(),
      );

      _handleAccelerometerData(simulatedAccel);
    });
  }

  void quickStepTest() {
    // Add 100 steps for testing
    incrementSteps(100);
  }
}
