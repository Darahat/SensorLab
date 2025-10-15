import 'package:flutter/material.dart';

/// Quality metrics row display
class QualityMetricsRow extends StatelessWidget {
  final double overallScore;
  final double consistencyScore;
  final double peakManagementScore;

  const QualityMetricsRow({
    super.key,
    required this.overallScore,
    required this.consistencyScore,
    required this.peakManagementScore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            label: 'Overall',
            score: overallScore,
            icon: Icons.assessment_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            label: 'Consistency',
            score: consistencyScore,
            icon: Icons.show_chart_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            label: 'Peak Mgmt',
            score: peakManagementScore,
            icon: Icons.trending_down_rounded,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final double score;
  final IconData icon;

  const _MetricCard({
    required this.label,
    required this.score,
    required this.icon,
  });

  Color _getColor() {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.blue;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              score.toStringAsFixed(0),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
