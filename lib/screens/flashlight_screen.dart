import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io' show Platform;

class FlashlightScreen extends StatefulWidget {
  const FlashlightScreen({super.key});

  @override
  State<FlashlightScreen> createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends State<FlashlightScreen> {
  final TorchController controller = TorchController();
  bool _isInitialized = false;
  bool _isOn = false;
  double _intensity = 0.5;
  bool _supportsIntensity = false;

  @override
  void initState() {
    super.initState();
    _initializeFlashlight();
    _supportsIntensity = Platform.isIOS;
  }

  Future<void> _initializeFlashlight() async {
    controller.initialize();
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  Future<void> _toggleFlash() async {
    if (_isOn) {
      await controller.toggle();
    } else {
      await controller.toggle(
        intensity: _supportsIntensity ? _intensity : null,
      );
    }
    if (mounted) {
      setState(() => _isOn = !_isOn);
    }
  }

  Future<void> _setIntensity(double value) async {
    setState(() => _intensity = value);
    if (_isOn && _supportsIntensity) {
      await controller.toggle(intensity: _intensity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = colorScheme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashlight'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child:
                _isInitialized
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Flashlight Button
                        GestureDetector(
                          onTap: _toggleFlash,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  _isOn
                                      ? colorScheme.primaryContainer
                                      : colorScheme.surfaceVariant,
                              boxShadow:
                                  _isOn
                                      ? [
                                        BoxShadow(
                                          color: colorScheme.primary
                                              .withOpacity(0.3),
                                          blurRadius: 30,
                                          spreadRadius: 10,
                                        ),
                                      ]
                                      : null,
                              border: Border.all(
                                color:
                                    _isOn
                                        ? colorScheme.primary
                                        : colorScheme.outline.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              _isOn ? Iconsax.flash_1 : Iconsax.flash_slash,
                              size: 60,
                              color:
                                  _isOn
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Status Indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _isOn
                                    ? colorScheme.primary.withOpacity(0.1)
                                    : colorScheme.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  _isOn
                                      ? colorScheme.primary
                                      : colorScheme.error,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _isOn ? 'ACTIVE' : 'INACTIVE',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  _isOn
                                      ? colorScheme.primary
                                      : colorScheme.error,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Intensity Control (iOS only)
                        if (_supportsIntensity)
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Intensity: ${(_intensity * 100).toInt()}%',
                                  style: TextStyle(
                                    color: colorScheme.onSurface.withOpacity(
                                      0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Slider(
                                  value: _intensity,
                                  onChanged: _setIntensity,
                                  min: 0.1,
                                  max: 1.0,
                                  divisions: 9,
                                  activeColor: colorScheme.primary,
                                  inactiveColor: colorScheme.surfaceVariant,
                                ),
                              ],
                            ),
                          )
                        else
                          Text(
                            'Tap the circle to toggle flashlight',
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                      ],
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: colorScheme.primary),
                        const SizedBox(height: 20),
                        Text(
                          'Initializing flashlight...',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
