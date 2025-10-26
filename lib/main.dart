import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/app.dart';
import 'package:sensorlab/src/core/services/initialization_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  bool initializationSuccess = false;

  // Show immediate loading screen
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Initializing SensorLab...'),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  try {
    await container.read(initializationServiceProvider).initialize();
    initializationSuccess = true;
  } catch (e) {
    print('Initialization failed: $e');

    // Show error screen
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 20),
                  Text(
                    'Initialization Failed',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(e.toString(), textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => main(), // Restart the app
                    child: Text('Restart App'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return;
  }

  // Only run the main app if initialization was successful
  if (initializationSuccess) {
    runApp(UncontrolledProviderScope(container: container, child: const App()));
  }
}
