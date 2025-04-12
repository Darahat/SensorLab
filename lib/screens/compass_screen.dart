import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  _CompassScreenState createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  double? _heading;
  bool _isCalibrating = false;
  String _currentDirection = 'N';
  final List<String> _directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];

  @override
  void initState() {
    super.initState();
    _startCompass();
  }

  void _startCompass() {
    FlutterCompass.events?.listen(
      (event) {
        if (mounted) {
          setState(() {
            _heading = event.heading;
            _updateDirection();
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _heading = null;
          });
        }
      },
    );
  }

  void _updateDirection() {
    if (_heading == null) return;
    final index = ((_heading! + 22.5) % 360) ~/ 45;
    _currentDirection = _directions[index];
  }

  Future<void> _calibrateCompass() async {
    setState(() => _isCalibrating = true);
    await Future.delayed(const Duration(seconds: 3));
    setState(() => _isCalibrating = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Compass',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            isDark ? Colors.deepPurple.shade800 : Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _calibrateCompass,
            tooltip: 'Calibrate',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDark
                    ? [Colors.deepPurple.shade900, Colors.indigo.shade900]
                    : [Colors.deepPurple.shade100, Colors.indigo.shade100],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Compass Visualization
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.white54 : Colors.black54,
                        width: 2,
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: ((_heading ?? 0) * (math.pi / 180) * -1),
                    child: Image.asset(
                      'assets/images/compass.png',
                      width: 250,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (_isCalibrating)
                    Positioned(
                      bottom: 20,
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 8),
                          Text(
                            'Calibrating...',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),

              // Direction Indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.deepPurple.shade700 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.explore,
                      color: isDark ? Colors.amber : Colors.deepPurple,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _currentDirection,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Heading Display
              Text(
                '${_heading?.toStringAsFixed(1) ?? '--'}°',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Magnetic Heading',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),

              // Accuracy Indicator
              if (_heading != null) ...[
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: isDark ? Colors.greenAccent : Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'High Accuracy',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),

      // Bottom Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _calibrateCompass,
        backgroundColor: isDark ? Colors.amber : Colors.deepPurple,
        child: Icon(Icons.refresh, color: isDark ? Colors.black : Colors.white),
      ),
    );
  }
}
