import 'package:flutter/material.dart';

class HumidityScreen extends StatefulWidget {
  const HumidityScreen({super.key});

  @override
  State<HumidityScreen> createState() => _HumidityScreenState();
}

class _HumidityScreenState extends State<HumidityScreen> {
  double _humidity = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateHumidity();
  }

  Future<void> _simulateHumidity() async {
    // Note: Most phones don't have humidity sensors
    // This is a simulation for demo purposes
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _humidity = 45 + Random().nextDouble() * 30; // Random between 45-75%
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Humidity Sensor')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CustomPaint(
                        painter: _HumidityPainter(humidity: _humidity),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      '${_humidity.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _getHumidityDescription(_humidity),
                      style: TextStyle(
                        fontSize: 18,
                        color: _getHumidityColor(_humidity),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildComfortIndicator(),
                  ],
                ),
              ),
    );
  }

  Widget _buildComfortIndicator() {
    final comfortLevel = _calculateComfortLevel(_humidity);

    return Column(
      children: [
        const Text(
          'Comfort Level',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 200,
          height: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: comfortLevel,
              backgroundColor: Colors.grey.shade200,
              color: _getComfortColor(comfortLevel),
              minHeight: 20,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [Text('Dry'), Text('Ideal'), Text('Humid')],
        ),
      ],
    );
  }

  double _calculateComfortLevel(double humidity) {
    // Returns 0-1 where 0.3-0.7 is ideal
    if (humidity < 30) return humidity / 30 * 0.3;
    if (humidity < 70) return 0.3 + (humidity - 30) / 40 * 0.4;
    return 0.7 + (humidity - 70) / 30 * 0.3;
  }

  Color _getComfortColor(double comfortLevel) {
    if (comfortLevel < 0.3) return Colors.orange;
    if (comfortLevel < 0.7) return Colors.green;
    return Colors.red;
  }

  String _getHumidityDescription(double humidity) {
    if (humidity < 30) return 'Dry air';
    if (humidity < 40) return 'Pleasantly dry';
    if (humidity < 60) return 'Comfortable';
    if (humidity < 70) return 'Slightly humid';
    return 'Humid';
  }

  Color _getHumidityColor(double humidity) {
    if (humidity < 30) return Colors.orange;
    if (humidity < 60) return Colors.green;
    return Colors.red;
  }
}

class _HumidityPainter extends CustomPainter {
  final double humidity;

  _HumidityPainter({required this.humidity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;
    final fillAngle = 2 * 3.1416 * (humidity / 100);
    final color = _getHumidityColor(humidity);

    // Draw background circle
    final bgPaint =
        Paint()
          ..color = Colors.grey.shade200
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Draw filled portion
    final fillPaint =
        Paint()
          ..color = color.withOpacity(0.3)
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(center.dx, center.dy - radius)
          ..arcTo(
            Rect.fromCircle(center: center, radius: radius),
            -3.1416 / 2,
            fillAngle,
            false,
          )
          ..close();

    canvas.drawPath(path, fillPaint);

    // Draw outline
    final outlinePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
    canvas.drawCircle(center, radius, outlinePaint);

    // Draw drop icon
    final dropPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final dropPath =
        Path()
          ..moveTo(center.dx, center.dy - radius * 0.3)
          ..quadraticBezierTo(
            center.dx + radius * 0.3,
            center.dy - radius * 0.1,
            center.dx,
            center.dy + radius * 0.4,
          )
          ..quadraticBezierTo(
            center.dx - radius * 0.3,
            center.dy - radius * 0.1,
            center.dx,
            center.dy - radius * 0.3,
          );

    canvas.drawPath(dropPath, dropPaint);
  }

  Color _getHumidityColor(double humidity) {
    if (humidity < 30) return Colors.orange;
    if (humidity < 60) return Colors.green;
    return Colors.red;
  }

  @override
  bool shouldRepaint(covariant _HumidityPainter oldDelegate) {
    return humidity != oldDelegate.humidity;
  }
}
