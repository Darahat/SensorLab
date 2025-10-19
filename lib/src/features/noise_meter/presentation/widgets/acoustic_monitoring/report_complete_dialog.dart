import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/models/custom_preset_config.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/screens/acoustic_report_detail_screen.dart';
import 'package:sensorlab/src/features/noise_meter/utils/monitoring_formatters.dart';

class ReportCompleteDialog {
  static void show({
    required BuildContext context,
    required AcousticReport report,
    required RecordingPreset preset,
    CustomPresetConfig? customConfig,
  }) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.recordingComplete),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.presetName}: ${MonitoringFormatters.getPresetTitle(l10n, preset, customConfig)}',
              ),
              const SizedBox(height: 8),
              Text('${l10n.duration}: ${report.duration.inMinutes} min'),
              Text(
                '${l10n.averageDecibels}: ${report.averageDecibels.toStringAsFixed(1)} dB',
              ),
              Text(
                '${l10n.peakDecibels}: ${report.maxDecibels.toStringAsFixed(1)} dB',
              ),
              Text('${l10n.environmentQuality}: ${report.environmentQuality}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop(report);
              },
              child: Text(l10n.ok),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        AcousticReportDetailScreen(report: report),
                  ),
                );
              },
              child: Text(l10n.viewReport),
            ),
          ],
        );
      },
    );
  }
}
