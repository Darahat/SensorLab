import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_preset_selection/acoustic_preset_selection_content.dart';

class AcousticPresetSelectionScreen extends ConsumerWidget {
  const AcousticPresetSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.acousticAnalyzerTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: AcousticPresetSelectionContent(),
        ),
      ),
    );
  }
}
