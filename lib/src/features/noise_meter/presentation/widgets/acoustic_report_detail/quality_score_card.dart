import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/utils/report_formatters.dart';

class QualityScoreCard extends StatelessWidget {
  final AcousticReport report;

  const QualityScoreCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = ReportFormatters.getQualityColor(report.qualityScore);
    final qualityLabel = ReportFormatters.getQualityLabel(report.qualityScore);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
        ),
        child: Column(
          children: [
            Text(
              'Environment Quality',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildCircularIndicator(theme, color, qualityLabel),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIndicator(
    ThemeData theme,
    Color color,
    String qualityLabel,
  ) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: CircularProgressIndicator(
              value: report.qualityScore / 100,
              strokeWidth: 16,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                report.qualityScore.toString(),
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                qualityLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
