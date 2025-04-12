import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

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

  @override
  void initState() {
    super.initState();
    magnetometerEvents.listen((MagnetometerEvent event) {
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
    return (x * x + y * y + z * z).sqrt();
  }

  @override
  Widget build(BuildContext context) {
    final normalizedStrength = (_strength / 1000).clamp(0, 1);
    final color = Color.lerp(Colors.green, Colors.red, normalizedStrength)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Magnetometer'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh),
            onPressed: () => setState(() => _maxStrength = 0),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_strength.toStringAsFixed(2)} μT',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Max: ${_maxStrength.toStringAsFixed(2)} μT',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CustomPaint(
                      painter: _MagneticFieldPainter(
                        x: _x,
                        y: _y,
                        z: _z,
                        strength: normalizedStrength,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildFieldIndicator('X', _x, Colors.red),
                _buildFieldIndicator('Y', _y, Colors.green),
                _buildFieldIndicator('Z', _z, Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldIndicator(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(label, style: TextStyle(color: color)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: (value.abs() / 1000).clamp(0, 1),
              backgroundColor: Colors.grey.shade200,
              color: color,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 10),
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

  _MagneticFieldPainter({
    required this.x,
    required this.y,
    required this.z,
    required this.strength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;

    // Draw field lines
    final fieldPaint =
        Paint()
          ..color = Colors.blue.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    for (int i = 0; i < 8; i++) {
      final angle = i * (2 * 3.1416 / 8);
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
          ..color = Colors.red
          ..style = PaintingStyle.fill;

    final needlePath =
        Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(
            center.dx + radius * 0.8 * cos(angle + 3.1416),
            center.dy + radius * 0.8 * sin(angle + 3.1416),
          )
          ..lineTo(
            center.dx + radius * 0.2 * cos(angle + 3.1416 / 2),
            center.dy + radius * 0.2 * sin(angle + 3.1416 / 2),
          )
          ..close();

    canvas.drawPath(needlePath, needlePaint);

    // Draw center point
    canvas.drawCircle(center, 5, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant _MagneticFieldPainter oldDelegate) {
    return x != oldDelegate.x ||
        y != oldDelegate.y ||
        z != oldDelegate.z ||
        strength != oldDelegate.strength;
  }
}
