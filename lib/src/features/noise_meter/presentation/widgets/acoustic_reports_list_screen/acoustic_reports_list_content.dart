import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/noise_meter/application/providers/acoustic_reports_list_controller.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart';

class AcousticReportsListContent extends ConsumerWidget {
  const AcousticReportsListContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(acousticReportsListProvider);
    final notifier = ref.read(acousticReportsListProvider.notifier);

    return Column(
      children: [
        SelectionAppBar(state: state, notifier: notifier),
        Expanded(
          child: ReportsListView(state: state, notifier: notifier),
        ),
        if (!state.isSelectionMode && state.filteredReports.isNotEmpty)
          ExportFab(notifier: notifier, reports: state.filteredReports),
      ],
    );
  }
}
