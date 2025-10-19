import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';

class FilterMenu extends StatelessWidget {
  final Function(RecordingPreset?) onFilterSelected;

  const FilterMenu({super.key, required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<RecordingPreset?>(
      icon: const Icon(Iconsax.filter),
      tooltip: 'Filter by Preset',
      onSelected: onFilterSelected,
      itemBuilder: (context) => [
        const PopupMenuItem(value: null, child: Text('All Presets')),
        const PopupMenuDivider(),
        _buildPresetMenuItem(RecordingPreset.sleep, 'Sleep', Iconsax.moon),
        _buildPresetMenuItem(RecordingPreset.work, 'Work', Iconsax.briefcase),
        _buildPresetMenuItem(
          RecordingPreset.focus,
          'Focus',
          Iconsax.lamp_charge,
        ),
      ],
    );
  }

  PopupMenuItem<RecordingPreset> _buildPresetMenuItem(
    RecordingPreset preset,
    String text,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: preset,
      child: Row(
        children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(text)],
      ),
    );
  }
}
