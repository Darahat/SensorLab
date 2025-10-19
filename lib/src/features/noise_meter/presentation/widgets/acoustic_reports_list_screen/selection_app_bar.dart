import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/acoustic_reports_list_controller.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/state/acoustic_reports_list_state.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart';

class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AcousticReportsListState state;
  final AcousticReportsListController notifier;

  const SelectionAppBar({
    super.key,
    required this.state,
    required this.notifier,
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
        if (state.isSelectionMode)
          SelectionActions(state: state, notifier: notifier)
        else
          FilterMenu(onFilterSelected: notifier.setFilter),
      ],
    );
  }
}
