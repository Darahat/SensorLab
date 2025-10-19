import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart'
    show ReportFormatters;

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
        _buildPresetMenuItem(RecordingPreset.sleep),
        _buildPresetMenuItem(RecordingPreset.work),
        _buildPresetMenuItem(RecordingPreset.focus),
      ],
    );
  }

  PopupMenuItem<RecordingPreset> _buildPresetMenuItem(RecordingPreset preset) {
    return PopupMenuItem(
      value: preset,
      child: Row(
        children: [
          Icon(ReportFormatters.getPresetIcon(preset), size: 18),
          const SizedBox(width: 8),
          Text(ReportFormatters.getPresetName(preset)),
        ],
      ),
    );
  }
}
