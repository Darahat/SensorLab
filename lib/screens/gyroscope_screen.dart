import 'package:flutter/material.dart';
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
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;
      });
      _controller.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gyroscope')),
      body: Center(
        child: AnimatedBuilder(
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
                  gradient: RadialGradient(
                    colors: [Colors.blue.shade300, Colors.blue.shade800],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Iconsax.cpu, size: 60, color: Colors.white),
                    Positioned(
                      top: 30,
                      child: Text(
                        'X: ${_x.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      child: Text(
                        'Y: ${_y.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Positioned(
                      left: 30,
                      child: Text(
                        'Z: ${_z.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Positioned(
                      right: 30,
                      child: Text(
                        'Rad/s',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
