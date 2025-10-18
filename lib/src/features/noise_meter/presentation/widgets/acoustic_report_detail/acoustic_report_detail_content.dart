import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_report_detail/events_section.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_report_detail/quality_score_card.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_report_detail/recommendation_section.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_report_detail/report_statistics.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/acoustic_report_detail/session_info_section.dart';
import 'package:sensorlab/src/features/noise_meter/presentation/widgets/report/hourly_breakdown_chart.dart';

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
