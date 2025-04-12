import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'dart:async';

class LightMeterScreen extends StatefulWidget {
  const LightMeterScreen({super.key});

  @override
  _LightMeterScreenState createState() => _LightMeterScreenState();
}

class _LightMeterScreenState extends State<LightMeterScreen> {
  Light? _light;
  int _luxValue = 0;
  StreamSubscription<int>? _lightSubscription;
  bool _isDarkMode = false;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _initLightSensor();
  }

  void _initLightSensor() async {
    try {
      _light = Light();
      _startListening();
    } catch (e) {
      if (mounted) {
        setState(() {
          _luxValue = -1; // Error state
        });
      }
    }
  }

  void _startListening() {
    _lightSubscription = _light?.lightSensorStream.listen(
      (luxValue) {
        if (mounted) {
          setState(() {
            _luxValue = luxValue;
            _isDarkMode = luxValue < 10; // Threshold for dark mode
            _scale =
                1.0 + (luxValue.clamp(0, 1000) / 5000); // Subtle pulse effect
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _luxValue = -1; // Error state
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _lightSubscription?.cancel();
    super.dispose();
  }

  String _getLightCondition(int lux) {
    if (lux < 0) return 'Sensor Error';
    if (lux < 10) return 'Pitch Black';
    if (lux < 50) return 'Very Dark';
    if (lux < 200) return 'Dim';
    if (lux < 1000) return 'Normal';
    if (lux < 5000) return 'Bright';
    return 'Very Bright';
  }

  Color _getLightColor(int lux) {
    if (lux < 0) return Colors.red;
    if (lux < 10) return Colors.blueGrey;
    if (lux < 50) return Colors.indigo;
    if (lux < 200) return Colors.blue;
    if (lux < 1000) return Colors.green;
    if (lux < 5000) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool systemDarkMode = theme.brightness == Brightness.dark;
    final bool useDarkMode = _luxValue < 10 || systemDarkMode;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Light Meter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            useDarkMode ? Colors.deepPurple.shade800 : Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                useDarkMode
                    ? [Colors.deepPurple.shade900, Colors.indigo.shade900]
                    : [Colors.deepPurple.shade100, Colors.indigo.shade100],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Light Icon
              AnimatedScale(
                scale: _scale,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  _luxValue < 0 ? Icons.error_outline : Icons.wb_sunny,
                  size: 100,
                  color: _getLightColor(_luxValue),
                ),
              ),
              const SizedBox(height: 30),

              // Light Value Display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color:
                      useDarkMode ? Colors.deepPurple.shade700 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _luxValue < 0 ? '--' : '$_luxValue',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: useDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      'lux',
                      style: TextStyle(
                        fontSize: 20,
                        color: useDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Light Condition Indicator
              Text(
                _getLightCondition(_luxValue),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _getLightColor(_luxValue),
                ),
              ),
              const SizedBox(height: 10),

              // Visual Indicator
              Container(
                width: 200,
                height: 20,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: useDarkMode ? Colors.black26 : Colors.white70,
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor:
                      _luxValue < 0 ? 0 : (_luxValue / 5000).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.green,
                          Colors.yellow,
                          Colors.orange,
                          Colors.red,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Information Text
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _luxValue < 0
                      ? 'Could not access light sensor. Please check permissions.'
                      : 'The current light level is ${_getLightCondition(_luxValue).toLowerCase()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: useDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {}), // Refresh
        backgroundColor: useDarkMode ? Colors.amber : Colors.deepPurple,
        child: Icon(
          Icons.refresh,
          color: useDarkMode ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('About Light Meter'),
            content: const Text(
              'This sensor measures ambient light levels in lux (lx).\n\n'
              'Typical light levels:\n'
              '• Moonlight: 1 lx\n'
              '• Room lighting: 50-300 lx\n'
              '• Office lighting: 300-500 lx\n'
              '• Full daylight: 10,000-25,000 lx',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
