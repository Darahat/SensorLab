import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/compass/presentation/providers/compass_provider.dart';

class CompassDisplayWidget extends ConsumerStatefulWidget {
  const CompassDisplayWidget({super.key});

  @override
  ConsumerState<CompassDisplayWidget> createState() =>
      _CompassDisplayWidgetState();
}

class _CompassDisplayWidgetState extends ConsumerState<CompassDisplayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compassData = ref.watch(compassProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    // Consistent color scheme from LabMonitoringContent
    final Color recordingColor = Colors.red;
    final Color pausedColor = Colors.orange;
    final Color completedColor = Colors.green;

    // Pick base color dynamically depending on accuracy state
    final baseColor = compassData.hasError
        ? recordingColor
        : compassData.isCalibrating
        ? pausedColor
        : completedColor;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [baseColor.withOpacity(0.1), Colors.black]
              : [baseColor.withOpacity(0.08), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          // Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.explore, color: baseColor, size: 26),
              const SizedBox(width: 10),
              Text(
                l10n.compass,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Compass Visualization
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: baseColor.withOpacity(0.25),
                            blurRadius: 35,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Outer Circle
              Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      baseColor.withOpacity(0.3),
                      baseColor.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: baseColor.withOpacity(0.7),
                    width: 2,
                  ),
                ),
              ),

              // Direction markers (N, E, S, W)
              ..._buildDirectionMarkers(isDark, baseColor),

              // Needle
              Transform.rotate(
                angle: (compassData.heading ?? 0) * (math.pi / 180) * -1,
                child: Image.asset(
                  'assets/images/compass.png',
                  width: 180,
                  color: baseColor,
                  colorBlendMode: BlendMode.modulate,
                ),
              ),

              // Center Dot
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor,
                  boxShadow: [
                    BoxShadow(
                      color: baseColor.withOpacity(0.6),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),

              if (compassData.isCalibrating)
                Positioned(
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: pausedColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.calibrating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 30),

          // Direction Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: baseColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: baseColor, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  compassData.currentDirection,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: baseColor,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.magneticHeading,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Heading
          Text(
            compassData.headingWithUnit,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: baseColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),

          const SizedBox(height: 10),

          if (compassData.hasValidReading)
            _buildStatusChip(l10n.highAccuracy, completedColor, isDark)
          else if (compassData.hasError)
            _buildStatusChip(l10n.compassError, recordingColor, isDark)
          else if (compassData.isCalibrating)
            _buildStatusChip(l10n.calibrating, pausedColor, isDark),
        ],
      ),
    );
  }

  // Direction markers styled using base color family
  List<Widget> _buildDirectionMarkers(bool isDark, Color baseColor) {
    final directions = [
      {'label': 'N', 'angle': 0.0},
      {'label': 'E', 'angle': math.pi / 2},
      {'label': 'S', 'angle': math.pi},
      {'label': 'W', 'angle': 3 * math.pi / 2},
    ];

    return directions.map((dir) {
      final angle = dir['angle'] as double;
      final label = dir['label'] as String;

      return Transform.rotate(
        angle: angle,
        child: Transform.translate(
          offset: const Offset(0, -90),
          child: Transform.rotate(
            angle: -angle,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: baseColor.withOpacity(isDark ? 0.25 : 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: baseColor, width: 1.5),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: baseColor,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildStatusChip(String text, Color color, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: color, size: 14),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
