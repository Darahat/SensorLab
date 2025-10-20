import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/utils/utils_index.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class SessionInfoSection extends StatelessWidget {
  final AcousticReport report;

  const SessionInfoSection({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            InfoRow(
              icon: Iconsax.calendar,
              label: 'Date',
              value: ReportFormatters.formatDate(report.startTime),
            ),
            const SizedBox(height: 12),
            InfoRow(
              icon: Iconsax.clock,
              label: 'Duration',
              value: ReportFormatters.formatDuration(report.duration),
            ),
            const SizedBox(height: 12),
            InfoRow(
              icon: Iconsax.setting_2,
              label: 'Preset',
              value: ReportFormatters.getPresetName(report.preset),
            ),
          ],
        ),
      ),
    );
  }
}
