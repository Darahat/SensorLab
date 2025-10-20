import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/application/notifiers/acoustic_reports_list_notifier.dart';
import 'package:sensorlab/src/features/noise_meter/application/state/acoustic_reports_list_state.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_reports_list_screen/report_formatters.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart'
    show EmptyStateWidget, ReportListItem, GetFilterChip;

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

              // Compute session number for this preset based on prior occurrences in the current list
              final priorSamePresetCount = state.filteredReports
                  .take(index)
                  .where((r) => r.preset == report.preset)
                  .length;
              final sessionNumber = priorSamePresetCount + 1;
              final baseTitle = ReportFormatters.getPresetName(report.preset);
              final titleOverride = '$baseTitle Session $sessionNumber';

              return ReportListItem(
                report: report,
                isSelected: isSelected,
                isSelectionMode: state.isSelectionMode,
                titleOverride: titleOverride,
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
