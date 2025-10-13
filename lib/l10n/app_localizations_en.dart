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
}
