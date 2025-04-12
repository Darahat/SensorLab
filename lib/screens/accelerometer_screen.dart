import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerScreen extends StatefulWidget {
  const AccelerometerScreen({super.key});

  @override
  State<AccelerometerScreen> createState() => _AccelerometerScreenState();
}

class _AccelerometerScreenState extends State<AccelerometerScreen> {
  double _x = 0;
  double _y = 0;
  double _z = 0;
  double _maxX = 0;
  double _maxY = 0;
  double _maxZ = 0;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;

        // Update max values
        _maxX = _x.abs() > _maxX ? _x.abs() : _maxX;
        _maxY = _y.abs() > _maxY ? _y.abs() : _maxY;
        _maxZ = _z.abs() > _maxZ ? _z.abs() : _maxZ;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accelerometer'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh),
            onPressed:
                () => setState(() {
                  _maxX = 0;
                  _maxY = 0;
                  _maxZ = 0;
                }),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _build3DIndicator(),
            const SizedBox(height: 30),
            _buildDataTable(),
            const SizedBox(height: 20),
            _buildGauge('X-Axis', _x, Colors.pink),
            _buildGauge('Y-Axis', _y, Colors.blue),
            _buildGauge('Z-Axis', _z, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _build3DIndicator() {
    return SizedBox(
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: Offset(_x * 5, -_y * 5),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.pink.withOpacity(0.8), Colors.pink],
                  stops: const [0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          const Icon(Iconsax.cube, size: 40, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.withOpacity(0.3)),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Axis',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Current',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Max', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        _buildTableRow('X', _x, _maxX),
        _buildTableRow('Y', _y, _maxY),
        _buildTableRow('Z', _z, _maxZ),
      ],
    );
  }

  TableRow _buildTableRow(String axis, double value, double maxValue) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: Text(axis)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value.toStringAsFixed(2)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(maxValue.toStringAsFixed(2)),
        ),
      ],
    );
  }

  Widget _buildGauge(String label, double value, Color color) {
    final normalizedValue = value.clamp(-10, 10) / 10;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 20,
                width: (normalizedValue.abs() *
                        MediaQuery.of(context).size.width /
                        2.5)
                    .clamp(0, MediaQuery.of(context).size.width / 2.5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment:
                    normalizedValue > 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 5,
                child: Container(
                  height: 20,
                  width: 2,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          Align(
            alignment:
                normalizedValue > 0
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                value.toStringAsFixed(2),
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
