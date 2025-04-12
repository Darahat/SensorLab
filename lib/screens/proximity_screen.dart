import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityScreen extends StatefulWidget {
  const ProximityScreen({super.key});

  @override
  State<ProximityScreen> createState() => _ProximityScreenState();
}

class _ProximityScreenState extends State<ProximityScreen> {
  double _distance = 0;
  bool _isNear = false;
  bool _hasSensor = true;

  @override
  void initState() {
    super.initState();
    _checkProximitySensor();
  }

  Future<void> _checkProximitySensor() async {
    try {
      await ProximitySensor.checkSensorAvailability();
      ProximitySensor.proximityEvents.listen((ProximityEvent event) {
        setState(() {
          _distance = event.distance;
          _isNear = event.isNear;
        });
      });
    } catch (e) {
      setState(() => _hasSensor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proximity Sensor')),
      body: Center(
        child:
            _hasSensor
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isNear ? Colors.red : Colors.green,
                        boxShadow: [
                          BoxShadow(
                            color:
                                _isNear
                                    ? Colors.red.withOpacity(0.5)
                                    : Colors.green.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isNear ? Iconsax.close_circle : Iconsax.tick_circle,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      _isNear ? 'NEAR' : 'FAR',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _isNear ? Colors.red : Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Distance: ${_distance.toStringAsFixed(2)} cm',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                )
                : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.warning_2, size: 60, color: Colors.orange),
                    SizedBox(height: 20),
                    Text(
                      'Proximity Sensor Not Available',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
      ),
    );
  }
}
