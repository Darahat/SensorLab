import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/lab_management_provider.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/widgets/widgets_index.dart';

class MyLabsTab extends ConsumerWidget {
  const MyLabsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final customLabsAsync = ref.watch(customLabsProvider);

    return customLabsAsync.when(
      data: (labs) => _buildContent(context, labs, l10n),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorLabsState(
        error: error,
        onRetry: () => ref.invalidate(customLabsProvider),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<Lab> labs,
    AppLocalizations l10n,
  ) {
    if (labs.isEmpty) {
      return EmptyLabsState(
        title: l10n.noCustomLabsYet,
        message: l10n.tapPlusToCreateLab,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // The refresh will be handled by the parent via ref.invalidate
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LabsGridView(labs: labs),
      ),
    );
  }
}
