import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/enhanced_noise_data.dart';

/// Preset card for selection screen
class PresetCard extends StatelessWidget {
  final RecordingPreset preset;
  final IconData icon;
  final String title;
  final String duration;
  final String description;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const PresetCard({
    super.key,
    required this.preset,
    required this.icon,
    required this.title,
    required this.duration,
    required this.description,
    required this.color,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icon container
              _PresetIcon(icon: icon, color: color),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Iconsax.clock, size: 14, color: color),
                        const SizedBox(width: 4),
                        Text(
                          duration,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(Iconsax.arrow_right_3, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _PresetIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _PresetIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: color, size: 32),
    );
  }
}
