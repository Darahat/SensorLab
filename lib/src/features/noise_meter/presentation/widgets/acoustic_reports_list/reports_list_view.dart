import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/acoustic_reports_list_controller.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/acoustic_reports_list_state.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_reports_list/filter_chip.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_reports_list/report_list_item.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/index.dart'
    show EmptyStateWidget;

class ReportsListView extends StatelessWidget {
  final AcousticReportsListState state;
  final AcousticReportsListController notifier;

  const ReportsListView({
    super.key,
    required this.state,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.filteredReports.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        if (state.filterPreset != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: GetFilterChip(
              preset: state.filterPreset!,
              onClear: () => notifier.setFilter(null),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: state.filteredReports.length,
            itemBuilder: (context, index) {
              final report = state.filteredReports[index];
              final isSelected = state.selectedReportIds.contains(report.id);

              return ReportListItem(
                report: report,
                isSelected: isSelected,
                isSelectionMode: state.isSelectionMode,
                onTap: () => notifier.onReportTap(report),
                onLongPress: () => notifier.onReportLongPress(report),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      icon: Iconsax.document,
      title: 'No Reports Yet',
      message:
          'Start an acoustic analysis session to generate your first report',
      action: ElevatedButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Iconsax.add_circle),
        label: const Text('Start Analysis'),
      ),
    );
  }
}
