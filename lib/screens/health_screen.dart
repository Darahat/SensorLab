import 'package:flutter/material.dart';
import 'package:sensorlab/services/profile_manager.dart';
import 'package:sensorlab/widgets/user_profile/profile_editor.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/health_data.dart';
import '../services/movement_tracker.dart';
import '../services/calorie_calculator.dart';
import '../widgets/calorie_burn/activity_selector.dart';
import '../widgets/calorie_burn/tracking_controls.dart';
import '../widgets/calorie_burn/sensor_display.dart';
import '../widgets/calorie_burn/calorie_display.dart';
import '../models/activity_type.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  final HealthData _healthData = HealthData();
  late MovementTracker _movementTracker;
  UserAccelerometerEvent? _lastAccelEvent;
  final ProfileManager _profileManager = ProfileManager();

  GyroscopeEvent? _lastGyroEvent;

  @override
  void initState() {
    super.initState();
    _loadProfile();

    _movementTracker = MovementTracker(_healthData.selectedActivity);
    _startTracking();
  }

  void _startTracking() {
    _movementTracker.startTracking(
      onAccelerometer: (event) {
        setState(() => _lastAccelEvent = event);
        _analyzeMovement();
      },
      onGyroscope: (event) {
        setState(() => _lastGyroEvent = event);
      },
      onSteps: (steps) {
        setState(() => _healthData.steps = steps);
        _updateCalories();
      },
    );
  }

  void _analyzeMovement() {
    if (_lastAccelEvent == null) return;

    final accel = _lastAccelEvent!;
    final movementScore = accel.x.abs() + accel.z.abs();

    // Activity-specific analysis would go here
  }

  void _updateCalories() {
    setState(() {
      _healthData.caloriesBurned = CalorieCalculator.calculate(
        _healthData,
      ); // Now correct
    });
  }

  void _toggleTracking() {
    setState(() {
      _healthData.isTracking = !_healthData.isTracking;
      if (_healthData.isTracking) {
        _healthData.trackingStartTime = DateTime.now();
        _healthData.steps = 0;
        _healthData.caloriesBurned = 0;
      }
    });
  }

  Future<void> _loadProfile() async {
    final profile = await _profileManager.loadProfile();
    setState(() {
      _healthData
        ..name = profile.name
        ..weightKg = profile.weightKg
        ..heightCm = profile.heightCm
        ..age = profile.age
        ..gender = profile.gender;
    });
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ProfileEditor(
              initialData: _healthData,
              onSave: (newData) async {
                await _profileManager.saveProfile(newData as HealthData);
                setState(
                  () =>
                      _healthData
                        ..name = newData.name
                        ..weightKg = newData.weightKg
                        ..heightCm = newData.heightCm
                        ..age = newData.age
                        ..gender = newData.gender,
                );
                _updateCalories();
              },
            ),
      ),
    );
  }

  void _changeActivity(ActivityType newType) {
    setState(() {
      _movementTracker.stopTracking();
      _healthData.selectedActivity = newType;
      _movementTracker = MovementTracker(newType);
      if (_healthData.isTracking) _startTracking();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_healthData.name),
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: _editProfile),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text('${_healthData.age} years • ${_healthData.gender}'),
              subtitle: Text(
                '${_healthData.weightKg.toStringAsFixed(1)}kg • '
                '${_healthData.heightFeet.toInt()}ft ${_healthData.heightInches.toInt()}in',
              ),
              trailing: Chip(
                label: Text(_healthData.bmiCategory),
                backgroundColor: _getBmiColor(_healthData.bmi),
              ),
            ),
            ActivitySelector(
              currentActivity: _healthData.selectedActivity,
              onChanged: _changeActivity,
            ),
            const SizedBox(height: 20),
            TrackingControls(
              isTracking: _healthData.isTracking,
              onPressed: _toggleTracking,
            ),
            const SizedBox(height: 20),
            SensorDisplay(
              accelEvent: _lastAccelEvent,
              gyroEvent: _lastGyroEvent,
              steps: _healthData.steps,
            ),
            const SizedBox(height: 20),
            CalorieDisplay(
              calories: _healthData.caloriesBurned,
              activity: _healthData.selectedActivity,
            ),
          ],
        ),
      ),
    );
  }

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    _movementTracker.stopTracking();
    super.dispose();
  }
}
