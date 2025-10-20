import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

class ExportDialog extends StatelessWidget {
  final int reportCount;

  const ExportDialog({super.key, required this.reportCount});

  static Future<String?> show(BuildContext context, int reportCount) {
    return showDialog<String>(
      context: context,
      builder: (context) => ExportDialog(reportCount: reportCount),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
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
    );
  }
}
