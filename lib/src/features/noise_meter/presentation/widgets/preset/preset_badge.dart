import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/enhanced_noise_data.dart';

/// Compact preset badge
class PresetBadge extends StatelessWidget {
  final RecordingPreset preset;
  final String label;
  final Color color;

  const PresetBadge({
    super.key,
    required this.preset,
    required this.label,
    required this.color,
  });

  IconData _getIcon() {
    switch (preset) {
      case RecordingPreset.sleep:
        return Iconsax.moon;
      case RecordingPreset.work:
        return Iconsax.briefcase;
      case RecordingPreset.focus:
        return Iconsax.lamp_charge;
      case RecordingPreset.custom:
        return Iconsax.setting_2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
