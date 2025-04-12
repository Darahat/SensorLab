import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';

class SoundGraphScreen extends StatefulWidget {
  const SoundGraphScreen({super.key});

  @override
  State<SoundGraphScreen> createState() => _SoundGraphScreenState();
}

class _SoundGraphScreenState extends State<SoundGraphScreen> {
  final List<double> _dbReadings = [];
  late NoiseMeter _noiseMeter;
  bool _isListening = false;
  double _maxDb = 0;

  @override
  void initState() {
    super.initState();
    _noiseMeter = NoiseMeter(onError: _onError);
  }

  void _onError(Object error) {
    setState(() => _isListening = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error: $error')));
  }

  void _startListening() {
    _noiseMeter.start().listen((NoiseReading noiseReading) {
      if (!mounted) return;
      setState(() {
        _dbReadings.add(noiseReading.maxDecibel);
        if (_dbReadings.length > 100) {
          _dbReadings.removeAt(0);
        }
        _maxDb =
            noiseReading.maxDecibel > _maxDb ? noiseReading.maxDecibel : _maxDb;
      });
    });
    setState(() => _isListening = true);
  }

  void _stopListening() {
    _noiseMeter.stop();
    setState(() => _isListening = false);
  }

  void _clearReadings() {
    setState(() {
      _dbReadings.clear();
      _maxDb = 0;
    });
  }

  @override
  void dispose() {
    _noiseMeter.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sound Level History')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: CustomPaint(
                painter: _SoundGraphPainter(
                  dbReadings: _dbReadings,
                  maxDb: _maxDb,
                  isListening: _isListening,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(_isListening ? Iconsax.stop : Iconsax.microphone),
                  label: Text(_isListening ? 'Stop' : 'Start'),
                  onPressed: _isListening ? _stopListening : _startListening,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isListening ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Iconsax.refresh),
                  label: const Text('Clear'),
                  onPressed: _clearReadings,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDecibelInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildDecibelInfo() {
    final currentDb = _dbReadings.isEmpty ? 0 : _dbReadings.last;
    final level = _getSoundLevel(currentDb);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text('Current', style: TextStyle(color: Colors.grey)),
                Text(
                  '${currentDb.toStringAsFixed(1)} dB',
                  style: const TextStyle(fontSize: 24),
                ),
                Text(level.label, style: TextStyle(color: level.color)),
              ],
            ),
            Column(
              children: [
                const Text('Max', style: TextStyle(color: Colors.grey)),
                Text(
                  '${_maxDb.toStringAsFixed(1)} dB',
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  _getSoundLevel(_maxDb).label,
                  style: TextStyle(color: _getSoundLevel(_maxDb).color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _SoundLevel _getSoundLevel(double db) {
    if (db < 30) return _SoundLevel('Very Quiet', Colors.green);
    if (db < 50) return _SoundLevel('Quiet', Colors.lightGreen);
    if (db < 70) return _SoundLevel('Moderate', Colors.yellow);
    if (db < 90) return _SoundLevel('Loud', Colors.orange);
    return _SoundLevel('Very Loud', Colors.red);
  }
}

class _SoundGraphPainter extends CustomPainter {
  final List<double> dbReadings;
  final double maxDb;
  final bool isListening;

  _SoundGraphPainter({
    required this.dbReadings,
    required this.maxDb,
    required this.isListening,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.blue;

    final bgPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.blue.withOpacity(0.1);

    final path = Path();
    final effectiveMaxDb = maxDb < 60 ? 80 : maxDb + 20;

    if (dbReadings.isNotEmpty) {
      path.moveTo(
        0,
        size.height - (dbReadings[0] / effectiveMaxDb * size.height),
      );

      for (int i = 1; i < dbReadings.length; i++) {
        final x = i / dbReadings.length * size.width;
        final y = size.height - (dbReadings[i] / effectiveMaxDb * size.height);
        path.lineTo(x, y);
      }

      // Close path for fill
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      canvas.drawPath(path, bgPaint);
      canvas.drawPath(path, paint);
    }

    // Draw threshold lines
    final thresholdPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.grey.withOpacity(0.5);

    const thresholds = [30, 50, 70, 90];
    for (final threshold in thresholds) {
      final y = size.height - (threshold / effectiveMaxDb * size.height);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), thresholdPaint);

      // Draw threshold labels
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$threshold dB',
          style: TextStyle(color: Colors.grey, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(size.width - textPainter.width - 5, y - 10),
      );
    }

    // Draw current position indicator
    if (isListening && dbReadings.isNotEmpty) {
      final currentX = size.width;
      final currentY =
          size.height - (dbReadings.last / effectiveMaxDb * size.height);

      final indicatorPaint =
          Paint()
            ..color = Colors.red
            ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(currentX, currentY), 5, indicatorPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SoundGraphPainter oldDelegate) {
    return dbReadings != oldDelegate.dbReadings ||
        isListening != oldDelegate.isListening;
  }
}

class _SoundLevel {
  final String label;
  final Color color;

  _SoundLevel(this.label, this.color);
}
