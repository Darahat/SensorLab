import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/application/notifiers/acoustic_reports_list_notifier.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';

class ReportsActionsHelper {
  static Future<void> exportReports(
    BuildContext context,
    AcousticReportsListController notifier,
    List<AcousticReport> reports,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    // Show export options dialog
    final exportOption = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.exportReports),
        content: Text(l10n.exportChooseMethod),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'clipboard'),
            child: Text(l10n.exportCopyToClipboard),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, 'file'),
            icon: const Icon(Iconsax.document_download, size: 18),
            label: Text(l10n.exportSaveAsFile),
          ),
        ],
      ),
    );

    if (exportOption == null) {
      return;
    }

    final csvData = notifier.exportReportsAsCSV(reports);

    if (exportOption == 'clipboard') {
      // Copy to clipboard (existing functionality)
      Clipboard.setData(ClipboardData(text: csvData));
      if (context.mounted) {
        final l10nMounted = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(l10nMounted.csvCopiedToClipboard),
              backgroundColor: Colors.green,
            ),
          );
      }
    } else if (exportOption == 'file') {
      // Save to file
      // Capture a local reference to Navigator to avoid using context after await
      if (!context.mounted) {
        return;
      }
      await _saveCSVToFile(context, csvData, reports.length);
    }
  }

  static Future<void> _saveCSVToFile(
    BuildContext context,
    String csvData,
    int reportCount,
  ) async {
    try {
      // Generate filename with timestamp
      final timestamp = DateTime.now();
      final filename =
          'acoustic_reports_${timestamp.year}${timestamp.month.toString().padLeft(2, '0')}${timestamp.day.toString().padLeft(2, '0')}_${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}.csv';

      String? savedPath;
      if (Platform.isAndroid || Platform.isIOS) {
        // Use Storage Access Framework / native saver. This opens a system dialog
        // where the user picks the folder (Downloads by default on Android).
        try {
          final params = SaveFileDialogParams(
            fileName: filename,
            data: Uint8List.fromList(csvData.codeUnits),
          );
          savedPath = await FlutterFileDialog.saveFile(params: params);
          if (savedPath == null) {
            // User cancelled
            return;
          }
        } on MissingPluginException {
          // Fallback to app documents directory if plugin channel not registered
          final dir = await getApplicationDocumentsDirectory();
          final file = File('${dir.path}/$filename');
          await file.writeAsString(csvData);
          savedPath = file.path;
        }
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$filename');
        await file.writeAsString(csvData);
        savedPath = file.path;
      }

      if (context.mounted) {
        final l10nDialog = AppLocalizations.of(context)!;
        // Show success dialog with file location
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                const Icon(Iconsax.tick_circle, color: Colors.green, size: 28),
                const SizedBox(width: 12),
                Text(l10nDialog.exportSuccess),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10nDialog.exportSuccessMessage(reportCount)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 68, 68, 68),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10nDialog.savedTo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        savedPath ?? '',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10nDialog.actionOk),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Failed to export file: $e'),
              backgroundColor: Colors.red,
            ),
          );
      }
    }
  }

  static Future<void> deleteSelected(
    BuildContext context,
    AcousticReportsListController notifier,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteReportsQuestion),
        content: Text(l10n.deleteReportsConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await notifier.deleteSelected();
      if (context.mounted) {
        final l10nMounted = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10nMounted.reportsDeleted)));
      }
    }
  }
}
