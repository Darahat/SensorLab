import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sensorlab/screens/splash_screen.dart';
import 'package:sensorlab/src/core/providers.dart';
import 'package:torch_controller/torch_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables from .env (optional - fails silently if missing)
  try {
    await dotenv.load();
  } catch (_) {}

  await MobileAds.instance.initialize();

  // Initialize torch controller; do not await in case the plugin's
  // initialize implementation is synchronous/void in some environments.
  TorchController()
      .initialize(); // Ensure torch controller is configured before runApp
  debugDisableShadows = true;

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Eagerly initialize AdManager through Riverpod so the first
    // interstitial is requested early in app startup.
    try {
      ref.read(adManagerProvider).loadInterstitial();
    } catch (e) {
      debugPrint('AdManager.loadInterstitial() failed in initState: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SensorLab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFF4D8DEE),
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          surfaceTintColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFF4D8DEE),
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          surfaceTintColor: Colors.grey[900],
          color: Colors.grey[850],
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
