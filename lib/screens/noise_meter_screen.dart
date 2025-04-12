import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class NoiseMeterScreen extends StatefulWidget {
  const NoiseMeterScreen({super.key});

  @override
  _NoiseMeterScreenState createState() => _NoiseMeterScreenState();
}

class _NoiseMeterScreenState extends State<NoiseMeterScreen> {
  late NoiseMeter _noiseMeter;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  double _decibels = 0.0;
  bool _isRecording = false;
  List<double> _noiseReadings = [];

  @override
  void initState() {
    super.initState();
    _noiseMeter = NoiseMeter();
  }

  Future<bool> _requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  void _startListening() async {
    bool hasPermission = await _requestMicrophonePermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied')),
      );
      return;
    }

    _isRecording = true; // Ensure recording state is updated

    _noiseSubscription = _noiseMeter.noise.listen((NoiseReading noiseReading) {
      if (mounted) {
        setState(() {
          double currentDBA = noiseReading.meanDecibel - 6; // Approximate dBA
          _decibels = currentDBA;

          // Store the last 10 readings
          _noiseReadings.add(currentDBA);
          if (_noiseReadings.length > 20) {
            _noiseReadings.removeAt(0); // Keep only last 10 values
          }
        });
      }
    });
  }

  void _stopListening() {
    _noiseSubscription?.cancel();
    setState(() {
      _isRecording = false;
      _noiseReadings.clear();
    });
  }

  double getAverageDBA() {
    if (_noiseReadings.isEmpty) return 0.00; // Prevent division by zero
    double avg = _noiseReadings.reduce((a, b) => a + b) / _noiseReadings.length;
    return avg.isFinite ? avg : 0.00; // Ensure no infinity or NaN
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Noise Meter',
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
            const Icon(Icons.hearing, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              'Current Noise Level: ${_decibels.toStringAsFixed(2)} dBA',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Avg Noise Level: ${getAverageDBA().toStringAsFixed(2)} dBA',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            _isRecording
                ? ElevatedButton(
                  onPressed: _stopListening,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Stop'),
                )
                : ElevatedButton(
                  onPressed: _startListening,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Start'),
                ),
          ],
        ),
      ),
    );
  }
}
