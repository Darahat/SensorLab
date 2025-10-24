import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/src/core/providers.dart';
import 'package:sensorlab/src/features/custom_lab/application/providers/sensor_data_providers.dart';
import 'package:sensorlab/src/features/custom_lab/domain/entities/sensor_type.dart';
import 'package:sensorlab/src/shared/widgets/utility_widgets.dart';

class AltimeterDisplayWidget extends ConsumerWidget {
  const AltimeterDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch altitude data
    final dataPoints = ref.watch(
      sensorTimeSeriesProvider(SensorType.altimeter),
    );
    final altimeterData = ref.watch(altimeterProvider);

    final altitude = altimeterData.altitude;
    final minAltitude = dataPoints.isNotEmpty
        ? dataPoints.reduce((a, b) => a < b ? a : b) - 50
        : 0.0;
    final maxAltitude = dataPoints.isNotEmpty
        ? dataPoints.reduce((a, b) => a > b ? a : b) + 50
        : 100.0;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.brown.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Title ---
            const Text(
              'Altimeter',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 12),

            // --- Circular Gauge ---
            SizedBox(
              width: 150,
              height: 150,
              child: CustomPaint(
                painter: _AltimeterGaugePainter(
                  altitude: altitude,
                  minAltitude: minAltitude,
                  maxAltitude: maxAltitude,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // --- Digital Altitude Display ---
            Text(
              '${altitude.toStringAsFixed(1)} m',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.brown,
              ),
            ),

            const SizedBox(height: 20),

            // --- Real-time Line Chart ---
            RealtimeLineChart(
              dataPoints: dataPoints,
              title: 'Altitude Trend',
              lineColor: Colors.brown,
              minY: minAltitude,
              maxY: maxAltitude,
              horizontalInterval: 50,
              leftTitleBuilder: (value) => '${value.toInt()}',
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for analog gauge
class _AltimeterGaugePainter extends CustomPainter {
  final double altitude;
  final double minAltitude;
  final double maxAltitude;

  _AltimeterGaugePainter({
    required this.altitude,
    required this.minAltitude,
    required this.maxAltitude,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2.2;

    final bgPaint = Paint()
      ..color = Colors.brown.shade100
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final needlePaint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    // Draw gauge background
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // start from left
      pi, // half circle
      false,
      bgPaint,
    );

    // Draw progress arc
    final sweepAngle =
        ((altitude - minAltitude) / (maxAltitude - minAltitude)).clamp(
          0.0,
          1.0,
        ) *
        pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      sweepAngle,
      false,
      progressPaint,
    );

    // Draw needle
    final needleAngle = pi + sweepAngle;
    final needleEnd = Offset(
      center.dx + radius * cos(needleAngle),
      center.dy + radius * sin(needleAngle),
    );
    canvas.drawLine(center, needleEnd, needlePaint);

    // Draw center knob
    canvas.drawCircle(center, 5, Paint()..color = Colors.brown);
  }

  @override
  bool shouldRepaint(covariant _AltimeterGaugePainter oldDelegate) {
    return oldDelegate.altitude != altitude;
  }
}
