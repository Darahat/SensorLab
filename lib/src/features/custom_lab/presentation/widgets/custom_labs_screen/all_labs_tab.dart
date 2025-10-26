import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_management_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/widgets_index.dart';

class AllLabsTab extends ConsumerWidget {
  const AllLabsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final allLabsAsync = ref.watch(allLabsProvider);

    return allLabsAsync.when(
      data: (labs) => _buildContent(context, labs, l10n),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorLabsState(
        error: error,
        onRetry: () => ref.invalidate(allLabsProvider),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<Lab> labs,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    if (labs.isEmpty) {
      return EmptyLabsState(
        title: l10n.noLabsYet,
        message: l10n.createFirstLabMessage,
      );
    }

    final presets = labs.where((lab) => lab.isPreset).toList();
    final customs = labs.where((lab) => !lab.isPreset).toList();

    return RefreshIndicator(
      onRefresh: () async {
        // The refresh will be handled by the parent via ref.invalidate
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (presets.isNotEmpty) ...[
            Text(l10n.presetLabs, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            LabsGridView(labs: presets),
            const SizedBox(height: 24),
          ],
          if (customs.isNotEmpty) ...[
            Text(l10n.myCustomLabs, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            LabsGridView(labs: customs),
          ],
        ],
      ),
    );
  }
}
