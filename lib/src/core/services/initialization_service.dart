import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sensorlab/src/core/services/hive_service.dart';

/// Initialization Service class
/// where all kind of Initialization takes places

class InitializationService {
  /// Ref is used to any provider or service to connect with other provider/service
  final Ref ref;

  /// Initialization Service Constructor
  InitializationService(this.ref);

  /// Main Initialize function
  Future<void> initialize() async {
    /// Ensure Flutter binding is initialized

    /// Register background message handler
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      // .env file is optional, continue without it
      print('No .env file found, continuing without environment variables');
    }
    await Hive.initFlutter();

    // await FirebaseAppCheck.instance.activate(
    //   androidProvider: AndroidProvider.debug,
    //   appleProvider: AppleProvider.appAttest,
    // );
    await ref.read(hiveServiceProvider).init();
  }
}

/// initializationServiceProvider provider variable
final initializationServiceProvider = Provider<InitializationService>(
  (ref) => InitializationService(ref),
);
