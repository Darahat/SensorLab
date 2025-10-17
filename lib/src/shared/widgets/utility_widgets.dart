import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Reusable line chart wrapper for real-time data visualization
class RealtimeLineChart extends StatelessWidget {
  final List<double> dataPoints;
  final String title;
  final Color lineColor;
  final double minY;
  final double maxY;
  final double? horizontalInterval;
  final String Function(double)? leftTitleBuilder;

  const RealtimeLineChart({
    super.key,
    required this.dataPoints,
    required this.title,
    required this.lineColor,
    this.minY = 0,
    this.maxY = 100,
    this.horizontalInterval,
    this.leftTitleBuilder,
  });

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
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: dataPoints.isEmpty
                  ? Center(
                      child: Text(
                        'Collecting data...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: horizontalInterval ?? 20,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.2),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: horizontalInterval ?? 20,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  leftTitleBuilder?.call(value) ??
                                      '${value.toInt()}',
                                  style: theme.textTheme.bodySmall,
                                );
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: dataPoints.length.toDouble(),
                        minY: minY,
                        maxY: maxY,
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              dataPoints.length,
                              (index) =>
                                  FlSpot(index.toDouble(), dataPoints[index]),
                            ),
                            isCurved: true,
                            color: lineColor,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: lineColor.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Action button widget with icon and label
class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool isOutlined;
  final double? iconSize;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final bool compact;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.isOutlined = false,
    this.iconSize,
    this.fontSize,
    this.padding,
    this.height,
    this.compact = false,
  });

  // Compact constructor for smaller buttons
  const ActionButton.compact({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.isOutlined = false,
  }) : iconSize = 16,
       fontSize = 12,
       padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
       height = 36,
       compact = true;

  // Icon-only constructor
  const ActionButton.iconOnly({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.isOutlined = false,
  }) : label = '',
       iconSize = 20,
       padding = const EdgeInsets.all(12),
       height = 44,
       fontSize = null,
       compact = false;

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Theme.of(context).colorScheme.primary;
    final effectivePadding = padding ?? _getDefaultPadding();
    final effectiveIconSize = iconSize ?? _getDefaultIconSize();
    final effectiveFontSize = fontSize ?? _getDefaultFontSize();

    if (isOutlined) {
      return SizedBox(
        height: height,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: effectiveIconSize),
          label: label.isNotEmpty
              ? Text(label, style: TextStyle(fontSize: effectiveFontSize))
              : const SizedBox.shrink(),
          style: OutlinedButton.styleFrom(
            foregroundColor: buttonColor,
            side: BorderSide(color: buttonColor),
            padding: effectivePadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(compact ? 8 : 12),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: effectiveIconSize),
        label: label.isNotEmpty
            ? Text(label, style: TextStyle(fontSize: effectiveFontSize))
            : const SizedBox.shrink(),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          padding: effectivePadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(compact ? 8 : 12),
          ),
        ),
      ),
    );
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    if (compact) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }
    return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
  }

  double _getDefaultIconSize() {
    if (compact) return 16;
    return 20;
  }

  double _getDefaultFontSize() {
    if (compact) return 12;
    return 14;
  }
}

/// Info row widget for displaying labeled values
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ],
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge widget for displaying status or category
class BadgeWidget extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const BadgeWidget({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
