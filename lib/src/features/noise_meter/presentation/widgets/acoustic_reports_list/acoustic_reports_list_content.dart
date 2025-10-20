import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/acoustic_reports_list_controller.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_reports_list/reports_actions_helper.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_reports_list/reports_list_view.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_reports_list/selection_app_bar.dart';

class AcousticReportsListContent extends ConsumerWidget {
  const AcousticReportsListContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(acousticReportsListProvider);
    final notifier = ref.read(acousticReportsListProvider.notifier);

    return Column(
      children: [
        SelectionAppBar(
          state: state,
          notifier: notifier,
          onDeleteSelected: ReportsActionsHelper.deleteSelected,
          onExportSelected: (context, notifier) {
            final selectedReports = state.filteredReports
                .where((r) => state.selectedReportIds.contains(r.id))
                .toList();
            ReportsActionsHelper.exportReports(
              context,
              notifier,
              selectedReports,
            );
          },
        ),
        Expanded(
          child: ReportsListView(state: state, notifier: notifier),
        ),
      ],
    );
  }
}
