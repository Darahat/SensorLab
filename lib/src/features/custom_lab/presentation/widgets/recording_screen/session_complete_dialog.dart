import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/lab_session.dart';
import 'package:sensorlab/src/features/custom_lab/presentation/screens/session_detail_screen.dart';

class SessionCompleteDialog {
  static Future<void> show({
    required BuildContext context,
    required LabSession session,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(l10n.recordingComplete)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(l10n.labName, session.labName, Icons.science),
              const SizedBox(height: 8),
              _buildInfoRow(
                l10n.duration,
                _formatDuration(session.duration),
                Icons.timer,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                l10n.dataPoints(session.dataPointsCount),
                '${session.dataPointsCount}',
                Icons.analytics,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                l10n.sensors,
                '${session.sensorTypes.length}',
                Icons.sensors,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: Text(l10n.done),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SessionDetailScreen(session: session),
                  ),
                );
              },
              icon: const Icon(Icons.visibility),
              label: Text(l10n.viewReport),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }
}
