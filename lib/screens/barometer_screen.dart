import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class BarometerScreen extends StatefulWidget {
  const BarometerScreen({super.key});

  @override
  State<BarometerScreen> createState() => _BarometerScreenState();
}

class _BarometerScreenState extends State<BarometerScreen> {
  double _pressure = 1013.25; // Default sea level pressure in hPa
  double _altitude = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getBarometricData();
  }

  Future<void> _getBarometricData() async {
    // In a real app, you would get actual sensor data here
    // This is a simulation for demo purposes
    await Future.delayed(const Duration(seconds: 1));

    final position = await Geolocator.getCurrentPosition();

    setState(() {
      // Simulate pressure based on altitude
      _pressure = 1013.25 * pow(1 - (position.altitude / 44330), 5.255);
      _altitude = position.altitude;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barometer')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_pressure.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'hPa',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 40),
                            _buildPressureGauge(),
                          ],
                        ),
                      ),
                    ),
                    _buildAltitudeCard(),
                  ],
                ),
              ),
    );
  }

  Widget _buildPressureGauge() {
    final normalizedPressure = (_pressure - 950) / (1050 - 950);
    final color = _getPressureColor(_pressure);

    return SizedBox(
      width: 300,
      height: 150,
      child: Stack(
        children: [
          // Gauge background
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade300,
                  Colors.green.shade300,
                  Colors.yellow.shade300,
                  Colors.red.shade300,
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
          // Pressure indicator
          Positioned(
            left: normalizedPressure.clamp(0, 1) * 300 - 15,
            top: 10,
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Iconsax.arrow_down, color: Colors.white),
                ),
                const SizedBox(height: 5),
                Container(width: 2, height: 100, color: color),
              ],
            ),
          ),
          // Labels
          Positioned(
            bottom: 10,
            left: 0,
            child: Text('950', style: TextStyle(color: Colors.blue.shade800)),
          ),
          Positioned(
            bottom: 10,
            left: 120,
            child: Text('1000', style: TextStyle(color: Colors.green.shade800)),
          ),
          Positioned(
            bottom: 10,
            right: 0,
            child: Text('1050', style: TextStyle(color: Colors.red.shade800)),
          ),
        ],
      ),
    );
  }

  Color _getPressureColor(double pressure) {
    if (pressure < 980) return Colors.blue;
    if (pressure < 1010) return Colors.green;
    if (pressure < 1030) return Colors.yellow;
    return Colors.red;
  }

  Widget _buildAltitudeCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Iconsax.location, size: 40, color: Colors.blue),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Altitude', style: TextStyle(color: Colors.grey)),
                Text(
                  '${_altitude.toStringAsFixed(2)} meters',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
