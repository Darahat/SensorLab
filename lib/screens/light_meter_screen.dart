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

  @override
  void initState() {
    super.initState();
    _light = Light();
    _startListening();
  }

  void _startListening() {
    _lightSubscription = _light?.lightSensorStream.listen((luxValue) {
      if (mounted) {
        setState(() {
          _luxValue = luxValue;
        });
      }
    });
  }

  @override
  void dispose() {
    _lightSubscription?.cancel(); // Cancel the stream subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Light Meter',
          style: TextStyle(
            color: Color(0xFFFAFAFA),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wb_sunny, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            Text(
              'Light Level: $_luxValue lux',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
