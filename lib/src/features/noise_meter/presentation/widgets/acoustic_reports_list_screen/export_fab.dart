import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/acoustic_reports_list_controller.dart';

class ExportFab extends StatelessWidget {
  final AcousticReportsListController notifier;
  final List<AcousticReport> reports;

  const ExportFab({super.key, required this.notifier, required this.reports});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => notifier.exportReports(context, reports),
      icon: const Icon(Iconsax.document_download),
      label: const Text('Export All'),
    );
  }
}
