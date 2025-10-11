import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../domain/entities/activity_type.dart';
import '../../domain/entities/user_profile.dart' as domain;
import '../../models/health_data.dart';

// Provider for the health provider (we'll fix the import later)
final healthProvider = StateNotifierProvider<HealthNotifier, HealthData>((ref) {
  return HealthNotifier();
});

// Temporary simple notifier - we'll connect to the real one later
class HealthNotifier extends StateNotifier<HealthData> {
  HealthNotifier() : super(_createInitialState());

  static HealthData _createInitialState() {
    final defaultProfile = domain.UserProfile(
      id: '1',
      name: 'User',
      age: 30,
      weight: 70.0,
      height: 175.0,
      gender: domain.Gender.male,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return HealthData(
      profile: defaultProfile,
      selectedActivity: ActivityType.walking,
      sessionState: HealthSessionState.idle,
      currentMovement: null,
      movementHistory: [],
      sessionStartTime: DateTime.now(),
      sessionDuration: Duration.zero,
      totalActiveTime: Duration.zero,
      steps: 0,
      distance: 0.0,
      caloriesBurned: 0.0,
      averageIntensity: 0.0,
      peakIntensity: 0.0,
      movementCount: 0,
      targetSteps: 10000,
      targetCalories: 300.0,
      targetDuration: const Duration(hours: 1),
      errorMessage: null,
    );
  }

  void updateSelectedActivity(ActivityType activity) {
    state = state.copyWith(selectedActivity: activity);
  }

  void startSession() {
    state = state.copyWith(
      sessionState: HealthSessionState.tracking,
      sessionStartTime: DateTime.now(),
    );
  }

  void stopSession() {
    state = state.copyWith(sessionState: HealthSessionState.idle);
  }

  void pauseSession() {
    state = state.copyWith(sessionState: HealthSessionState.paused);
  }

  void resetSession() {
    state = state.copyWith(
      sessionState: HealthSessionState.idle,
      steps: 0,
      distance: 0.0,
      caloriesBurned: 0.0,
      sessionDuration: Duration.zero,
      totalActiveTime: Duration.zero,
      movementHistory: [],
      currentMovement: null,
    );
  }

  void updateProfile(domain.UserProfile profile) {
    state = state.copyWith(profile: profile);
  }
}

class HealthScreen extends ConsumerStatefulWidget {
  const HealthScreen({super.key});

  @override
  ConsumerState<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen> {
  @override
  Widget build(BuildContext context) {
    final healthData = ref.watch(healthProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Health Tracker',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Iconsax.user, color: colorScheme.primary),
            onPressed: _showProfileEditor,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(healthData, colorScheme),
              const SizedBox(height: 16),
              _buildQuickStats(healthData, colorScheme),
              const SizedBox(height: 24),
              _buildActivitySelector(healthData, colorScheme),
              const SizedBox(height: 16),
              _buildTrackingControls(healthData, colorScheme),
              const SizedBox(height: 16),
              if (healthData.sessionState == HealthSessionState.tracking) ...[
                _buildSensorDisplay(healthData, colorScheme),
                const SizedBox(height: 16),
              ],
              _buildCalorieDisplay(healthData, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(HealthData healthData, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${healthData.profile.name}!',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ready to track your ${healthData.selectedActivity.displayName.toLowerCase()} session?',
            style: TextStyle(
              color: colorScheme.onPrimary.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildProfileStat(
                'BMI',
                healthData.profile.bmi.toStringAsFixed(1),
                colorScheme,
              ),
              const SizedBox(width: 20),
              _buildProfileStat(
                'BMR',
                '${healthData.profile.basalMetabolicRate.toInt()} cal',
                colorScheme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(
    String label,
    String value,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onPrimary.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(HealthData healthData, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Steps',
            '${healthData.steps}',
            '/ ${healthData.targetSteps}',
            Iconsax.activity,
            colorScheme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Distance',
            (healthData.distance / 1000).toStringAsFixed(2),
            'km',
            Iconsax.location,
            colorScheme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Duration',
            _formatDuration(healthData.sessionDuration),
            '',
            Iconsax.clock,
            colorScheme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    String suffix,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (suffix.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(
                  suffix,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySelector(
    HealthData healthData,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                ActivityType.values.map((activity) {
                  final isSelected = healthData.selectedActivity == activity;
                  return GestureDetector(
                    onTap: () => _onActivityChanged(activity),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? colorScheme.primary
                                : colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected
                                  ? colorScheme.primary
                                  : colorScheme.outline,
                        ),
                      ),
                      child: Text(
                        activity.displayName,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingControls(
    HealthData healthData,
    ColorScheme colorScheme,
  ) {
    final isTracking = healthData.sessionState == HealthSessionState.tracking;
    final isPaused = healthData.sessionState == HealthSessionState.paused;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _onStartStopTracking,
              icon: Icon(isTracking ? Iconsax.stop : Iconsax.play),
              label: Text(
                isTracking ? 'Stop' : (isPaused ? 'Resume' : 'Start'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isTracking ? colorScheme.error : colorScheme.primary,
                foregroundColor:
                    isTracking ? colorScheme.onError : colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (isTracking) ...[
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _onPauseTracking,
              icon: const Icon(Iconsax.pause),
              label: const Text('Pause'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _onResetSession,
            icon: const Icon(Iconsax.refresh),
            label: const Text('Reset'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.outline,
              foregroundColor: colorScheme.onSurface,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorDisplay(HealthData healthData, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live Sensor Data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSensorStat(
                  'Avg Intensity',
                  healthData.averageIntensity.toStringAsFixed(2),
                  colorScheme,
                ),
              ),
              Expanded(
                child: _buildSensorStat(
                  'Peak Intensity',
                  healthData.peakIntensity.toStringAsFixed(2),
                  colorScheme,
                ),
              ),
              Expanded(
                child: _buildSensorStat(
                  'Movements',
                  '${healthData.movementCount}',
                  colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSensorStat(String label, String value, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildCalorieDisplay(HealthData healthData, ColorScheme colorScheme) {
    final progress =
        healthData.targetCalories > 0
            ? (healthData.caloriesBurned / healthData.targetCalories).clamp(
              0.0,
              1.0,
            )
            : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calories Burned',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '${healthData.caloriesBurned.toInt()} / ${healthData.targetCalories.toInt()}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: colorScheme.outline.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
          const SizedBox(height: 12),
          Text(
            'BMR: ${healthData.profile.basalMetabolicRate.toInt()} cal/day',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  void _onActivityChanged(ActivityType activity) {
    ref.read(healthProvider.notifier).updateSelectedActivity(activity);
  }

  void _onStartStopTracking() {
    final currentState = ref.read(healthProvider).sessionState;
    if (currentState == HealthSessionState.tracking) {
      ref.read(healthProvider.notifier).stopSession();
    } else {
      ref.read(healthProvider.notifier).startSession();
    }
  }

  void _onPauseTracking() {
    ref.read(healthProvider.notifier).pauseSession();
  }

  void _onResetSession() {
    ref.read(healthProvider.notifier).resetSession();
  }

  void _showProfileEditor() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Profile Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Name: ${ref.read(healthProvider).profile.name}'),
                Text('Age: ${ref.read(healthProvider).profile.age}'),
                Text(
                  'Weight: ${ref.read(healthProvider).profile.weight.toStringAsFixed(1)} kg',
                ),
                Text(
                  'Height: ${ref.read(healthProvider).profile.height.toStringAsFixed(1)} cm',
                ),
                Text(
                  'BMI: ${ref.read(healthProvider).profile.bmi.toStringAsFixed(1)}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
