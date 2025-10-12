// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SensorLab';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get welcome => 'Welcome';

  @override
  String get home => 'Home';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get search => 'Search';

  @override
  String get settings => 'Settings';

  @override
  String get retry => 'Retry';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Loading';

  @override
  String get failedToLoadSettings => 'Failed to load settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get switchBetweenLightAndDarkThemes =>
      'Switch between light and dark themes';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get notificationsAndFeedback => 'Notifications & Feedback';

  @override
  String get notifications => 'Notifications';

  @override
  String get receiveAppNotifications => 'Receive app notifications';

  @override
  String get vibration => 'Vibration';

  @override
  String get hapticFeedbackForInteractions =>
      'Haptic feedback for interactions';

  @override
  String get soundEffects => 'Sound Effects';

  @override
  String get audioFeedbackForAppActions => 'Audio feedback for app actions';

  @override
  String get sensorSettings => 'Sensor Settings';

  @override
  String get autoScan => 'Auto Scan';

  @override
  String get automaticallyScanWhenOpeningScanner =>
      'Automatically scan when opening scanner';

  @override
  String get sensorUpdateFrequency => 'Sensor Update Frequency';

  @override
  String sensorUpdateFrequencySubtitle(int frequency) {
    return '${frequency}ms intervals';
  }

  @override
  String get privacyAndData => 'Privacy & Data';

  @override
  String get dataCollection => 'Data Collection';

  @override
  String get allowAnonymousUsageAnalytics => 'Allow anonymous usage analytics';

  @override
  String get privacyMode => 'Privacy Mode';

  @override
  String get enhancedPrivacyProtection => 'Enhanced privacy protection';

  @override
  String get appSupport => 'App Support';

  @override
  String get showAds => 'Show Ads';

  @override
  String get supportAppDevelopment => 'Support app development';

  @override
  String get resetSettings => 'Reset Settings';

  @override
  String get resetAllSettingsToDefaultValues =>
      'Reset all settings to their default values. This action cannot be undone.';

  @override
  String get resetToDefaults => 'Reset to Defaults';

  @override
  String get chooseSensorUpdateFrequency =>
      'Choose how often sensors should update:';

  @override
  String get fastUpdate => '50ms (Fast)';

  @override
  String get normalUpdate => '100ms (Normal)';

  @override
  String get slowUpdate => '200ms (Slow)';

  @override
  String get verySlowUpdate => '500ms (Very Slow)';

  @override
  String get apply => 'Apply';

  @override
  String get confirmReset => 'Confirm Reset';

  @override
  String get areYouSureResetSettings =>
      'Are you sure you want to reset all settings to their default values?';

  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get reset => 'Reset';

  @override
  String get accelerometer => 'Accelerometer';

  @override
  String get compass => 'Compass';

  @override
  String get flashlight => 'Flashlight';

  @override
  String get gyroscope => 'Gyroscope';

  @override
  String get health => 'Health';

  @override
  String get humidity => 'Humidity';

  @override
  String get lightMeter => 'Light Meter';

  @override
  String get magnetometer => 'Magnetometer';

  @override
  String get noiseMeter => 'Noise Meter';

  @override
  String get proximity => 'Proximity';

  @override
  String get heartRate => 'Heart Rate';

  @override
  String get calorieBurn => 'Calorie Burn';

  @override
  String get scanner => 'Scanner';

  @override
  String get qrCode => 'QR Code';

  @override
  String get barcode => 'Barcode';

  @override
  String get qrCodeScanner => 'QR Code Scanner';

  @override
  String get barcodeScanner => 'Barcode Scanner';

  @override
  String get scanResult => 'Scan Result';

  @override
  String get plainText => 'Plain Text';

  @override
  String get websiteUrl => 'Website URL';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get smsMessage => 'SMS Message';

  @override
  String get wifiNetwork => 'WiFi Network';

  @override
  String get contactInfo => 'Contact Info';

  @override
  String get location => 'Location';

  @override
  String get product => 'Product';

  @override
  String get calendarEvent => 'Calendar Event';

  @override
  String get quickResponseCode => 'Quick Response Code';

  @override
  String get europeanArticleNumber13 => 'European Article Number (13 digits)';

  @override
  String get europeanArticleNumber8 => 'European Article Number (8 digits)';

  @override
  String get universalProductCode12 => 'Universal Product Code (12 digits)';

  @override
  String get universalProductCode8 => 'Universal Product Code (8 digits)';

  @override
  String get code128 => 'Code 128 (Variable length)';

  @override
  String get code39 => 'Code 39 (Alphanumeric)';

  @override
  String get code93 => 'Code 93 (Alphanumeric)';

  @override
  String get codabar => 'Codabar (Numeric with special chars)';

  @override
  String get interleaved2of5 => 'Interleaved 2 of 5';

  @override
  String get dataMatrix => 'Data Matrix (2D)';

  @override
  String get aztecCode => 'Aztec Code (2D)';

  @override
  String get torchNotAvailableOnDevice => 'Torch not available on this device';

  @override
  String get failedToInitializeFlashlight => 'Failed to initialize flashlight';

  @override
  String get failedToToggleFlashlight => 'Failed to toggle flashlight';

  @override
  String get cameraIsInUse => 'Camera is in use';

  @override
  String get torchNotAvailable => 'Torch not available';

  @override
  String get failedToEnableTorch => 'Failed to enable torch';

  @override
  String get failedToDisableTorch => 'Failed to disable torch';

  @override
  String get intensityControlNotSupported =>
      'Intensity control not supported by torch_light package';

  @override
  String get failedToSetMode => 'Failed to set mode';

  @override
  String get failedToPerformQuickFlash => 'Failed to perform quick flash';

  @override
  String get noCamerasFound => 'No cameras found';

  @override
  String get readyCoverCameraWithFinger => 'Ready - Cover camera with finger';

  @override
  String get cameraError => 'Camera error';

  @override
  String get placeFingerFirmlyOnCamera => 'Place finger firmly on camera';

  @override
  String get pressFingerFirmlyOnCamera => 'Press finger firmly on camera';

  @override
  String get fingerMovedPlaceFirmlyOnCamera =>
      'Finger moved! Place firmly on camera';

  @override
  String heartRateBpm(int bpm) {
    return 'Heart rate: $bpm BPM';
  }

  @override
  String get holdStill => 'Hold still...';

  @override
  String get adjustFingerPressure => 'Adjust finger pressure';

  @override
  String get flashError => 'Flash error';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get heightCm => 'Height (cm)';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get enterYourDetails => 'Enter Your Details';

  @override
  String get initializationFailed => 'Initialization failed';
}
