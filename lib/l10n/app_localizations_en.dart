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
  String get switchBetweenLightAndDarkThemes => 'Switch between light and dark themes';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle => 'Choose your preferred language';

  @override
  String get notificationsAndFeedback => 'Notifications & Feedback';

  @override
  String get notifications => 'Notifications';

  @override
  String get receiveAppNotifications => 'Receive app notifications';

  @override
  String get vibration => 'Vibration';

  @override
  String get hapticFeedbackForInteractions => 'Haptic feedback for interactions';

  @override
  String get soundEffects => 'Sound Effects';

  @override
  String get audioFeedbackForAppActions => 'Audio feedback for app actions';

  @override
  String get sensorSettings => 'Sensor Settings';

  @override
  String get autoScan => 'Auto Scan';

  @override
  String get automaticallyScanWhenOpeningScanner => 'Automatically scan when opening scanner';

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
  String get resetAllSettingsToDefaultValues => 'Reset all settings to their default values. This action cannot be undone.';

  @override
  String get resetToDefaults => 'Reset to Defaults';

  @override
  String get chooseSensorUpdateFrequency => 'Choose how often sensors should update:';

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
  String get areYouSureResetSettings => 'Are you sure you want to reset all settings to their default values?';

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
  String get speedMeter => 'Speed Meter';

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
  String get intensityControlNotSupported => 'Intensity control not supported by torch_light package';

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
  String get fingerMovedPlaceFirmlyOnCamera => 'Finger moved! Place firmly on camera';

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

  @override
  String get allYourSensorsInOnePlace => 'All your sensors in one place';

  @override
  String get noSensorsAvailable => 'No sensors available';

  @override
  String get active => 'ACTIVE';

  @override
  String get moveYourDevice => 'MOVE YOUR DEVICE';

  @override
  String get accelerationUnit => 'Acceleration (m/s²)';

  @override
  String get axis => 'Axis';

  @override
  String get current => 'Current';

  @override
  String get max => 'Max';

  @override
  String get xAxis => 'X';

  @override
  String get yAxis => 'Y';

  @override
  String get zAxis => 'Z';

  @override
  String get calibrate => 'Calibrate';

  @override
  String get calibrating => 'Calibrating...';

  @override
  String get magneticHeading => 'Magnetic Heading';

  @override
  String get highAccuracy => 'High Accuracy';

  @override
  String get compassError => 'Compass Error';

  @override
  String get resetSession => 'Reset Session';

  @override
  String get flashlightNotAvailable => 'Flashlight Not Available';

  @override
  String get initializingFlashlight => 'Initializing Flashlight...';

  @override
  String get deviceDoesNotHaveFlashlight => 'Device does not have a flashlight or it\'s not accessible';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get quickFlash => 'Quick Flash';

  @override
  String get turnOff => 'Turn Off';

  @override
  String get turnOn => 'Turn On';

  @override
  String get intensityControl => 'Intensity Control';

  @override
  String currentIntensity(String intensity) {
    return 'Current: $intensity';
  }

  @override
  String get flashlightModes => 'Flashlight Modes';

  @override
  String get normal => 'Normal';

  @override
  String get strobe => 'Strobe';

  @override
  String get sos => 'SOS';

  @override
  String get sessionStatistics => 'Session Statistics';

  @override
  String get sessionTime => 'Session Time';

  @override
  String get toggles => 'Toggles';

  @override
  String get onTime => 'On Time';

  @override
  String get batteryUsage => 'Battery Usage';

  @override
  String get batteryUsageWarning => 'Battery Usage Warning';

  @override
  String flashlightOnFor(String time) {
    return 'Flashlight has been on for $time. Consider turning it off to save battery.';
  }

  @override
  String get usageTips => 'Usage Tips';

  @override
  String get normalMode => 'Normal Mode';

  @override
  String get normalModeDescription => 'Standard flashlight operation';

  @override
  String get strobeMode => 'Strobe Mode';

  @override
  String get strobeModeDescription => 'Flashing light for attention';

  @override
  String get sosMode => 'SOS Mode';

  @override
  String get sosModeDescription => 'Emergency signal (... --- ...)';

  @override
  String get battery => 'Battery';

  @override
  String get batteryTip => 'Monitor usage to preserve battery life';

  @override
  String get intensity => 'Intensity';

  @override
  String get intensityTip => 'Adjust brightness to save power';

  @override
  String get pressButtonToGetLocation => 'Press the button to get location';

  @override
  String get addressWillAppearHere => 'Address will appear here';

  @override
  String get locationServicesDisabled => 'Location services are disabled';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get locationPermissionsPermanentlyDenied => 'Location permissions are permanently denied';

  @override
  String errorGettingLocation(String error) {
    return 'Error getting location: $error';
  }

  @override
  String failedToGetAddress(String error) {
    return 'Failed to get address: $error';
  }

  @override
  String get noAppToOpenMaps => 'No app available to open maps';

  @override
  String get geolocator => 'Geolocator';

  @override
  String accuracy(String accuracy) {
    return 'Accuracy: $accuracy';
  }

  @override
  String get pleaseEnableLocationServices => 'Please enable location services';

  @override
  String get pleaseGrantLocationPermissions => 'Please grant location permissions';

  @override
  String get locating => 'Locating...';

  @override
  String get getCurrentLocation => 'Get Current Location';

  @override
  String get openInMaps => 'Open in Maps';

  @override
  String get aboutGeolocator => 'About Geolocator';

  @override
  String get geolocatorDescription => 'This tool shows your current location using your device\'s GPS.\n\nFeatures:\n• Precise latitude/longitude coordinates\n• Estimated accuracy measurement\n• Reverse geocoding to get address\n• Open location in maps\n\nFor best results, ensure you have:\n• Location services enabled\n• Clear view of the sky\n• Internet connection for address lookup';

  @override
  String get ok => 'OK';

  @override
  String get tracking => 'Tracking';

  @override
  String get waitingForGps => 'Waiting for GPS...';

  @override
  String get maxSpeed => 'Max Speed';

  @override
  String get avgSpeed => 'Avg Speed';

  @override
  String get motionIntensity => 'Motion Intensity';

  @override
  String get liveSensorGraph => 'Live Sensor Graph (X - Red, Y - Green, Z - Blue)';

  @override
  String get angularVelocity => 'Angular velocity (rad/s)';

  @override
  String get healthTracker => 'Health Tracker';

  @override
  String helloUser(String name) {
    return 'Hello, $name!';
  }

  @override
  String readyToTrackSession(String activity) {
    return 'Ready to track your $activity session?';
  }

  @override
  String get bmi => 'BMI';

  @override
  String get bmr => 'BMR';

  @override
  String get steps => 'Steps';

  @override
  String get distance => 'Distance';

  @override
  String get duration => 'Duration';

  @override
  String get activityType => 'Activity Type';

  @override
  String get stop => 'Stop';

  @override
  String get resume => 'Resume';

  @override
  String get start => 'Start';

  @override
  String get pause => 'Pause';

  @override
  String get liveSensorData => 'Live Sensor Data';

  @override
  String get avgIntensity => 'Avg Intensity';

  @override
  String get peakIntensity => 'Peak Intensity';

  @override
  String get movements => 'Movements';

  @override
  String get caloriesBurned => 'Calories Burned';

  @override
  String bmrPerDay(String bmr) {
    return 'BMR: $bmr cal/day';
  }

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String get name => 'Name';

  @override
  String get age => 'Age';

  @override
  String get weight => 'Weight';

  @override
  String get height => 'Height';

  @override
  String get heartRateMonitor => 'Heart Rate Monitor';

  @override
  String get toggleFlash => 'Toggle flash';

  @override
  String quietEnvironmentNeeded(String seconds) {
    return 'Quiet environment needed ($seconds s)';
  }

  @override
  String get estimatedHeartRate => 'Estimated Heart Rate';

  @override
  String get flashOff => 'Flash Off';

  @override
  String get flashOn => 'Flash On';

  @override
  String get stableMeasurement => 'Stable measurement';

  @override
  String get resetData => 'Reset Data';

  @override
  String get noHumiditySensor => 'No Humidity Sensor Detected';

  @override
  String get noHumiditySensorDescription => 'Most smartphones don\'t have humidity sensors. Showing simulated data for demonstration.';

  @override
  String get checkAgain => 'Check Again';

  @override
  String get measuring => 'Measuring';

  @override
  String get stopped => 'Stopped';

  @override
  String get singleReading => 'Single Reading';

  @override
  String get continuous => 'Continuous';

  @override
  String get comfortAssessment => 'Comfort Assessment';

  @override
  String get readings => 'Readings';

  @override
  String get average => 'Average';

  @override
  String get realTimeHumidityLevels => 'Real-time Humidity Levels';

  @override
  String get humidityLevelGuide => 'Humidity Level Guide';

  @override
  String get veryDry => 'Very Dry';

  @override
  String get dry => 'Dry';

  @override
  String get comfortable => 'Comfortable';

  @override
  String get humid => 'Humid';

  @override
  String get veryHumid => 'Very Humid';

  @override
  String get proximitySensor => 'Proximity Sensor';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get sensorNotAvailable => 'Sensor Not Available';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get permissionGranted => 'Permission Granted';

  @override
  String get microphonePermissionDenied => 'Microphone permission denied';

  @override
  String get microphonePermissionPermanentlyDenied => 'Microphone permission was permanently denied. Please enable it in your device settings to use the noise meter.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get microphoneAccessNeeded => 'Microphone Access Needed';

  @override
  String get microphoneAccessDescription => 'To measure and analyze sound levels accurately, we need access to your device\'s microphone. Your audio is never recorded or stored.';

  @override
  String get measureNoiseLevels => 'Measure noise levels in real-time';

  @override
  String get analyzeAcoustics => 'Analyze acoustic environment';

  @override
  String get generateReports => 'Generate detailed reports';

  @override
  String get allowMicrophoneAccess => 'Allow Microphone Access';

  @override
  String get audioNotRecorded => 'Audio is never recorded or stored';

  @override
  String get inactive => 'Inactive';

  @override
  String get monitor => 'Monitor';

  @override
  String get totalReadings => 'Total Readings';

  @override
  String get near => 'Near';

  @override
  String get far => 'Far';

  @override
  String get proximityActivityTimeline => 'Proximity Activity Timeline';

  @override
  String get howProximitySensorWorks => 'How Proximity Sensor Works';

  @override
  String get scanBarcode => 'Scan Barcode';

  @override
  String get positionBarcodeInFrame => 'Position the barcode within the frame';

  @override
  String get scanningForBarcodes => 'Scanning for UPC, EAN, Code 128, Code 39, and other linear barcodes';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get positionQrCodeInFrame => 'Position the QR code within the frame';

  @override
  String get scanningForQrCodes => 'Scanning for QR codes, Data Matrix, PDF417, and Aztec codes';

  @override
  String scannedOn(String timestamp) {
    return 'Scanned $timestamp';
  }

  @override
  String get content => 'Content';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get technicalDetails => 'Technical Details';

  @override
  String get format => 'Format';

  @override
  String get description => 'Description';

  @override
  String get dataLength => 'Data Length';

  @override
  String get scanType => 'Scan Type';

  @override
  String get contentType => 'Content Type';

  @override
  String get copyAll => 'Copy All';

  @override
  String get share => 'Share';

  @override
  String get scanAnother => 'Scan Another';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get contentCopied => 'Content copied to clipboard for sharing';

  @override
  String get cannotOpenUrl => 'Cannot open URL';

  @override
  String get chooseScannerType => 'Choose Scanner Type';

  @override
  String get selectScannerDescription => 'Select the type of code you want to scan';

  @override
  String get commonUses => 'Common uses:';

  @override
  String get scanningTips => 'Scanning Tips';

  @override
  String get scanningTipsDescription => 'Hold your device steady and ensure the code is well-lit and clearly visible within the scanner frame.';

  @override
  String get minStat => 'Min';

  @override
  String get maxStat => 'Max';

  @override
  String get gender => 'Gender';

  @override
  String get selectActivity => 'Select Activity';

  @override
  String get walking => 'Walking';

  @override
  String get running => 'Running';

  @override
  String get cycling => 'Cycling';

  @override
  String get sitting => 'Sitting';

  @override
  String get standing => 'Standing';

  @override
  String get stairs => 'Stairs';

  @override
  String get workout => 'Workout';

  @override
  String get environment => 'Environment';

  @override
  String get navigation => 'Navigation';

  @override
  String get motion => 'Motion';

  @override
  String get magnetic => 'Magnetic';

  @override
  String get device => 'Device';

  @override
  String get utility => 'Utility';

  @override
  String get menu => 'Menu';

  @override
  String get kmh => 'km/h';

  @override
  String get moving => 'MOVING';

  @override
  String get stationary => 'STATIONARY';

  @override
  String get feet => 'Feet';

  @override
  String get inches => 'Inches';

  @override
  String get productBarcodes => 'Product barcodes';

  @override
  String get isbnNumbers => 'ISBN numbers';

  @override
  String get upcCodes => 'UPC codes';

  @override
  String get eanCodes => 'EAN codes';

  @override
  String get code128_39 => 'Code 128/39';

  @override
  String get websiteUrls => 'Website URLs';

  @override
  String get wifiPasswords => 'WiFi passwords';

  @override
  String get contactInformation => 'Contact information';

  @override
  String get locationCoordinates => 'Location coordinates';

  @override
  String get calendarEvents => 'Calendar events';

  @override
  String get nearDetection => 'Near Detection';

  @override
  String get objectDetectedClose => 'Object detected close to sensor';

  @override
  String get usuallyWithin5cm => 'Usually when something is within 5cm of the sensor';

  @override
  String get farDetection => 'Far Detection';

  @override
  String get noObjectDetected => 'No object detected nearby';

  @override
  String get clearAreaAroundSensor => 'Clear area around the proximity sensor';

  @override
  String get tooDryIrritation => 'Too dry - may cause skin and respiratory irritation';

  @override
  String get somewhatDryHumidifier => 'Somewhat dry - consider using a humidifier';

  @override
  String get idealHumidityLevel => 'Ideal humidity level for comfort and health';

  @override
  String get somewhatHumidSticky => 'Somewhat humid - may feel sticky';

  @override
  String get tooHumidMold => 'Too humid - may promote mold growth';

  @override
  String get flashlightOn => 'Flashlight ON';

  @override
  String get flashlightOff => 'Flashlight OFF';

  @override
  String get meters => 'meters';

  @override
  String get realTimeLightLevels => 'Real-time Light Levels';

  @override
  String get lightLevelGuide => 'Light Level Guide';

  @override
  String get darkLevel => 'Dark';

  @override
  String get dimLevel => 'Dim';

  @override
  String get indoorLevel => 'Indoor';

  @override
  String get officeLevel => 'Office';

  @override
  String get brightLevel => 'Bright';

  @override
  String get daylightLevel => 'Daylight';

  @override
  String get darkRange => '0-10 lux';

  @override
  String get dimRange => '10-200 lux';

  @override
  String get indoorRange => '200-500 lux';

  @override
  String get officeRange => '500-1000 lux';

  @override
  String get brightRange => '1000-10000 lux';

  @override
  String get daylightRange => '10000+ lux';

  @override
  String get darkExample => 'Night, no moonlight';

  @override
  String get dimExample => 'Moonlight, candle';

  @override
  String get indoorExample => 'Living room lighting';

  @override
  String get officeExample => 'Office workspace';

  @override
  String get brightExample => 'Bright room, cloudy day';

  @override
  String get daylightExample => 'Direct sunlight';

  @override
  String get grantSensorPermission => 'Grant sensor permission to access proximity sensor';

  @override
  String get deviceNoProximitySensor => 'Device does not have a proximity sensor';

  @override
  String get proximitySensorLocation => 'The proximity sensor is typically located near the earpiece and is used to turn off the screen during phone calls.';

  @override
  String get pausedCameraInUse => 'Paused - Camera in use by another feature';

  @override
  String generalError(String error) {
    return 'Error: $error';
  }

  @override
  String currentMode(String mode) {
    return 'Current mode: $mode';
  }

  @override
  String get noiseLevelGuide => 'Noise Level Guide';

  @override
  String get quiet => 'Quiet';

  @override
  String get moderate => 'Moderate';

  @override
  String get loud => 'Loud';

  @override
  String get veryLoud => 'Very Loud';

  @override
  String get dangerous => 'Dangerous';

  @override
  String get whisperLibrary => 'Whisper, library';

  @override
  String get normalConversation => 'Normal conversation';

  @override
  String get trafficOffice => 'Traffic, office';

  @override
  String get motorcycleShouting => 'Motorcycle, shouting';

  @override
  String get rockConcertChainsaw => 'Rock concert, chainsaw';

  @override
  String get qrBarcodeScanner => 'QR/Barcode Scanner';

  @override
  String get scannedData => 'Scanned Data';

  @override
  String get copy => 'Copy';

  @override
  String get clear => 'Clear';

  @override
  String get pageNotFound => 'Page Not Found';

  @override
  String get goHome => 'Go Home';

  @override
  String pageNotFoundMessage(String uri) {
    return 'Page not found: $uri';
  }

  @override
  String get more => 'More';

  @override
  String get theme => 'Theme';

  @override
  String get about => 'About';

  @override
  String get allSettings => 'All Settings';

  @override
  String get getNotifiedAboutSensorReadings => 'Get notified about sensor readings';

  @override
  String get themeChangeRequiresRestart => 'Theme switching requires app restart';

  @override
  String get quickSettings => 'Quick Settings';

  @override
  String get darkModeActive => 'Dark mode active';

  @override
  String get lightModeActive => 'Light mode active';

  @override
  String get sensorData => 'SENSOR DATA';

  @override
  String get stepsLabel => 'Steps';

  @override
  String get accelX => 'Accel X';

  @override
  String get accelY => 'Accel Y';

  @override
  String get accelZ => 'Accel Z';

  @override
  String get gyroX => 'Gyro X';

  @override
  String get gyroY => 'Gyro Y';

  @override
  String get gyroZ => 'Gyro Z';

  @override
  String get qrScannerSubtitle => 'Scan QR codes, Data Matrix, PDF417, and Aztec codes';

  @override
  String get barcodeScannerSubtitle => 'Scan product barcodes like UPC, EAN, Code 128, and more';

  @override
  String get activity => 'Activity';

  @override
  String get startTracking => 'START TRACKING';

  @override
  String get stopTracking => 'STOP TRACKING';

  @override
  String get trackingActive => 'Tracking Active';

  @override
  String get sessionPaused => 'Session Paused';

  @override
  String get updateYourPersonalInformation => 'Update your personal information';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get physicalMeasurements => 'Physical Measurements';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get pleaseEnterYourName => 'Please enter your name';

  @override
  String get enterYourAge => 'Enter your age';

  @override
  String get pleaseEnterYourAge => 'Please enter your age';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get selectYourGender => 'Select your gender';

  @override
  String get enterYourWeightInKg => 'Enter your weight in kg';

  @override
  String get pleaseEnterYourWeight => 'Please enter your weight';

  @override
  String get enterYourHeightInCm => 'Enter your height in cm';

  @override
  String get pleaseEnterYourHeight => 'Please enter your height';

  @override
  String get pedometer => 'Pedometer';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get stepsToGo => 'to go';

  @override
  String get goalReached => 'Goal Reached!';

  @override
  String get calories => 'Calories';

  @override
  String get pace => 'Pace';

  @override
  String get cadence => 'Cadence';

  @override
  String get setDailyGoal => 'Set Daily Goal';

  @override
  String get resetSessionConfirmation => 'Are you sure you want to reset your current session? All progress will be lost.';

  @override
  String get barometer => 'Barometer';

  @override
  String get waitingForSensor => 'Waiting for sensor...';

  @override
  String get clearWeather => 'Clear Weather';

  @override
  String get cloudyWeather => 'Cloudy Weather';

  @override
  String get stableWeather => 'Stable Weather';

  @override
  String get pressureRising => 'Rising';

  @override
  String get pressureFalling => 'Falling';

  @override
  String get pressureSteady => 'Steady';

  @override
  String get maximum => 'Maximum';

  @override
  String get minimum => 'Minimum';

  @override
  String get altitude => 'Altitude';

  @override
  String get altimeter => 'Altimeter';

  @override
  String get altimeterWaiting => 'Waiting for GPS and barometer data...';

  @override
  String get aboveSeaLevel => 'Above Sea Level';

  @override
  String get climbing => 'Climbing';

  @override
  String get descending => 'Descending';

  @override
  String get stable => 'Stable';

  @override
  String get usingGpsOnly => 'Using GPS data only';

  @override
  String get usingBarometerOnly => 'Using barometer data only';

  @override
  String get usingFusedData => 'Combining GPS and barometer for accuracy';

  @override
  String get dataSource => 'Data Source';

  @override
  String get sensorReadings => 'Sensor Readings';

  @override
  String get gpsAltitude => 'GPS Altitude';

  @override
  String get baroAltitude => 'Baro Altitude';

  @override
  String get pressure => 'Pressure';

  @override
  String get statistics => 'Statistics';

  @override
  String get gain => 'Gain';

  @override
  String get loss => 'Loss';

  @override
  String get calibrateAltimeter => 'Calibrate Altimeter';

  @override
  String get calibrateDescription => 'Enter your current known altitude in meters to calibrate the barometric sensor for better accuracy.';

  @override
  String get knownAltitude => 'Known Altitude';

  @override
  String get calibrationComplete => 'Calibration complete!';

  @override
  String get statsReset => 'Statistics reset!';

  @override
  String get vibrationMeter => 'Vibration Meter';

  @override
  String get vibrationWaiting => 'Waiting for accelerometer data...';

  @override
  String get vibrationMagnitude => 'Vibration Magnitude';

  @override
  String get vibrationLevel => 'Vibration Level';

  @override
  String get realtimeWaveform => 'Real-time Waveform';

  @override
  String get pattern => 'Pattern';

  @override
  String get frequency => 'Frequency';

  @override
  String get axisBreakdown => 'Axis Breakdown';

  @override
  String get advancedMetrics => 'Advanced Metrics';

  @override
  String get rms => 'RMS';

  @override
  String get peakToPeak => 'Peak-to-Peak';

  @override
  String get crestFactor => 'Crest Factor';

  @override
  String get acousticAnalyzer => 'Acoustic Analyzer';

  @override
  String get acousticAnalyzerTitle => 'Acoustic Environment Analyzer';

  @override
  String get acousticEnvironment => 'Acoustic Environment';

  @override
  String get noiseLevel => 'Noise Level';

  @override
  String get decibelUnit => 'dB';

  @override
  String get presetSelectTitle => 'Choose Recording Preset';

  @override
  String get presetSelectSubtitle => 'Select a preset to analyze your acoustic environment over time';

  @override
  String get presetSleep => 'Sleep';

  @override
  String get presetSleepTitle => 'Analyze Sleep Environment';

  @override
  String get presetSleepDuration => '8 hours';

  @override
  String get presetSleepDescription => 'Monitor bedroom noise throughout the night to improve sleep quality';

  @override
  String get presetWork => 'Work';

  @override
  String get presetWorkTitle => 'Monitor Office Environment';

  @override
  String get presetWorkDuration => '1 hour';

  @override
  String get presetWorkDescription => 'Track workplace noise levels and identify distractions';

  @override
  String get presetFocus => 'Focus';

  @override
  String get presetFocusTitle => 'Focus Session Analysis';

  @override
  String get presetFocusDuration => '30 minutes';

  @override
  String get presetFocusDescription => 'Analyze your study or focus session environment';

  @override
  String get presetCustom => 'Custom';

  @override
  String get presetSleepAnalysis => 'Sleep Analysis (8h)';

  @override
  String get presetWorkEnvironment => 'Work Environment (1h)';

  @override
  String get presetFocusSession => 'Focus Session (30m)';

  @override
  String get presetCustomRecording => 'Custom Recording';

  @override
  String get monitoringTitle => 'Monitoring';

  @override
  String get monitoringActive => 'Recording Active';

  @override
  String get monitoringStopped => 'Recording Stopped';

  @override
  String get monitoringProgress => 'Progress';

  @override
  String get monitoringCurrentLevel => 'Current Level';

  @override
  String get monitoringLiveChart => 'Live Monitoring';

  @override
  String get monitoringEnvironment => 'Monitoring acoustic environment...';

  @override
  String get recordingStart => 'Start Recording';

  @override
  String get recordingStop => 'Stop Recording';

  @override
  String get recordingCompleted => 'Recording completed';

  @override
  String get reportGeneratedSuccess => 'Report generated successfully!';

  @override
  String get stopRecordingTooltip => 'Stop Recording';

  @override
  String get stopRecordingConfirmTitle => 'Stop Recording?';

  @override
  String get stopRecordingConfirmMessage => 'Are you sure you want to stop the recording? The report will be generated with the current data.';

  @override
  String get continueRecording => 'Continue';

  @override
  String get reportsTitle => 'Acoustic Reports';

  @override
  String get reportsEmpty => 'No Reports Yet';

  @override
  String get reportsEmptyDescription => 'Start an acoustic analysis session to generate your first report';

  @override
  String reportsSelectedCount(int count) {
    return '$count Selected';
  }

  @override
  String get reportExportCSV => 'Export as CSV';

  @override
  String get reportExportAll => 'Export All';

  @override
  String get reportDelete => 'Delete';

  @override
  String get reportDeleteSelected => 'Delete Selected';

  @override
  String get reportDeleteConfirmTitle => 'Delete Reports?';

  @override
  String reportDeleteConfirmMessage(int count) {
    return 'Are you sure you want to delete $count report(s)? This action cannot be undone.';
  }

  @override
  String get reportDeleteSuccess => 'Reports deleted';

  @override
  String get reportFilterByPreset => 'Filter by Preset';

  @override
  String get reportFilterAll => 'All Presets';

  @override
  String get reportStartAnalysis => 'Start Analysis';

  @override
  String get csvCopiedToClipboard => 'CSV data copied to clipboard!';

  @override
  String get reportDetailTitle => 'Acoustic Report';

  @override
  String get reportQualityTitle => 'Environment Quality';

  @override
  String get reportQualityScore => 'Quality Score';

  @override
  String get reportAverage => 'Average';

  @override
  String get reportPeak => 'Peak';

  @override
  String get reportHourlyBreakdown => 'Hourly Breakdown';

  @override
  String get reportNoiseEvents => 'Noise Events';

  @override
  String get reportNoEventsTitle => 'No Interruptions Detected';

  @override
  String get reportNoEventsMessage => 'Your environment was consistently quiet';

  @override
  String get reportShare => 'Share Report';

  @override
  String get reportRecommendations => 'Recommendations';

  @override
  String get reportDuration => 'Duration';

  @override
  String get reportEvents => 'events';

  @override
  String durationHours(int hours) {
    return '${hours}h';
  }

  @override
  String durationMinutes(int minutes) {
    return '${minutes}m';
  }

  @override
  String durationSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get qualityExcellent => 'Excellent';

  @override
  String get qualityGood => 'Good';

  @override
  String get qualityFair => 'Fair';

  @override
  String get qualityPoor => 'Poor';

  @override
  String get unitDecibels => 'dB';

  @override
  String get unitHours => 'hours';

  @override
  String get unitMinutes => 'minutes';

  @override
  String get unitSeconds => 'seconds';

  @override
  String get actionOk => 'OK';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionStop => 'Stop';

  @override
  String get actionStart => 'Start';

  @override
  String get actionView => 'View';

  @override
  String get actionExport => 'Export';

  @override
  String get actionShare => 'Share';

  @override
  String get viewHistoricalReports => 'View Historical Reports';

  @override
  String get csvHeaderID => 'ID';

  @override
  String get csvHeaderStartTime => 'Start Time';

  @override
  String get csvHeaderEndTime => 'End Time';

  @override
  String get csvHeaderDuration => 'Duration (min)';

  @override
  String get csvHeaderPreset => 'Preset';

  @override
  String get csvHeaderAverageDB => 'Average dB';

  @override
  String get csvHeaderMinDB => 'Min dB';

  @override
  String get csvHeaderMaxDB => 'Max dB';

  @override
  String get csvHeaderEvents => 'Events';

  @override
  String get csvHeaderQualityScore => 'Quality Score';

  @override
  String get csvHeaderQuality => 'Quality';

  @override
  String get csvHeaderRecommendation => 'Recommendation';

  @override
  String get sleepAnalysis => 'Sleep Analysis';

  @override
  String get workEnvironment => 'Work Environment';

  @override
  String get focusSession => 'Focus Session';

  @override
  String get recordingComplete => 'Recording Complete';

  @override
  String get presetName => 'Preset Name';

  @override
  String get averageDecibels => 'Average Decibels';

  @override
  String get peakDecibels => 'Peak Decibels';

  @override
  String get environmentQuality => 'Environment Quality';

  @override
  String get viewReport => 'View Report';

  @override
  String get noiseMeterGuide => 'Noise Meter Guide';

  @override
  String get environmentAnalyzer => 'Environment Analyzer';

  @override
  String get environmentAnalyzerSubtitle => 'Preset-based acoustic analysis';

  @override
  String get acousticReportsSubtitle => 'View saved analyses and history';

  @override
  String get exportReports => 'Export Reports';

  @override
  String get exportChooseMethod => 'Choose how you want to export the reports:';

  @override
  String get exportCopyToClipboard => 'Copy to Clipboard';

  @override
  String get exportSaveAsFile => 'Save as File';

  @override
  String get exportSuccess => 'Export Successful';

  @override
  String exportSuccessMessage(int count) {
    return '$count report(s) exported successfully!';
  }

  @override
  String get savedTo => 'Saved to:';

  @override
  String get deletePreset => 'Delete Preset?';

  @override
  String deletePresetMessage(String title) {
    return 'Delete \"$title\"? This cannot be undone.';
  }

  @override
  String get acousticReport => 'Acoustic Report';

  @override
  String get createCustomPreset => 'Create Custom Preset';

  @override
  String get durationMustBeGreaterThanZero => 'Duration must be greater than 0';

  @override
  String get allPresets => 'All Presets';

  @override
  String get consistency => 'Consistency';

  @override
  String get peakManagement => 'Peak Mgmt';

  @override
  String get level => 'Level';

  @override
  String get avg => 'Avg';

  @override
  String get realtimeNoiseLevels => 'Real-time Noise Levels';

  @override
  String get decibelStatistics => 'Decibel Statistics';

  @override
  String get quietEnvironment => 'Quiet Environment';

  @override
  String get moderateNoise => 'Moderate Noise';

  @override
  String get loudEnvironment => 'Loud Environment';

  @override
  String get veryLoudCaution => 'Very Loud - Caution';

  @override
  String get dangerousLevels => 'Dangerous Levels';

  @override
  String get keyStatistics => 'Key Statistics';

  @override
  String get noiseEvents => 'Noise Events';

  @override
  String get noInterruptionsDetected => 'No Interruptions Detected';

  @override
  String get environmentConsistentlyQuiet => 'Your environment was consistently quiet';

  @override
  String get expertAdvice => 'Expert Advice';

  @override
  String get quickTips => 'Quick Tips';

  @override
  String get dataPoints => 'Data Points';

  @override
  String get grantMicrophonePermission => 'Grant microphone permission to measure noise levels';

  @override
  String get hourlyBreakdown => 'Hourly Breakdown';

  @override
  String get eventTimeline => 'Event Timeline';

  @override
  String get noEventsRecorded => 'No events recorded';

  @override
  String get sessionDetails => 'Session Details';

  @override
  String get date => 'Date';

  @override
  String get preset => 'Preset';

  @override
  String get recommendation => 'Recommendation';

  @override
  String get noInterruptions => 'No Interruptions';

  @override
  String get quietQuiet => 'Quiet (0-30 dB)';

  @override
  String get quietModerate => 'Moderate (30-60 dB)';

  @override
  String get quietLoud => 'Loud (60-85 dB)';

  @override
  String get quietVeryLoud => 'Very Loud (85-100 dB)';

  @override
  String get quietDangerous => 'Dangerous (100+ dB)';

  @override
  String get anErrorOccurred => 'An error occurred.';

  @override
  String failedToLoadPresets(String error) {
    return 'Failed to load presets: $error';
  }

  @override
  String createdPreset(String title) {
    return 'Created \"$title\"!';
  }

  @override
  String failedToSavePreset(String error) {
    return 'Failed to save preset: $error';
  }

  @override
  String get deleteReportsQuestion => 'Delete Reports?';

  @override
  String get deleteReportsConfirmMessage => 'Are you sure you want to delete the selected report(s)? This action cannot be undone.';

  @override
  String get reportsDeleted => 'Reports deleted';

  @override
  String get presetDetails => 'Preset Details';

  @override
  String get mustBeAtLeast3Chars => 'Must be at least 3 characters';

  @override
  String get mustBeAtLeast10Chars => 'Must be at least 10 characters';

  @override
  String get chooseIcon => 'Choose Icon';

  @override
  String get chooseColor => 'Choose Color';

  @override
  String get customLabs => 'Custom Labs';

  @override
  String get allLabs => 'All Labs';

  @override
  String get myLabs => 'My Labs';

  @override
  String get noLabsYet => 'No labs yet';

  @override
  String get createFirstLabMessage => 'Create your first custom lab to get started';

  @override
  String get noCustomLabsYet => 'No custom labs yet';

  @override
  String get tapPlusToCreateLab => 'Tap the + button to create your first custom lab';

  @override
  String get newLab => 'New Lab';

  @override
  String get presetLabs => 'Preset Labs';

  @override
  String get myCustomLabs => 'My Custom Labs';

  @override
  String get errorLoadingLabs => 'Error loading labs';

  @override
  String get createLab => 'Create Lab';

  @override
  String get editLab => 'Edit Lab';

  @override
  String get deleteLab => 'Delete Lab';

  @override
  String get labName => 'Lab Name';

  @override
  String get labNameHint => 'e.g., Motion Analysis';

  @override
  String get descriptionHint => 'Describe what this lab measures';

  @override
  String get recordingIntervalMs => 'Recording Interval (ms)';

  @override
  String get recordingIntervalHint => '1000';

  @override
  String get intervalMustBeBetween => 'Interval must be between 100-10000 ms';

  @override
  String get pleaseEnterInterval => 'Please enter an interval';

  @override
  String get pleaseEnterLabName => 'Please enter a lab name';

  @override
  String get labColor => 'Lab Color';

  @override
  String get selectSensors => 'Select Sensors';

  @override
  String get sensors => 'Sensors';

  @override
  String get interval => 'Interval';

  @override
  String get created => 'Created';

  @override
  String get sessions => 'Sessions';

  @override
  String get notes => 'Notes';

  @override
  String get export => 'Export';

  @override
  String get chooseAtLeastOneSensor => 'Choose at least one sensor to record';

  @override
  String get labCreatedSuccessfully => 'Lab created successfully';

  @override
  String get labUpdatedSuccessfully => 'Lab updated successfully';

  @override
  String get labDeletedSuccessfully => 'Lab deleted successfully';

  @override
  String deleteLabConfirm(String labName) {
    return 'Are you sure you want to delete \"$labName\"?';
  }

  @override
  String get cannotModifyPresetLabs => 'Cannot modify preset labs';

  @override
  String get cannotDeletePresetLabs => 'Cannot delete preset labs';

  @override
  String get pleaseSelectAtLeastOneSensor => 'Please select at least one sensor';

  @override
  String sensorsCount(int count) {
    return '$count sensors';
  }

  @override
  String intervalMs(int interval) {
    return '${interval}ms interval';
  }

  @override
  String get presetBadge => 'PRESET';

  @override
  String get labDetails => 'Lab Details';

  @override
  String get sessionHistory => 'Session History';

  @override
  String get startRecording => 'Start Recording';

  @override
  String get stopRecording => 'Stop Recording';

  @override
  String get pauseRecording => 'Pause Recording';

  @override
  String get recordingStatus => 'RECORDING';

  @override
  String get pausedStatus => 'PAUSED';

  @override
  String get completedStatus => 'COMPLETED';

  @override
  String get failedStatus => 'FAILED';

  @override
  String get idleStatus => 'IDLE';

  @override
  String get elapsedTime => 'Elapsed Time';

  @override
  String get collectingSensorData => 'Collecting sensor data...';

  @override
  String get stopRecordingQuestion => 'Stop Recording?';

  @override
  String get stopRecordingConfirm => 'Do you want to stop and save this recording session?';

  @override
  String get continueRecordingAction => 'Continue Recording';

  @override
  String get stopAndSave => 'Stop & Save';

  @override
  String get recordingSavedSuccessfully => 'Recording saved successfully';

  @override
  String get failedToStartRecording => 'Failed to start recording session';

  @override
  String dataPoints(int count) {
    return '$count points';
  }

  @override
  String get noRecordingSessionsYet => 'No recording sessions yet';

  @override
  String get startRecordingToCreateSession => 'Start recording to create your first session';

  @override
  String get errorLoadingSessions => 'Error loading sessions';

  @override
  String get sessionDetailsTitle => 'Session Details';

  @override
  String get exportAndShare => 'Export & Share';

  @override
  String get deleteSession => 'Delete Session';

  @override
  String get deleteSessionConfirm => 'Are you sure you want to delete this recording session? This action cannot be undone.';

  @override
  String get sessionDeletedSuccessfully => 'Session deleted successfully';

  @override
  String get recordingTime => 'Recording Time';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get recordingData => 'Recording Data';

  @override
  String get dataPointsCount => 'Data Points';

  @override
  String get sensorsUsed => 'Sensors Used';

  @override
  String get sessionExportedToCSV => 'Session has been exported to CSV';

  @override
  String get sessionNotYetExported => 'Session not yet exported';

  @override
  String get errorCheckingExportStatus => 'Error checking export status';

  @override
  String get dataPreview => 'Data Preview';

  @override
  String get noDataPointsRecorded => 'No data points recorded';

  @override
  String showingDataPoints(int showing, int total) {
    return 'Showing $showing of $total data points';
  }

  @override
  String get pointNumber => 'Point';

  @override
  String errorLoadingDataPoints(String error) {
    return 'Error loading data points: $error';
  }

  @override
  String get exportToCSV => 'Export to CSV';

  @override
  String get exportingStatus => 'Exporting...';

  @override
  String exportedTo(String path) {
    return 'Exported to: $path';
  }

  @override
  String get sharingNotYetImplemented => '(Sharing not yet implemented)';

  @override
  String get failedToExportSession => 'Failed to export session';

  @override
  String get exportedLabel => 'Exported';

  @override
  String get sensorAccelerometer => 'Accelerometer';

  @override
  String get sensorGyroscope => 'Gyroscope';

  @override
  String get sensorMagnetometer => 'Magnetometer';

  @override
  String get sensorBarometer => 'Barometer';

  @override
  String get sensorLightMeter => 'Light';

  @override
  String get sensorNoiseMeter => 'Noise';

  @override
  String get sensorGPS => 'GPS';

  @override
  String get sensorProximity => 'Proximity';

  @override
  String get sensorTemperature => 'Temp';

  @override
  String get sensorHumidity => 'Humidity';

  @override
  String get sensorPedometer => 'Pedometer';

  @override
  String get sensorCompass => 'Compass';

  @override
  String get sensorAltimeter => 'Altimeter';

  @override
  String get sensorSpeedMeter => 'Speed';

  @override
  String get sensorHeartBeat => 'Heart Rate';

  @override
  String get environmentMonitor => 'Environment Monitor';

  @override
  String get motionAnalysis => 'Motion Analysis';

  @override
  String get indoorQuality => 'Indoor Quality';

  @override
  String get outdoorExplorer => 'Outdoor Explorer';

  @override
  String get vehicleDynamics => 'Vehicle Dynamics';

  @override
  String get healthTrackerLab => 'Health Tracker';
}
