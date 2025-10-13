import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/health/presentation/widgets/profile_editor.dart';
import 'package:sensorlab/src/features/health/providers/health_provider.dart';

import '../../domain/entities/activity_type.dart';
import '../../models/health_data.dart';

class HealthScreen extends ConsumerStatefulWidget {
  const HealthScreen({super.key});

  @override
  ConsumerState<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen> {
  String _getLocalizedActivityName(
    ActivityType activity,
    AppLocalizations l10n,
  ) {
    switch (activity) {
      case ActivityType.walking:
        return l10n.walking;
      case ActivityType.running:
        return l10n.running;
      case ActivityType.cycling:
        return l10n.cycling;
      case ActivityType.sitting:
        return l10n.sitting;
      case ActivityType.standing:
        return l10n.standing;
      case ActivityType.stairs:
        return l10n.stairs;
      case ActivityType.workout:
        return l10n.workout;
    }
  }

  @override
  Widget build(BuildContext context) {
    final healthData = ref.watch(healthProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Text(
              l10n.healthTracker,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            backgroundColor: colorScheme.surface,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Iconsax.user, color: colorScheme.primary),
                onPressed: () => _showProfileEditor(healthData),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeCard(healthData, colorScheme, l10n),
                  const SizedBox(height: 16),
                  _buildQuickStats(healthData, colorScheme, l10n),
                  const SizedBox(height: 24),
                  _buildActivitySelector(healthData, colorScheme, l10n),
                  const SizedBox(height: 16),
                  _buildSessionStatus(healthData, colorScheme, l10n),
                  const SizedBox(height: 12),
                  _buildTrackingControls(healthData, colorScheme, l10n),
                  const SizedBox(height: 16),
                  if (healthData.sessionState ==
                      HealthSessionState.tracking) ...[
                    _buildSensorDisplay(healthData, colorScheme, l10n),
                    const SizedBox(height: 16),
                  ],
                  _buildCalorieDisplay(healthData, colorScheme, l10n),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard(
    HealthData healthData,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
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
            l10n.helloUser(healthData.profile.name),
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.readyToTrackSession(
              _getLocalizedActivityName(
                healthData.selectedActivity,
                l10n,
              ).toLowerCase(),
            ),
            style: TextStyle(
              color: colorScheme.onPrimary.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildProfileStat(
                l10n.bmi,
                healthData.profile.bmi.toStringAsFixed(1),
                colorScheme,
              ),
              const SizedBox(width: 20),
              _buildProfileStat(
                l10n.bmr,
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

  Widget _buildQuickStats(
    HealthData healthData,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            l10n.steps,
            '${healthData.steps}',
            '/ ${healthData.targetSteps}',
            Iconsax.activity,
            colorScheme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            l10n.distance,
            (healthData.distance / 1000).toStringAsFixed(2),
            'km',
            Iconsax.location,
            colorScheme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            l10n.duration,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: colorScheme.primary),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (suffix.isNotEmpty) ...[
                const SizedBox(width: 2),
                Flexible(
                  child: Text(
                    suffix,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
    AppLocalizations l10n,
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
            l10n.activityType,
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
            children: ActivityType.values.map((activity) {
              final isSelected = healthData.selectedActivity == activity;
              return GestureDetector(
                onTap: () => _onActivityChanged(activity),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline,
                    ),
                  ),
                  child: Text(
                    _getLocalizedActivityName(activity, l10n),
                    style: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
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

  Widget _buildSessionStatus(
    HealthData healthData,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final isTracking = healthData.sessionState == HealthSessionState.tracking;
    final isPaused = healthData.sessionState == HealthSessionState.paused;

    if (healthData.sessionState == HealthSessionState.idle) {
      return const SizedBox.shrink(); // Don't show status when idle
    }

    String statusText;
    Color statusColor;
    IconData statusIcon;

    if (isTracking) {
      statusText = l10n.trackingActive;
      statusColor = colorScheme.primary;
      statusIcon = Iconsax.activity;
    } else if (isPaused) {
      statusText = l10n.sessionPaused;
      statusColor = colorScheme.secondary;
      statusIcon = Iconsax.pause;
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          if (isTracking) ...[
            const SizedBox(width: 8),
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(statusColor),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackingControls(
    HealthData healthData,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final isTracking = healthData.sessionState == HealthSessionState.tracking;
    final isPaused = healthData.sessionState == HealthSessionState.paused;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Primary Action Button (Start/Stop/Resume)
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _onStartStopTracking,
              icon: Icon(isTracking ? Iconsax.stop : Iconsax.play, size: 24),
              label: Text(
                isTracking ? l10n.stop : (isPaused ? l10n.resume : l10n.start),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isTracking
                    ? colorScheme.error
                    : colorScheme.primary,
                foregroundColor: isTracking
                    ? colorScheme.onError
                    : colorScheme.onPrimary,
                elevation: isTracking ? 4 : 8,
                shadowColor: isTracking
                    ? colorScheme.error.withOpacity(0.3)
                    : colorScheme.primary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Secondary Action Buttons
          const SizedBox(height: 16),
          Row(
            children: [
              // Pause Button (only visible when tracking)
              if (isTracking) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _onPauseTracking,
                    icon: const Icon(Iconsax.pause, size: 20),
                    label: Text(l10n.pause),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: colorScheme.secondary, width: 2),
                      foregroundColor: colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Reset Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _onResetSession,
                  icon: const Icon(Iconsax.refresh, size: 20),
                  label: Text(l10n.reset),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: colorScheme.outline, width: 1.5),
                    foregroundColor: colorScheme.onSurfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSensorDisplay(
    HealthData healthData,
    ColorScheme colorScheme,
    AppLocalizations l10n,
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
            l10n.liveSensorData,
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
                  l10n.avgIntensity,
                  healthData.averageIntensity.toStringAsFixed(2),
                  colorScheme,
                ),
              ),
              Expanded(
                child: _buildSensorStat(
                  l10n.peakIntensity,
                  healthData.peakIntensity.toStringAsFixed(2),
                  colorScheme,
                ),
              ),
              Expanded(
                child: _buildSensorStat(
                  l10n.movements,
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

  Widget _buildCalorieDisplay(
    HealthData healthData,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final progress = healthData.targetCalories > 0
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
                l10n.caloriesBurned,
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
            l10n.bmrPerDay(
              healthData.profile.basalMetabolicRate.toInt().toString(),
            ),
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
    ref.read(healthProvider.notifier).setActivity(activity);
  }

  void _onStartStopTracking() {
    final currentState = ref.read(healthProvider).sessionState;
    if (currentState == HealthSessionState.tracking) {
      ref.read(healthProvider.notifier).stopTracking();
    } else {
      ref.read(healthProvider.notifier).startTracking();
    }
  }

  void _onPauseTracking() {
    ref.read(healthProvider.notifier).pauseTracking();
  }

  void _onResetSession() {
    ref.read(healthProvider.notifier).resetSession();
  }

  void _showProfileEditor(HealthData healthData) {
    showDialog(
      context: context,
      builder: (context) => ProfileEditor(profile: healthData.profile),
    );
  }
}
