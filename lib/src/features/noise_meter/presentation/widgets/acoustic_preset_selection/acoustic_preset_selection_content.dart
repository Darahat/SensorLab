import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/acoustic_reports_list_screen.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart';
import 'package:sensorlab/src/features/noise_meter/utils/utils_index.dart';

class AcousticPresetSelectionContent extends ConsumerStatefulWidget {
  const AcousticPresetSelectionContent({super.key});

  @override
  ConsumerState<AcousticPresetSelectionContent> createState() =>
      _AcousticPresetSelectionContentState();
}

class _AcousticPresetSelectionContentState
    extends ConsumerState<AcousticPresetSelectionContent> {
  late final PresetSelectionUtils _presetUtils;

  @override
  void initState() {
    super.initState();
    _presetUtils = PresetSelectionUtils();
    _presetUtils.addListener(_onPresetUtilsChanged);
    _presetUtils.loadCustomPresets(context);
  }

  @override
  void dispose() {
    _presetUtils.removeListener(_onPresetUtilsChanged);
    _presetUtils.dispose();
    super.dispose();
  }

  void _onPresetUtilsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        _buildHeader(l10n, theme),
        const SizedBox(height: 24),

        // Content
        Expanded(
          child: PresetListWidget(
            // ← This should work now
            customPresets: _presetUtils.customPresets,
            isLoading: _presetUtils.isLoading,
            onCreatePreset: () => _presetUtils.createCustomPreset(context),
            onStartRecording: _presetUtils.startRecording,
            onDeletePreset: _presetUtils.deleteCustomPreset,
          ),
        ),

        // Bottom Action
        const SizedBox(height: 12),
        _buildHistoryButton(context),
      ],
    );
  }

  Widget _buildHeader(AppLocalizations l10n, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.presetSelectTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.presetSelectSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildHistoryButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
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
        icon: const Icon(Iconsax.document, size: 18),
        label: Text(l10n.viewHistoricalReports),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
