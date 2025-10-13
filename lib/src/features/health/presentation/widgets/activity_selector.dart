import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/activity_type.dart';

class ActivitySelector extends StatelessWidget {
  final ActivityType currentActivity;
  final Function(ActivityType) onChanged;

  const ActivitySelector({
    super.key,
    required this.currentActivity,
    required this.onChanged,
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
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectActivity,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ActivityType.values.map((activity) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_getLocalizedActivityName(activity, l10n)),
                      selected: currentActivity == activity,
                      onSelected: (_) => onChanged(activity),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
