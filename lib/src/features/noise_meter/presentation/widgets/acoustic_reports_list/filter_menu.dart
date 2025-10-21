import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';

class FilterMenu extends StatelessWidget {
  final Function(RecordingPreset?) onFilterSelected;

  const FilterMenu({super.key, required this.onFilterSelected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<RecordingPreset?>(
      icon: const Icon(Iconsax.filter),
      tooltip: l10n.reportFilterByPreset,
      onSelected: onFilterSelected,
      itemBuilder: (context) => [
        PopupMenuItem(child: Text(l10n.allPresets)),
        const PopupMenuDivider(),
        _buildPresetMenuItem(
          RecordingPreset.sleep,
          l10n.presetSleep,
          Iconsax.moon,
        ),
        _buildPresetMenuItem(
          RecordingPreset.work,
          l10n.presetWork,
          Iconsax.briefcase,
        ),
        _buildPresetMenuItem(
          RecordingPreset.focus,
          l10n.presetFocus,
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
