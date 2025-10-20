import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/application/notifiers/acoustic_reports_list_notifier.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_reports_list/reports_actions_helper.dart';

class ExportFab extends StatelessWidget {
  final AcousticReportsListController notifier;
  final List<AcousticReport> reports;

  const ExportFab({super.key, required this.notifier, required this.reports});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FloatingActionButton.extended(
      onPressed: () =>
          ReportsActionsHelper.exportReports(context, notifier, reports),
      icon: const Icon(Iconsax.document_download),
      label: Text(l10n.reportExportAll),
    );
  }
}
