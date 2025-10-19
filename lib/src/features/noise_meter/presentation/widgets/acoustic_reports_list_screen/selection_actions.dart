import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/acoustic_reports_list_controller.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/acoustic_reports_list_state.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart';

class SelectionActions extends StatelessWidget {
  final AcousticReportsListState state;
  final AcousticReportsListController notifier;

  const SelectionActions({
    super.key,
    required this.state,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Iconsax.document_download),
          onPressed: state.selectedReportIds.isNotEmpty
              ? () => _onExportSelected(context)
              : null,
          tooltip: 'Export as CSV',
        ),
        IconButton(
          icon: const Icon(Iconsax.trash),
          onPressed: state.selectedReportIds.isNotEmpty
              ? () => _onDeleteSelected(context)
              : null,
          tooltip: 'Delete Selected',
        ),
      ],
    );
  }

  void _onExportSelected(BuildContext context) {
    final selectedReports = state.filteredReports
        .where((r) => state.selectedReportIds.contains(r.id))
        .toList();
    notifier.exportReports(context, selectedReports);
  }

  void _onDeleteSelected(BuildContext context) {
    DeleteSelectedDialog.show(context, notifier);
  }
}
