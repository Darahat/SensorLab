import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

import '../../models/pedometer_data.dart';
import '../providers/pedometer_provider.dart';

class PedometerScreen extends ConsumerStatefulWidget {
  const PedometerScreen({super.key});

  @override
  ConsumerState<PedometerScreen> createState() => _PedometerScreenState();
}

class _PedometerScreenState extends ConsumerState<PedometerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _useKm = true; // true for km, false for miles

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pedometerData = ref.watch(pedometerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    // Animate when steps change
    if (pedometerData.isActive && pedometerData.isWalking) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pedometer),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          // Unit toggle
          IconButton(
            icon: Text(
              _useKm ? 'MI' : 'KM',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            onPressed: () {
              setState(() {
                _useKm = !_useKm;
              });
            },
          ),
          // Settings (goal)
          IconButton(
            icon: Icon(Iconsax.setting_2, color: colorScheme.primary),
            onPressed: () => _showGoalDialog(context, pedometerData.dailyGoal),
          ),
          // Reset button
          IconButton(
            icon: Icon(Iconsax.refresh, color: colorScheme.primary),
            onPressed: () => _showResetDialog(context),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Main Step Counter
                _buildStepCounter(colorScheme, pedometerData, l10n),
                const SizedBox(height: 30),

                // Goal Progress
                _buildGoalProgress(colorScheme, pedometerData, l10n),
                const SizedBox(height: 30),

                // Activity Level Badge
                _buildActivityLevel(colorScheme, pedometerData, l10n),
                const SizedBox(height: 30),

                // Stats Grid
                _buildStatsGrid(colorScheme, pedometerData, l10n),
                const SizedBox(height: 20),

                // Additional Metrics
                _buildMetricsGrid(colorScheme, pedometerData, l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCounter(
    ColorScheme colorScheme,
    PedometerData data,
    AppLocalizations l10n,
  ) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final scale = 1.0 + (_animationController.value * 0.05);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  colorScheme.primary.withOpacity(0.2),
                  colorScheme.surfaceVariant,
                ],
              ),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  data.isWalking ? Iconsax.man : Iconsax.man,
                  size: 48,
                  color: data.isWalking
                      ? colorScheme.primary
                      : colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  data.stepsFormatted,
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.steps,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withOpacity(0.6),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGoalProgress(
    ColorScheme colorScheme,
    PedometerData data,
    AppLocalizations l10n,
  ) {
    final progress = data.goalProgress.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.dailyGoal,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '${data.totalSteps} / ${data.dailyGoal}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                data.isGoalReached ? Colors.green : colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.goalProgressFormatted,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              if (!data.isGoalReached)
                Text(
                  '${data.stepsToGoal} ${l10n.stepsToGo}',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                )
              else
                Row(
                  children: [
                    const Icon(
                      Iconsax.tick_circle5,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.goalReached,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLevel(
    ColorScheme colorScheme,
    PedometerData data,
    AppLocalizations l10n,
  ) {
    final level = data.activityLevel;
    Color levelColor;

    switch (level) {
      case ActivityLevel.sedentary:
        levelColor = Colors.grey;
        break;
      case ActivityLevel.lightlyActive:
        levelColor = Colors.blue;
        break;
      case ActivityLevel.moderatelyActive:
        levelColor = Colors.orange;
        break;
      case ActivityLevel.veryActive:
        levelColor = Colors.green;
        break;
      case ActivityLevel.extremelyActive:
        levelColor = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: levelColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: levelColor.withOpacity(0.3), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(level.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Text(
            level.displayName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: levelColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
    ColorScheme colorScheme,
    PedometerData data,
    AppLocalizations l10n,
  ) {
    final distance = _useKm
        ? data.distanceKmFormatted
        : data.distanceMilesFormatted;
    final distanceUnit = _useKm ? 'km' : 'mi';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                colorScheme,
                l10n.distance,
                distance,
                distanceUnit,
                Iconsax.routing_2,
                Colors.blue,
              ),
              _buildStatItem(
                colorScheme,
                l10n.calories,
                data.caloriesFormatted,
                'kcal',
                Iconsax.battery_charging,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatItem(
            colorScheme,
            l10n.duration,
            data.durationFormatted,
            '',
            Iconsax.clock,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(
    ColorScheme colorScheme,
    PedometerData data,
    AppLocalizations l10n,
  ) {
    final speed = _useKm
        ? data.avgSpeedKmhFormatted
        : data.avgSpeedMphFormatted;
    final speedUnit = _useKm ? 'km/h' : 'mph';
    final pace = _useKm
        ? data.paceMinPerKmFormatted
        : data.paceMinPerMileFormatted;
    final paceUnit = _useKm ? 'min/km' : 'min/mi';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            colorScheme,
            l10n.avgSpeed,
            speed,
            speedUnit,
            Iconsax.speedometer,
            Colors.green,
          ),
          _buildStatItem(
            colorScheme,
            l10n.pace,
            pace,
            paceUnit,
            Iconsax.timer_1,
            Colors.red,
          ),
          _buildStatItem(
            colorScheme,
            l10n.cadence,
            data.cadence.toString(),
            'spm',
            Iconsax.chart_1,
            Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    ColorScheme colorScheme,
    String label,
    String value,
    String unit,
    IconData icon,
    Color accentColor,
  ) {
    return Column(
      children: [
        Icon(icon, color: accentColor, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  void _showGoalDialog(BuildContext context, int currentGoal) {
    final controller = TextEditingController(text: currentGoal.toString());
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.setDailyGoal),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.steps,
            suffixText: l10n.steps,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final goal = int.tryParse(controller.text);
              if (goal != null && goal > 0) {
                ref.read(pedometerProvider.notifier).setDailyGoal(goal);
              }
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetSession),
        content: Text(l10n.resetSessionConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              ref.read(pedometerProvider.notifier).reset();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.reset),
          ),
        ],
      ),
    );
  }
}
