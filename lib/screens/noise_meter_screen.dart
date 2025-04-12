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
  bool _showPermissionRequest = false;
  bool _permissionGranted = false;
  List<double> _noiseReadings = [];
  bool _isDarkMode = false;
  double _scale = 1.0;
  double _maxDB = 0.0;

  @override
  void initState() {
    super.initState();
    _noiseMeter = NoiseMeter();
    _checkPermissionStatus();
  }

  Future<void> _checkPermissionStatus() async {
    final status = await Permission.microphone.status;
    setState(() {
      _permissionGranted = status.isGranted;
    });
  }

  Future<void> _requestPermission() async {
    final status = await Permission.microphone.request();
    setState(() {
      _permissionGranted = status.isGranted;
      _showPermissionRequest = !_permissionGranted;
    });

    if (_permissionGranted) {
      _startListening();
    }
  }

  void _startListening() {
    if (!_permissionGranted) {
      setState(() => _showPermissionRequest = true);
      return;
    }

    setState(() {
      _isRecording = true;
      _noiseReadings.clear();
      _maxDB = 0.0;
    });

    _noiseSubscription = _noiseMeter.noise.listen(
      (NoiseReading noiseReading) {
        if (mounted) {
          setState(() {
            double currentDBA = noiseReading.meanDecibel - 6;
            _decibels = currentDBA;
            if (currentDBA > _maxDB) _maxDB = currentDBA;

            _noiseReadings.add(currentDBA);
            if (_noiseReadings.length > 100) {
              _noiseReadings.removeAt(0);
            }

            _scale = 1.0 + (currentDBA.clamp(0, 100) / 200);
            _isDarkMode = currentDBA > 80;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isRecording = false;
            _decibels = 0.0;
          });
        }
      },
    );
  }

  void _stopListening() {
    _noiseSubscription?.cancel();
    setState(() {
      _isRecording = false;
      _scale = 1.0;
    });
  }

  String _getNoiseLevel(double db) {
    if (db < 30) return 'Very Quiet';
    if (db < 50) return 'Quiet';
    if (db < 70) return 'Moderate';
    if (db < 85) return 'Loud';
    if (db < 100) return 'Very Loud';
    return 'Dangerous';
  }

  Color _getNoiseColor(double db) {
    if (db < 30) return Colors.green;
    if (db < 50) return Colors.lightGreen;
    if (db < 70) return Colors.yellow;
    if (db < 85) return Colors.orange;
    if (db < 100) return Colors.red;
    return Colors.deepPurple;
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool systemDarkMode = theme.brightness == Brightness.dark;
    final bool useDarkMode = _isDarkMode || systemDarkMode;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Noise Meter',
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
      body:
          _showPermissionRequest
              ? _buildPermissionRequest(useDarkMode)
              : _buildMainContent(useDarkMode, context),
    );
  }

  Widget _buildPermissionRequest(bool useDarkMode) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mic,
              size: 80,
              color: useDarkMode ? Colors.white : Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            Text(
              'Microphone Access Required',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: useDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'This app needs microphone permission to measure noise levels. '
              'We only access the microphone when you\'re actively using the noise meter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: useDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _requestPermission,
              style: ElevatedButton.styleFrom(
                backgroundColor: useDarkMode ? Colors.amber : Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: Text(
                'Allow Microphone Access',
                style: TextStyle(
                  color: useDarkMode ? Colors.black : Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => setState(() => _showPermissionRequest = false),
              child: Text(
                'Not Now',
                style: TextStyle(
                  color: useDarkMode ? Colors.white70 : Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(bool useDarkMode, BuildContext context) {
    return Container(
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
            // Animated Sound Icon
            AnimatedScale(
              scale: _scale,
              duration: const Duration(milliseconds: 100),
              child: Icon(
                Icons.hearing,
                size: 100,
                color: _getNoiseColor(_decibels),
              ),
            ),
            const SizedBox(height: 30),

            // Noise Level Display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: useDarkMode ? Colors.deepPurple.shade700 : Colors.white,
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
                    _isRecording ? _decibels.toStringAsFixed(1) : '--',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: useDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    'dBA',
                    style: TextStyle(
                      fontSize: 20,
                      color: useDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Noise Level Indicator
            Text(
              _isRecording ? _getNoiseLevel(_decibels) : 'Not Measuring',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color:
                    _isRecording
                        ? _getNoiseColor(_decibels)
                        : useDarkMode
                        ? Colors.white70
                        : Colors.black54,
              ),
            ),
            const SizedBox(height: 10),

            // Visual Meter
            Container(
              width: 250,
              height: 20,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: useDarkMode ? Colors.black26 : Colors.white70,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor:
                    _isRecording ? (_decibels / 120).clamp(0.0, 1.0) : 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Colors.green,
                        Colors.yellow,
                        Colors.orange,
                        Colors.red,
                        Colors.deepPurple,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Stats Container
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    useDarkMode
                        ? Colors.black.withOpacity(0.3)
                        : Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'MAX',
                        style: TextStyle(
                          color: useDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      Text(
                        _isRecording ? _maxDB.toStringAsFixed(1) : '--',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: useDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'AVG',
                        style: TextStyle(
                          color: useDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      Text(
                        _isRecording
                            ? (_noiseReadings.isNotEmpty
                                ? (_noiseReadings.reduce((a, b) => a + b) /
                                        _noiseReadings.length)
                                    .toStringAsFixed(1)
                                : '--')
                            : '--',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: useDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Control Button
            Padding(
              padding: const EdgeInsets.all(20),
              child:
                  _isRecording
                      ? ElevatedButton.icon(
                        onPressed: _stopListening,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        icon: const Icon(Icons.stop),
                        label: const Text('STOP MEASURING'),
                      )
                      : ElevatedButton.icon(
                        onPressed: _startListening,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        icon: const Icon(Icons.mic),
                        label: const Text('START MEASURING'),
                      ),
            ),

            if (!_permissionGranted && !_showPermissionRequest)
              TextButton(
                onPressed: () => setState(() => _showPermissionRequest = true),
                child: Text(
                  'Enable Microphone Access',
                  style: TextStyle(
                    color: useDarkMode ? Colors.white70 : Colors.deepPurple,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('About Noise Meter'),
            content: const Text(
              'This tool measures sound levels in decibels (dBA).\n\n'
              'Typical noise levels:\n'
              '• Quiet room: 30-40 dBA\n'
              '• Normal conversation: 60-70 dBA\n'
              '• City traffic: 80-90 dBA\n'
              '• Rock concert: 110-120 dBA\n'
              '• Pain threshold: 130+ dBA\n\n'
              'Prolonged exposure above 85 dBA can cause hearing damage.',
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
