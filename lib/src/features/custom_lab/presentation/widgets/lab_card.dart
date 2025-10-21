import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';

/// Card widget to display a lab in grid view
class LabCard extends StatelessWidget {
  final Lab lab;
  final VoidCallback onTap;

  const LabCard({required this.lab, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = lab.colorValue != null
        ? Color(lab.colorValue!)
        : theme.colorScheme.primaryContainer;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.7)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and preset badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      _getIconData(lab.iconName),
                      size: 32,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    if (lab.isPreset)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'PRESET',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                // Lab name
                Text(
                  lab.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Sensor count
                Text(
                  '${lab.sensors.length} sensors',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withOpacity(
                      0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Recording interval
                Text(
                  '${lab.recordingInterval}ms interval',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withOpacity(
                      0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'environment':
        return Icons.wb_sunny;
      case 'motion':
        return Icons.directions_run;
      case 'indoor':
        return Icons.home;
      case 'outdoor':
        return Icons.terrain;
      case 'vehicle':
        return Icons.directions_car;
      case 'health':
        return Icons.favorite;
      default:
        return Icons.science;
    }
  }
}
