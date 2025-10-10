import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../src/features/compass/providers/compass_provider.dart';

class CompassScreen extends ConsumerWidget {
  const CompassScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compassData = ref.watch(compassProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Compass',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            isDark ? Colors.deepPurple.shade800 : Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(compassProvider.notifier).calibrate(),
            tooltip: 'Calibrate',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                isDark
                    ? [Colors.deepPurple.shade900, Colors.indigo.shade900]
                    : [Colors.deepPurple.shade100, Colors.indigo.shade100],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Compass Visualization
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.white54 : Colors.black54,
                        width: 2,
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: ((compassData.heading ?? 0) * (math.pi / 180) * -1),
                    child: Image.asset(
                      'assets/images/compass.png',
                      width: 250,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (compassData.isCalibrating)
                    Positioned(
                      bottom: 20,
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 8),
                          Text(
                            'Calibrating...',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),

              // Direction Indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.deepPurple.shade700 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.explore,
                      color: isDark ? Colors.amber : Colors.deepPurple,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      compassData.currentDirection,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Heading Display
              Text(
                compassData.headingWithUnit,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Magnetic Heading',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),

              // Accuracy Indicator
              if (compassData.hasValidReading) ...[
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: isDark ? Colors.greenAccent : Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'High Accuracy',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ] else if (compassData.hasError) ...[
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: isDark ? Colors.redAccent : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Compass Error',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),

      // Bottom Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(compassProvider.notifier).calibrate(),
        backgroundColor: isDark ? Colors.amber : Colors.deepPurple,
        child: Icon(Icons.refresh, color: isDark ? Colors.black : Colors.white),
      ),
    );
  }
}
