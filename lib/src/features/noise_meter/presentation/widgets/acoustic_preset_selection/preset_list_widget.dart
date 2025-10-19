import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart'
    show PresetCard;

class PresetListWidget extends StatelessWidget {
  final Map<String, CustomPresetConfig> customPresets;
  final bool isLoading;
  final VoidCallback onCreatePreset;
  final Function(
    BuildContext,
    RecordingPreset, {
    CustomPresetConfig? customConfig,
  })
  onStartRecording;
  final Function(String) onDeletePreset;

  const PresetListWidget({
    super.key,
    required this.customPresets,
    required this.isLoading,
    required this.onCreatePreset,
    required this.onStartRecording,
    required this.onDeletePreset,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final l10n = AppLocalizations.of(context)!;

    return ListView(
      children: [
        // Default Presets
        _buildDefaultPresets(context, l10n),

        // Custom Presets Section
        if (customPresets.isNotEmpty) _buildCustomPresetsSection(context),

        // Create Custom Preset Button
        _buildCreatePresetButton(context),
      ],
    );
  }

  Widget _buildDefaultPresets(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        PresetCard(
          preset: RecordingPreset.sleep,
          icon: Iconsax.moon,
          title: l10n.presetSleepTitle,
          duration: l10n.presetSleepDuration,
          description: l10n.presetSleepDescription,
          color: Colors.indigo,
          onTap: () => onStartRecording(context, RecordingPreset.sleep),
        ),
        const SizedBox(height: 12),
        PresetCard(
          preset: RecordingPreset.work,
          icon: Iconsax.briefcase,
          title: l10n.presetWorkTitle,
          duration: l10n.presetWorkDuration,
          description: l10n.presetWorkDescription,
          color: Colors.blue,
          onTap: () => onStartRecording(context, RecordingPreset.work),
        ),
        const SizedBox(height: 12),
        PresetCard(
          preset: RecordingPreset.focus,
          icon: Iconsax.lamp_charge,
          title: l10n.presetFocusTitle,
          duration: l10n.presetFocusDuration,
          description: l10n.presetFocusDescription,
          color: Colors.teal,
          onTap: () => onStartRecording(context, RecordingPreset.focus),
        ),
      ],
    );
  }

  Widget _buildCustomPresetsSection(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildSectionDivider('Custom Presets'),
        const SizedBox(height: 12),
        ...customPresets.entries.map((entry) {
          final id = entry.key;
          final customPreset = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: PresetCard(
              preset: RecordingPreset.custom,
              icon: customPreset.icon,
              title: customPreset.title,
              duration: customPreset.formattedDuration,
              description: customPreset.description,
              color: customPreset.color,
              onTap: () => onStartRecording(
                context,
                RecordingPreset.custom,
                customConfig: customPreset,
              ),
              onLongPress: () =>
                  _showDeleteDialog(context, id, customPreset.title),
              // ← Remove the compact parameter
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCreatePresetButton(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.purple.withOpacity(0.2), width: 1.5),
      ),
      child: InkWell(
        onTap: onCreatePreset,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Iconsax.add_circle,
                  color: Colors.purple,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Custom',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Design your own analysis',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.purple.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDivider(String title) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, String id, String presetTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Preset?'),
        content: Text('Delete "$presetTitle"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDeletePreset(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
}
