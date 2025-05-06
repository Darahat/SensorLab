import 'package:flutter/material.dart';
import '../../models/activity_type.dart';

class CalorieDisplay extends StatelessWidget {
  final double calories;
  final ActivityType activity;

  const CalorieDisplay({
    super.key,
    required this.calories,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'CALORIES BURNED',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${calories.toStringAsFixed(1)} kcal',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Activity: ${activity.displayName}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
