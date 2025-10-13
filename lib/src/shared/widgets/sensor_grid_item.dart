import 'package:flutter/material.dart';
import 'package:sensorlab/src/shared/models/sensor_card.dart';

class SensorGridItem extends StatelessWidget {
  final SensorCard sensor;
  final VoidCallback onTap;
  final String sensorStatus;
  final double fixedColumnWidth;

  const SensorGridItem({
    super.key,
    required this.sensor,
    required this.onTap,
    required this.sensorStatus,
    this.fixedColumnWidth = 110,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              // Left column (fixed width) - Sensor Info
              Container(
                width: fixedColumnWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Colors.grey.shade800.withOpacity(0.8),
                            Colors.grey.shade900.withOpacity(0.9),
                          ]
                        : [
                            Colors.white.withOpacity(0.9),
                            Colors.grey.shade50.withOpacity(0.9),
                          ],
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            sensor.color.withOpacity(0.2),
                            sensor.color.withOpacity(0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(sensor.icon, size: 28, color: sensor.color),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Text(
                        sensor.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: isDark ? Colors.white : Colors.grey.shade800,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        sensor.category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: isDark
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Right column (expanded) - Status Badge (Top Center)
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Horizontal center
                  mainAxisAlignment: MainAxisAlignment.start, // Align to top
                  children: [
                    const SizedBox(height: 12), // Optional top padding
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: sensor.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        sensorStatus,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: sensor.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
