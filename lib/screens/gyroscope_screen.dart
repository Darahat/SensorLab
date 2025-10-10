import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroscopeScreen extends StatefulWidget {
  const GyroscopeScreen({super.key});

  @override
  State<GyroscopeScreen> createState() => _GyroscopeScreenState();
}

class _GyroscopeScreenState extends State<GyroscopeScreen>
    with SingleTickerProviderStateMixin {
  double _x = 0;
  double _y = 0;
  double _z = 0;
  double _intensity = 0;
  bool _isActive = false;

  late AnimationController _controller;

  List<FlSpot> _xSpots = [];
  List<FlSpot> _ySpots = [];
  List<FlSpot> _zSpots = [];
  int _time = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    gyroscopeEventStream().listen((GyroscopeEvent event) {
      if (!_isActive) {
        setState(() => _isActive = true);
      }

      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;

        _intensity = (_x.abs() + _y.abs() + _z.abs()) / 3;

        _xSpots.add(FlSpot(_time.toDouble(), _x));
        _ySpots.add(FlSpot(_time.toDouble(), _y));
        _zSpots.add(FlSpot(_time.toDouble(), _z));

        if (_xSpots.length > 50) {
          _xSpots.removeAt(0);
          _ySpots.removeAt(0);
          _zSpots.removeAt(0);
        }

        _time++;
      });

      _controller.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  LineChartData _buildLineChart() {
    return LineChartData(
      minY: -5,
      maxY: 5,
      titlesData: FlTitlesData(show: false),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: _xSpots,
          isCurved: true,
          color: Colors.red,
          dotData: FlDotData(show: false),
          barWidth: 2,
        ),
        LineChartBarData(
          spots: _ySpots,
          isCurved: true,
          color: Colors.green,
          dotData: FlDotData(show: false),
          barWidth: 2,
        ),
        LineChartBarData(
          spots: _zSpots,
          isCurved: true,
          color: Colors.blue,
          dotData: FlDotData(show: false),
          barWidth: 2,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gyroscope'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Animated Circle
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform(
                        transform:
                            Matrix4.identity()
                              ..rotateX(_x * 0.1 * _controller.value)
                              ..rotateY(_y * 0.1 * _controller.value),
                        alignment: Alignment.center,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                colorScheme.primaryContainer,
                                colorScheme.primary,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                            border: Border.all(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Iconsax.activity,
                                size: 60,
                                color: colorScheme.onPrimary,
                              ),
                              Positioned(
                                top: 30,
                                child: Text(
                                  'X: ${_x.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 30,
                                child: Text(
                                  'Y: ${_y.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 30,
                                child: Text(
                                  'Z: ${_z.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // Intensity Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Motion Intensity',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _intensity.clamp(0.0, 1.0),
                        minHeight: 10,
                        backgroundColor: colorScheme.surfaceVariant.withOpacity(
                          0.4,
                        ),
                        color:
                            _intensity > 0.5
                                ? Colors.red
                                : _intensity > 0.2
                                ? Colors.orange
                                : Colors.green,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${(_intensity * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Live Graph
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Sensor Graph (X - Red, Y - Green, Z - Blue)',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: LineChart(_buildLineChart()),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Status Box
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _isActive
                              ? colorScheme.primary.withOpacity(0.1)
                              : colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color:
                            _isActive
                                ? colorScheme.primary
                                : colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _isActive ? 'ACTIVE' : 'MOVE YOUR DEVICE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            _isActive
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Angular velocity (rad/s)',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
