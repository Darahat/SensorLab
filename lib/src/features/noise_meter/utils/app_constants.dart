class AppConstants {
  static const String appName = 'SensorLab';
  static const String appVersion = '1.0.0';

  // Noise Meter Constants
  static const double maxNoiseLevel = 120.0;
  static const double minNoiseLevel = 0.0;
  static const Duration recordingInterval = Duration(milliseconds: 100);
  static const Duration chartUpdateInterval = Duration(seconds: 1);

  // Noise Level Thresholds
  static const double quietThreshold = 30.0;
  static const double moderateThreshold = 60.0;
  static const double loudThreshold = 85.0;
  static const double veryLoudThreshold = 100.0;
}

class AssetConstants {
  static const String iconsPath = 'assets/icons/';
  static const String imagesPath = 'assets/images/';
  static const String soundsPath = 'assets/sounds/';
}

class RouteConstants {
  static const String noiseMeter = '/noise-meter';
  static const String acousticPresets = '/acoustic-presets';
  static const String acousticReports = '/acoustic-reports';
}
