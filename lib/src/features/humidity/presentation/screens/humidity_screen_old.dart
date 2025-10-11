import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:math';

class HumidityScreen extends StatefulWidget {
  const HumidityScreen({super.key});

  @override
  State<HumidityScreen> createState() => _HumidityScreenState();
}

class _HumidityScreenState extends State<HumidityScreen> {
  double _humidity = 0;
  bool _isLoading = true;
  bool _hasSensor = true;
  bool _permissionGranted = true;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndSensor();
  }

  Future<void> _checkPermissionsAndSensor() async {
    // Check if we need environmental sensors permission
    // Note: Most Android devices don't require special permissions for humidity
    // This is a placeholder for actual permission checks if needed

    // Check if device has humidity sensor (simulated check)
    final hasHumiditySensor = await _checkHumidityAvailability();

    if (!hasHumiditySensor) {
      setState(() {
        _hasSensor = false;
        _isLoading = false;
      });
      return;
    }

    // Get data if we have permission and sensor
    _simulateHumidity();
  }

  Future<bool> _checkHumidityAvailability() async {
    // This is a simulation - in a real app you'd use:
    // await SensorManager().isSensorAvailable(Sensors.RELATIVE_HUMIDITY);
    // Using sensor_plus package or similar
    return false; // Most phones don't have humidity sensors
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Humidity'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _buildContent(colorScheme),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ColorScheme colorScheme) {
    if (!_permissionGranted) {
      return _buildPermissionDeniedView(colorScheme);
    }

    if (!_hasSensor) {
      return _buildNoSensorView(colorScheme);
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final humidityColor = _getHumidityColor(_humidity, colorScheme);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Humidity Visualization
        SizedBox(
          width: 200,
          height: 200,
          child: CustomPaint(
            painter: _HumidityPainter(
              humidity: _humidity,
              colorScheme: colorScheme,
            ),
          ),
        ),
        const SizedBox(height: 40),

        // Humidity Value
        Text(
          '${_humidity.toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: humidityColor,
          ),
        ),
        const SizedBox(height: 8),

        // Humidity Description
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
          ),
          child: Text(
            _getHumidityDescription(_humidity),
            style: TextStyle(color: humidityColor, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 40),

        // Comfort Level Indicator
        _buildComfortIndicator(colorScheme),
      ],
    );
  }

  Widget _buildComfortIndicator(ColorScheme colorScheme) {
    final comfortLevel = _calculateComfortLevel(_humidity);
    final comfortColor = _getComfortColor(comfortLevel, colorScheme);

    return Column(
      children: [
        Text(
          'Comfort Level',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: comfortLevel,
              backgroundColor: colorScheme.surfaceVariant,
              color: comfortColor,
              minHeight: 12,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dry',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
            ),
            Text(
              'Ideal',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
            ),
            Text(
              'Humid',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPermissionDeniedView(ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Iconsax.warning_2, size: 60, color: colorScheme.error),
        const SizedBox(height: 20),
        Text(
          'Permission Required',
          style: TextStyle(
            fontSize: 18,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Sensor permission is needed to measure humidity',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => openAppSettings(),
          child: const Text('Open Settings'),
        ),
      ],
    );
  }

  Widget _buildNoSensorView(ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Iconsax.warning_2, size: 60, color: colorScheme.error),
        const SizedBox(height: 20),
        Text(
          'Humidity Sensor Not Available',
          style: TextStyle(
            fontSize: 18,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'This device doesn\'t have a humidity sensor',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
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

  Color _getComfortColor(double comfortLevel, ColorScheme colorScheme) {
    if (comfortLevel < 0.3) return colorScheme.primary;
    if (comfortLevel < 0.7) return colorScheme.secondary;
    return colorScheme.error;
  }

  String _getHumidityDescription(double humidity) {
    if (humidity < 30) return 'Dry air';
    if (humidity < 40) return 'Pleasantly dry';
    if (humidity < 60) return 'Comfortable';
    if (humidity < 70) return 'Slightly humid';
    return 'Humid';
  }

  Color _getHumidityColor(double humidity, ColorScheme colorScheme) {
    if (humidity < 30) return colorScheme.primary;
    if (humidity < 60) return colorScheme.secondary;
    return colorScheme.error;
  }
}

class _HumidityPainter extends CustomPainter {
  final double humidity;
  final ColorScheme colorScheme;

  _HumidityPainter({required this.humidity, required this.colorScheme});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;
    final fillAngle = 2 * pi * (humidity / 100);
    final color = _getHumidityColor(humidity);

    // Draw background circle
    final bgPaint =
        Paint()
          ..color = colorScheme.surfaceVariant
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Draw filled portion
    final fillPaint =
        Paint()
          ..color = color.withOpacity(0.2)
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(center.dx, center.dy - radius)
          ..arcTo(
            Rect.fromCircle(center: center, radius: radius),
            -pi / 2,
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
    if (humidity < 30) return colorScheme.primary;
    if (humidity < 60) return colorScheme.secondary;
    return colorScheme.error;
  }

  @override
  bool shouldRepaint(covariant _HumidityPainter oldDelegate) {
    return humidity != oldDelegate.humidity ||
        colorScheme != oldDelegate.colorScheme;
  }
}
