import 'package:flutter/material.dart';
import 'package:all_in_one_sensor_toolkit/models/sensor_card.dart';

class SensorGridItem extends StatelessWidget {
  final SensorCard sensor;
  final VoidCallback onTap;
  final String sensorStatus;
  final double fixedColumnWidth; // Add this parameter

  const SensorGridItem({
    super.key,
    required this.sensor,
    required this.onTap,
    required this.sensorStatus,
    this.fixedColumnWidth = 110, // Default width, adjust as needed
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
          child: Stack(
            children: [
              // Main content with fixed width
              SizedBox(
                width: fixedColumnWidth, // Fixed width here
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors:
                          isDark
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
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
                      const SizedBox(height: 12),
                      Text(
                        sensor.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sensor.category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Status badge (positioned absolutely)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
