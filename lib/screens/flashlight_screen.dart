import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';

class FlashlightScreen extends StatefulWidget {
  const FlashlightScreen({super.key});

  @override
  State<FlashlightScreen> createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends State<FlashlightScreen> {
  final TorchController _torchController = TorchController();
  bool _isOn = false;
  bool _hasFlash = true;
  double _intensity = 0.5;

  @override
  void initState() {
    super.initState();
    _checkFlashAvailability();
  }

  Future<void> _checkFlashAvailability() async {
    try {
      _hasFlash = await _torchController.isTorchAvailable();
      setState(() {});
    } catch (e) {
      setState(() => _hasFlash = false);
    }
  }

  Future<void> _toggleFlash() async {
    try {
      if (_isOn) {
        await _torchController.turnOff();
      } else {
        await _torchController.turnOn(intensity: _intensity);
      }
      setState(() => _isOn = !_isOn);
    } catch (e) {
      setState(() => _hasFlash = false);
    }
  }

  Future<void> _setIntensity(double value) async {
    _intensity = value;
    if (_isOn) {
      await _torchController.turnOn(intensity: _intensity);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashlight')),
      body:
          _hasFlash
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _toggleFlash,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isOn ? Colors.yellow : Colors.grey.shade300,
                          boxShadow:
                              _isOn
                                  ? [
                                    BoxShadow(
                                      color: Colors.yellow.withOpacity(0.7),
                                      blurRadius: 50,
                                      spreadRadius: 20,
                                    ),
                                  ]
                                  : null,
                        ),
                        child: Icon(
                          _isOn ? Iconsax.flash_1 : Iconsax.flash_slash,
                          size: 60,
                          color: _isOn ? Colors.orange : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      _isOn ? 'ON' : 'OFF',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _isOn ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (_isOn)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(
                          children: [
                            const Text(
                              'Intensity',
                              style: TextStyle(fontSize: 16),
                            ),
                            Slider(
                              value: _intensity,
                              onChanged: _setIntensity,
                              min: 0.1,
                              max: 1.0,
                              divisions: 9,
                              label: (_intensity * 100).toStringAsFixed(0),
                              activeColor: Colors.yellow,
                              inactiveColor: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              )
              : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.warning_2, size: 60, color: Colors.orange),
                    SizedBox(height: 20),
                    Text(
                      'Flashlight Not Available',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
    );
  }
}
