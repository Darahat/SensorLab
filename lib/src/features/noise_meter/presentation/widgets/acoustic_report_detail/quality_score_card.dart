import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/domain/entities/acoustic_report_entity.dart';
import 'package:sensorlab/src/features/noise_meter/utils/utils_index.dart';

class QualityScoreCard extends StatelessWidget {
  final AcousticReport report;

  const QualityScoreCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final color = ReportFormatters.getQualityColor(report.qualityScore);
    final qualityLabel = ReportFormatters.getQualityLabel(report.qualityScore);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.environmentQuality,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    qualityLabel.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildModernIndicator(theme, color),
            const SizedBox(height: 20),
            _buildQualityInsights(theme, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildModernIndicator(ThemeData theme, Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow effect
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        // Progress ring
        SizedBox(
          width: 200,
          height: 200,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: report.qualityScore / 100),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return CustomPaint(
                painter: _ModernCircularProgressPainter(
                  value: value,
                  color: color,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                ),
                child: child,
              );
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: report.qualityScore),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Text(
                        value.toString(),
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 64,
                          fontWeight: FontWeight.w800,
                          color: color,
                          height: 1,
                          letterSpacing: -2,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '/100',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQualityInsights(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInsightItem(
            theme,
            l10n.averageDecibels,
            '${report.averageDecibels.toStringAsFixed(1)} dB',
            Icons.bar_chart_rounded,
          ),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.outlineVariant.withOpacity(0.3),
          ),
          _buildInsightItem(
            theme,
            l10n.peakDecibels,
            '${report.maxDecibels.toStringAsFixed(1)} dB',
            Icons.trending_up_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// Custom painter for modern circular progress
class _ModernCircularProgressPainter extends CustomPainter {
  final double value;
  final Color color;
  final Color backgroundColor;

  _ModernCircularProgressPainter({
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [color, color.withOpacity(0.7)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.14159 * value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ModernCircularProgressPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
