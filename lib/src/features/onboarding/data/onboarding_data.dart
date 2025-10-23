import 'package:sensorlab/src/features/onboarding/domain/entities/onboarding_page.dart';

/// Data for onboarding pages - Story of using SensorLab
class OnboardingData {
  static const List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Welcome to SensorLab',
      description:
          'Your ultimate toolkit for monitoring and analyzing device sensors. Explore 15+ sensors at your fingertips.',
      animationAsset: 'assets/animations/welcome.json',
      features: [
        'Real-time sensor monitoring',
        'Data recording & analysis',
        'Custom lab experiments',
      ],
    ),
    OnboardingPage(
      title: 'Explore Sensors',
      description:
          'Access accelerometer, gyroscope, GPS, noise meter, light sensor, and 10+ more sensors. Each with live readings and beautiful visualizations.',
      animationAsset: 'assets/animations/sensors.json',
      features: [
        'Motion sensors (Accelerometer, Gyroscope)',
        'Environmental sensors (Light, Noise, Barometer)',
        'Location sensors (GPS, Compass)',
      ],
    ),
    OnboardingPage(
      title: 'Record & Analyze',
      description:
          'Start recording sensor data with a single tap. View real-time graphs, export to CSV, and track your measurements over time.',
      animationAsset: 'assets/animations/recording.json',
      features: [
        'One-tap recording',
        'Real-time graphs & charts',
        'Export data as CSV files',
      ],
    ),
    OnboardingPage(
      title: 'Create Custom Labs',
      description:
          'Design your own experiments by combining multiple sensors. Perfect for science projects, research, or data analysis.',
      animationAsset: 'assets/animations/custom_lab.json',
      features: [
        'Combine multiple sensors',
        'Set custom recording intervals',
        'Save and replay experiments',
      ],
    ),
    OnboardingPage(
      title: 'Track Your History',
      description:
          'All your recordings are automatically saved. Review past sessions, compare results, and export your data anytime.',
      animationAsset: 'assets/animations/history.json',
      features: [
        'Automatic session saving',
        'Session history & details',
        'Batch export multiple sessions',
      ],
    ),
    OnboardingPage(
      title: 'Ready to Start!',
      description:
          'You\'re all set! Start exploring sensors, create custom labs, and unlock the full potential of your device.',
      animationAsset: 'assets/animations/ready.json',
      features: [
        'No ads, completely free',
        'Offline capable',
        'Open source & privacy-focused',
      ],
    ),
  ];
}
