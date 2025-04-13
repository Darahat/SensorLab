import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:math';
import 'dart:async';

class MagnetometerScreen extends StatefulWidget {
  const MagnetometerScreen({super.key});

  @override
  State<MagnetometerScreen> createState() => _MagnetometerScreenState();
}

class _MagnetometerScreenState extends State<MagnetometerScreen> {
  double _x = 0;
  double _y = 0;
  double _z = 0;
  double _strength = 0;
  double _maxStrength = 0;
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _magnetometerSubscription = magnetometerEvents.listen((event) {
      final strength = calculateStrength(event.x, event.y, event.z);
      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;
        _strength = strength;
        _maxStrength = strength > _maxStrength ? strength : _maxStrength;
      });
    });
  }

  double calculateStrength(double x, double y, double z) {
    return sqrt(x * x + y * y + z * z);
  }

  @override
  void dispose() {
    _magnetometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final normalizedStrength = (_strength / 1000).clamp(0, 1);
    final strengthColor =
        Color.lerp(
          colorScheme.primary,
          colorScheme.error,
          normalizedStrength.toDouble(),
        )!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Magnetometer'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          IconButton(
            icon: Icon(Iconsax.refresh, color: colorScheme.primary),
            onPressed: () => setState(() => _maxStrength = 0),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Magnetic Field Visualization
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CustomPaint(
                    painter: _MagneticFieldPainter(
                      x: _x,
                      y: _y,
                      z: _z,
                      strength: normalizedStrength.toDouble(),
                      colorScheme: colorScheme,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Strength Indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${_strength.toStringAsFixed(2)} μT',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: strengthColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Max: ${_maxStrength.toStringAsFixed(2)} μT',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Axis Indicators
                _buildFieldIndicator('X', _x, colorScheme.primary),
                _buildFieldIndicator('Y', _y, colorScheme.secondary),
                _buildFieldIndicator('Z', _z, colorScheme.tertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldIndicator(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (value.abs() / 1000).clamp(0, 1),
                backgroundColor: Colors.grey.withOpacity(0.2),
                color: color,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              value.toStringAsFixed(2),
              style: TextStyle(color: color),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _MagneticFieldPainter extends CustomPainter {
  final double x;
  final double y;
  final double z;
  final double strength;
  final ColorScheme colorScheme;

  _MagneticFieldPainter({
    required this.x,
    required this.y,
    required this.z,
    required this.strength,
    required this.colorScheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;

    // Draw field lines
    final fieldPaint =
        Paint()
          ..color = colorScheme.primary.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    for (int i = 0; i < 8; i++) {
      final angle = i * (2 * pi / 8);
      final dx = x * 0.1 * radius * cos(angle);
      final dy = y * 0.1 * radius * sin(angle);

      canvas.drawCircle(
        center + Offset(dx, dy),
        radius * (0.3 + strength * 0.7),
        fieldPaint,
      );
    }

    // Draw compass needle
    final angle = atan2(y, x);
    final needlePaint =
        Paint()
          ..color = colorScheme.error
          ..style = PaintingStyle.fill;

    final needlePath =
        Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(
            center.dx + radius * 0.8 * cos(angle + pi),
            center.dy + radius * 0.8 * sin(angle + pi),
          )
          ..lineTo(
            center.dx + radius * 0.2 * cos(angle + pi / 2),
            center.dy + radius * 0.2 * sin(angle + pi / 2),
          )
          ..close();

    canvas.drawPath(needlePath, needlePaint);

    // Draw center point
    canvas.drawCircle(center, 5, Paint()..color = colorScheme.onSurface);
  }

  @override
  bool shouldRepaint(covariant _MagneticFieldPainter oldDelegate) {
    return x != oldDelegate.x ||
        y != oldDelegate.y ||
        z != oldDelegate.z ||
        strength != oldDelegate.strength ||
        colorScheme != oldDelegate.colorScheme;
  }
}
