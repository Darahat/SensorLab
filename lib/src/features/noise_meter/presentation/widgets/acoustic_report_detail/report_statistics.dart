import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/utils/utils_index.dart';
import 'package:sensorlab/src/shared/widgets/common_cards.dart';

class ReportStatistics extends StatelessWidget {
  final AcousticReport report;

  const ReportStatistics({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Iconsax.chart,
            label: 'Average',
            value: ReportFormatters.formatDecibelValue(report.averageDecibels),
            color: ReportFormatters.getDecibelColor(report.averageDecibels),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Iconsax.arrow_up,
            label: 'Peak',
            value: ReportFormatters.formatDecibelValue(report.maxDecibels),
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
