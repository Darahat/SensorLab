import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart';

class AcousticReportDetailContent extends StatelessWidget {
  final AcousticReport report;

  const AcousticReportDetailContent({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quality Score Card
          QualityScoreCard(report: report),
          const SizedBox(height: 24),

          // Statistics Grid
          ReportStatistics(report: report),
          const SizedBox(height: 24),

          // Hourly Chart
          if (report.hourlyAverages.isNotEmpty) ...[
            HourlyBreakdownChart(hourlyAverages: report.hourlyAverages),
            const SizedBox(height: 24),
          ],

          // Events List
          EventsSection(report: report),
          const SizedBox(height: 24),

          // Recommendation
          RecommendationSection(report: report),
          const SizedBox(height: 24),

          // Session Info
          SessionInfoSection(report: report),
        ],
      ),
    );
  }
}
