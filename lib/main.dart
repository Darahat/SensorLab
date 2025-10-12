import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensorlab/app.dart';
import 'package:sensorlab/src/core/services/initialization_service.dart';

/// Top Level function to handle background messages

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Moved here
  // Moved here
  final container = ProviderContainer();

  try {
    await container.read(initializationServiceProvider).initialize();
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text('Initialization failed: $e'))),
      ),
    );
    return;
  }

  runApp(UncontrolledProviderScope(container: container, child: App()));
}

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:sensorlab/src/core/providers.dart';
// import 'package:sensorlab/src/core/services/hive_service.dart';
// import 'package:sensorlab/src/shared/presentation/screens/splash_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Hive
//   await Hive.initFlutter();

//   // Load environment variables from .env (optional - fails silently if missing)
//   try {
//     await dotenv.load();
//   } catch (_) {}

//   await MobileAds.instance.initialize();

//   // Note: torch_light package doesn't require initialization in main()
//   // It's handled per-use in the flashlight provider
//   debugDisableShadows = true;

//   // Create ProviderScope and run app
//   final container = ProviderContainer();

//   // Initialize HiveService
//   try {
//     await container.read(hiveServiceProvider).init();
//   } catch (e) {
//     debugPrint('Failed to initialize HiveService: $e');
//   }

//   runApp(ProviderScope(parent: container, child: const MyApp()));
// }

// class MyApp extends ConsumerStatefulWidget {
//   const MyApp({super.key});

//   @override
//   ConsumerState<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends ConsumerState<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     // Eagerly initialize AdManager through Riverpod so the first
//     // interstitial is requested early in app startup.
//     try {
//       ref.read(adManagerProvider).loadInterstitial();
//     } catch (e) {
//       debugPrint('AdManager.loadInterstitial() failed in initState: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'SensorLab',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF6C63FF),
//           brightness: Brightness.light,
//           primary: const Color(0xFF6C63FF),
//           secondary: const Color(0xFF4D8DEE),
//         ),
//         useMaterial3: true,
//         cardTheme: CardThemeData(
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           surfaceTintColor: Colors.white,
//         ),
//       ),
//       darkTheme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF6C63FF),
//           brightness: Brightness.dark,
//           primary: const Color(0xFF6C63FF),
//           secondary: const Color(0xFF4D8DEE),
//         ),
//         useMaterial3: true,
//         cardTheme: CardThemeData(
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           surfaceTintColor: Colors.grey[900],
//           color: Colors.grey[850],
//         ),
//         scaffoldBackgroundColor: Colors.black,
//         textTheme: const TextTheme(
//           bodyMedium: TextStyle(color: Colors.white70),
//           titleLarge: TextStyle(color: Colors.white),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white70),
//       ),
//       themeMode: ThemeMode.system,
//       home: const SplashScreen(),
//     );
//   }
// }
