import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

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
    return AlertDialog(
      title: const Text('Export Reports'),
      content: Text('Choose how you want to export $reportCount report(s):'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'clipboard'),
          child: const Text('Copy to Clipboard'),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context, 'file'),
          icon: const Icon(Iconsax.document_download, size: 18),
          label: const Text('Save as File'),
        ),
      ],
    );
  }
}
