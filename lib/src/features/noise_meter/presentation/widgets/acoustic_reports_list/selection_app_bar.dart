import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/application/notifiers/acoustic_reports_list_notifier.dart';
import 'package:sensorlab/src/features/noise_meter/application/state/acoustic_reports_list_state.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_reports_list/filter_menu.dart';

class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AcousticReportsListState state;
  final AcousticReportsListController notifier;
  final Function(BuildContext, AcousticReportsListController) onDeleteSelected;
  final Function(BuildContext, AcousticReportsListController) onExportSelected;

  const SelectionAppBar({
    super.key,
    required this.state,
    required this.notifier,
    required this.onDeleteSelected,
    required this.onExportSelected,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        state.isSelectionMode
            ? '${state.selectedReportIds.length} Selected'
            : 'Acoustic Reports',
      ),
      centerTitle: true,
      elevation: 0,
      leading: state.isSelectionMode
          ? IconButton(
              icon: const Icon(Iconsax.close_circle),
              onPressed: notifier.cancelSelection,
            )
          : null,
      actions: [
        if (state.isSelectionMode) ...[
          _buildSelectionActions(context),
        ] else ...[
          FilterMenu(onFilterSelected: notifier.setFilter),
        ],
      ],
    );
  }

  Widget _buildSelectionActions(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Iconsax.document_download),
          onPressed: state.selectedReportIds.isNotEmpty
              ? () => onExportSelected(context, notifier)
              : null,
          tooltip: 'Export as CSV',
        ),
        IconButton(
          icon: const Icon(Iconsax.trash),
          onPressed: state.selectedReportIds.isNotEmpty
              ? () => onDeleteSelected(context, notifier)
              : null,
          tooltip: 'Delete Selected',
        ),
      ],
    );
  }
}
