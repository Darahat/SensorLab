import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/acoustic_monitoring_screen.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/acoustic_reports_list_screen.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/custom_preset_creation_screen.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/enhanced_noise_data.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/index.dart'
    show PresetCard;
import 'package:sensorlab/src/features/noise_meter/services/custom_preset_service.dart';

/// Acoustic Environment Analyzer - Preset Selection Screen
class AcousticPresetSelectionScreen extends ConsumerStatefulWidget {
  const AcousticPresetSelectionScreen({super.key});

  @override
  ConsumerState<AcousticPresetSelectionScreen> createState() =>
      _AcousticPresetSelectionScreenState();
}

class _AcousticPresetSelectionScreenState
    extends ConsumerState<AcousticPresetSelectionScreen> {
  Map<String, CustomPresetConfig> _customPresets = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 AcousticPresetSelectionScreen.initState() called');
    _loadCustomPresets();
  }

  Future<void> _loadCustomPresets() async {
    debugPrint('🔄 _loadCustomPresets() started');
    setState(() => _isLoading = true);
    try {
      final presets = await CustomPresetService.getAllPresetsWithIds();
      debugPrint('✅ Retrieved ${presets.length} presets from service');
      if (mounted) {
        setState(() {
          _customPresets = presets;
          _isLoading = false;
        });
        debugPrint('✅ State updated with presets');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading custom presets: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load custom presets: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _createCustomPreset(BuildContext context) async {
    debugPrint('🎨 _createCustomPreset() called');
    final customPreset = await Navigator.push<CustomPresetConfig>(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomPresetCreationScreen(),
      ),
    );

    if (customPreset != null) {
      debugPrint(
        '✅ Received custom preset from creation screen: ${customPreset.title}',
      );
      try {
        // Save to Hive
        final id = await CustomPresetService.savePreset(customPreset);
        debugPrint('💾 Preset saved with ID: $id');

        setState(() {
          _customPresets[id] = customPreset;
        });
        debugPrint('✅ Local state updated');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Custom preset "${customPreset.title}" created!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e, stackTrace) {
        debugPrint('❌ Failed to save preset: $e');
        debugPrint('Stack trace: $stackTrace');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save preset: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      debugPrint('⚠️ No preset returned from creation screen');
    }
  }

  void _startRecording(
    BuildContext context,
    RecordingPreset preset, {
    CustomPresetConfig? customConfig,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcousticMonitoringScreen(
          preset: preset,
          customConfig: customConfig,
        ),
      ),
    );
  }

  Future<void> _deleteCustomPreset(String id) async {
    final preset = _customPresets[id];
    if (preset == null) return;

    // Remove from local state first for immediate UI update
    setState(() {
      _customPresets.remove(id);
    });

    try {
      // Delete from Hive
      await CustomPresetService.deletePreset(id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted "${preset.title}"'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () async {
                try {
                  // Re-save to Hive with same ID
                  await CustomPresetService.savePreset(preset);
                  setState(() {
                    _customPresets[id] = preset;
                  });
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to restore preset: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ),
        );
      }
    } catch (e) {
      // Restore on error
      setState(() {
        _customPresets[id] = preset;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete preset: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.acousticAnalyzerTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                l10n.presetSelectTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.presetSelectSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Preset Cards
              Expanded(
                child: ListView(
                  children: [
                    // Default Presets
                    PresetCard(
                      preset: RecordingPreset.sleep,
                      icon: Iconsax.moon,
                      title: l10n.presetSleepTitle,
                      duration: l10n.presetSleepDuration,
                      description: l10n.presetSleepDescription,
                      color: Colors.indigo,
                      onTap: () =>
                          _startRecording(context, RecordingPreset.sleep),
                    ),
                    const SizedBox(height: 16),
                    PresetCard(
                      preset: RecordingPreset.work,
                      icon: Iconsax.briefcase,
                      title: l10n.presetWorkTitle,
                      duration: l10n.presetWorkDuration,
                      description: l10n.presetWorkDescription,
                      color: Colors.blue,
                      onTap: () =>
                          _startRecording(context, RecordingPreset.work),
                    ),
                    const SizedBox(height: 16),
                    PresetCard(
                      preset: RecordingPreset.focus,
                      icon: Iconsax.lamp_charge,
                      title: l10n.presetFocusTitle,
                      duration: l10n.presetFocusDuration,
                      description: l10n.presetFocusDescription,
                      color: Colors.teal,
                      onTap: () =>
                          _startRecording(context, RecordingPreset.focus),
                    ),

                    // Custom Presets Section
                    if (_customPresets.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey[300],
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Text(
                                'Custom Presets',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey[300],
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Display Custom Presets
                    ..._customPresets.entries.map((entry) {
                      final id = entry.key;
                      final customPreset = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: PresetCard(
                          preset: RecordingPreset.custom,
                          icon: customPreset.icon,
                          title: customPreset.title,
                          duration: customPreset.formattedDuration,
                          description: customPreset.description,
                          color: customPreset.color,
                          onTap: () => _startRecording(
                            context,
                            RecordingPreset.custom,
                            customConfig: customPreset,
                          ),
                          onLongPress: () => _showDeleteDialog(id),
                        ),
                      );
                    }),

                    // Create Custom Preset Button
                    const SizedBox(height: 8),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Colors.purple.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => _createCustomPreset(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Iconsax.add_circle,
                                  color: Colors.purple,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Create Custom Preset',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.purple,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Design your own analysis session',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.purple.withOpacity(0.5),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // View History Button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AcousticReportsListScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Iconsax.document),
                  label: Text(l10n.viewHistoricalReports),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(String id) {
    final preset = _customPresets[id];
    if (preset == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Custom Preset?'),
        content: Text(
          'Are you sure you want to delete "${preset.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCustomPreset(id);
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
