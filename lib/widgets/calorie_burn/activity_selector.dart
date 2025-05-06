import 'package:flutter/material.dart';
import '../../models/activity_type.dart';

class ActivitySelector extends StatelessWidget {
  final ActivityType currentActivity;
  final Function(ActivityType) onChanged;

  const ActivitySelector({
    super.key,
    required this.currentActivity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SELECT ACTIVITY',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    ActivityType.values.map((activity) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(activity.displayName),
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
