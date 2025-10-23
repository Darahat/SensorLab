import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedometer/pedometer.dart';

import '../../models/pedometer_data.dart';

class PedometerNotifier extends StateNotifier<PedometerData> {
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;
  // Removed initial step baseline field; using state.previousSteps instead
  bool _isInitialized = false;

  PedometerNotifier() : super(PedometerData()) {
    _startListening();
  }

  void _startListening() {
    // Listen to step count stream
    _stepCountSubscription = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
      cancelOnError: false,
    );

    // Listen to pedestrian status stream
    _pedestrianStatusSubscription = Pedometer.pedestrianStatusStream.listen(
      _onPedestrianStatusChanged,
      onError: _onPedestrianStatusError,
      cancelOnError: false,
    );
  }

  void _onStepCount(StepCount event) {
    // Initialize on first event
    if (!_isInitialized) {
      _isInitialized = true;
      state = state.copyWith(previousSteps: event.steps, isActive: true);
      return;
    }

    // Update steps
    state = state.updateSteps(event.steps);
  }

  void _onStepCountError(dynamic error) {
    // Handle errors (e.g., permission denied, sensor not available)
    state = state.copyWith(isActive: false);
  }

  void _onPedestrianStatusChanged(PedestrianStatus event) {
    // Update activity status based on pedestrian status
    final isWalking = event.status == 'walking';
    if (!isWalking && state.isActive) {
      // User stopped walking
      state = state.copyWith(lastStepTime: DateTime.now());
    }
  }

  void _onPedestrianStatusError(dynamic error) {
    // Handle pedestrian status errors silently
  }

  /// Set daily step goal
  void setDailyGoal(int goal) {
    if (goal > 0) {
      state = state.setDailyGoal(goal);
    }
  }

  /// Reset the step counter (start new session)
  void reset() {
    _isInitialized = false;
    state = PedometerData(
      dailyGoal: state.dailyGoal,
      startTime: DateTime.now(),
    );
  }

  /// Pause tracking (useful for UI purposes)
  void pause() {
    state = state.copyWith(isActive: false);
  }

  /// Resume tracking
  void resume() {
    state = state.copyWith(isActive: true);
  }

  @override
  void dispose() {
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    super.dispose();
  }
}

final pedometerProvider =
    StateNotifierProvider<PedometerNotifier, PedometerData>(
      (ref) => PedometerNotifier(),
    );
