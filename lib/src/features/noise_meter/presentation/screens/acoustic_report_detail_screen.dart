import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/application/services/report_export_service.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart';

class AcousticReportDetailScreen extends ConsumerWidget {
  final AcousticReport report;

  const AcousticReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.acousticReport),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.export_1),
            onPressed: () => _showExportOptions(context),
            tooltip: l10n.actionExport,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: AcousticReportDetailContent(report: report),
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Iconsax.document_text),
              title: const Text('Export as PDF'),
              onTap: () async {
                Navigator.pop(context);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await ReportExportService.savePdfFromReport(report);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('PDF saved')),
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('Failed to save PDF: $e')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.document_download),
              title: Text(l10n.reportExportCSV),
              onTap: () async {
                Navigator.pop(context);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await ReportExportService.saveCsvFromReport(report);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('CSV saved')),
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('Failed to save CSV: $e')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.share),
              title: const Text('Share CSV'),
              onTap: () async {
                Navigator.pop(context);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await ReportExportService.shareCsvFromReport(report);
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('Share failed: $e')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.share),
              title: Text(l10n.share),
              onTap: () async {
                Navigator.pop(context);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await ReportExportService.sharePdfFromReport(report);
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('Share failed: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
