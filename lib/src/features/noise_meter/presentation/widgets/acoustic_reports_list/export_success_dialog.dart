import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ExportSuccessDialog extends StatelessWidget {
  final int reportCount;
  final String filePath;

  const ExportSuccessDialog({
    super.key,
    required this.reportCount,
    required this.filePath,
  });

  static void show(BuildContext context, int reportCount, String filePath) {
    showDialog(
      context: context,
      builder: (context) =>
          ExportSuccessDialog(reportCount: reportCount, filePath: filePath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Iconsax.tick_circle, color: Colors.green, size: 28),
          const SizedBox(width: 12),
          const Text('Export Successful'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$reportCount report(s) exported successfully!'),
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
                const Text(
                  'Saved to:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(filePath, style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
