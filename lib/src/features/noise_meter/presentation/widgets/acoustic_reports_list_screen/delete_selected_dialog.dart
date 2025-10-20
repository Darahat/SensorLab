import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/providers/acoustic_reports_list_controller.dart';

class DeleteSelectedDialog {
  static Future<void> show(
    BuildContext context,
    AcousticReportsListController notifier,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reports?'),
        content: const Text(
          'Are you sure you want to delete the selected report(s)? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await notifier.deleteSelected();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Reports deleted')));
      }
    }
  }
}
