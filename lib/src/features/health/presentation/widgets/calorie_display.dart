import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

import '../../domain/entities/activity_type.dart';

class CalorieDisplay extends StatelessWidget {
  final double calories;
  final ActivityType activity;

  const CalorieDisplay({
    super.key,
    required this.calories,
    required this.activity,
  });

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
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              l10n.caloriesBurned,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${calories.toStringAsFixed(1)} kcal',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${l10n.activity}: ${_getLocalizedActivityName(activity, l10n)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
