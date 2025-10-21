import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/widgets_index.dart';

class AcousticReportDetailContent extends StatelessWidget {
  final AcousticReport report;

  const AcousticReportDetailContent({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Quality Score Hero Card
          QualityScoreCard(report: report),
          const SizedBox(height: 24),

          // Statistics Grid
          ReportStatistics(report: report),
          const SizedBox(height: 24),

          // Hourly Chart
          if (report.hourlyAverages.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: HourlyBreakdownChart(
                hourlyAverages: report.hourlyAverages,
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Events Timeline
          EventsSection(report: report),
          const SizedBox(height: 24),

          // Recommendation with Action Tips
          RecommendationSection(report: report),
          const SizedBox(height: 24),

          // Collapsible Session Info
          SessionInfoSection(report: report),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
