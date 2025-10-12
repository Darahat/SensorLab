import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_km.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('km')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SensorLab'**
  String get appName;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @failedToLoadSettings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load settings'**
  String get failedToLoadSettings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @switchBetweenLightAndDarkThemes.
  ///
  /// In en, this message translates to:
  /// **'Switch between light and dark themes'**
  String get switchBetweenLightAndDarkThemes;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get languageSubtitle;

  /// No description provided for @notificationsAndFeedback.
  ///
  /// In en, this message translates to:
  /// **'Notifications & Feedback'**
  String get notificationsAndFeedback;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @receiveAppNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive app notifications'**
  String get receiveAppNotifications;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @hapticFeedbackForInteractions.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback for interactions'**
  String get hapticFeedbackForInteractions;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get soundEffects;

  /// No description provided for @audioFeedbackForAppActions.
  ///
  /// In en, this message translates to:
  /// **'Audio feedback for app actions'**
  String get audioFeedbackForAppActions;

  /// No description provided for @sensorSettings.
  ///
  /// In en, this message translates to:
  /// **'Sensor Settings'**
  String get sensorSettings;

  /// No description provided for @autoScan.
  ///
  /// In en, this message translates to:
  /// **'Auto Scan'**
  String get autoScan;

  /// No description provided for @automaticallyScanWhenOpeningScanner.
  ///
  /// In en, this message translates to:
  /// **'Automatically scan when opening scanner'**
  String get automaticallyScanWhenOpeningScanner;

  /// No description provided for @sensorUpdateFrequency.
  ///
  /// In en, this message translates to:
  /// **'Sensor Update Frequency'**
  String get sensorUpdateFrequency;

  /// No description provided for @sensorUpdateFrequencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'{frequency}ms intervals'**
  String sensorUpdateFrequencySubtitle(int frequency);

  /// No description provided for @privacyAndData.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Data'**
  String get privacyAndData;

  /// No description provided for @dataCollection.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get dataCollection;

  /// No description provided for @allowAnonymousUsageAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Allow anonymous usage analytics'**
  String get allowAnonymousUsageAnalytics;

  /// No description provided for @privacyMode.
  ///
  /// In en, this message translates to:
  /// **'Privacy Mode'**
  String get privacyMode;

  /// No description provided for @enhancedPrivacyProtection.
  ///
  /// In en, this message translates to:
  /// **'Enhanced privacy protection'**
  String get enhancedPrivacyProtection;

  /// No description provided for @appSupport.
  ///
  /// In en, this message translates to:
  /// **'App Support'**
  String get appSupport;

  /// No description provided for @showAds.
  ///
  /// In en, this message translates to:
  /// **'Show Ads'**
  String get showAds;

  /// No description provided for @supportAppDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Support app development'**
  String get supportAppDevelopment;

  /// No description provided for @resetSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get resetSettings;

  /// No description provided for @resetAllSettingsToDefaultValues.
  ///
  /// In en, this message translates to:
  /// **'Reset all settings to their default values. This action cannot be undone.'**
  String get resetAllSettingsToDefaultValues;

  /// No description provided for @resetToDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to Defaults'**
  String get resetToDefaults;

  /// No description provided for @chooseSensorUpdateFrequency.
  ///
  /// In en, this message translates to:
  /// **'Choose how often sensors should update:'**
  String get chooseSensorUpdateFrequency;

  /// No description provided for @fastUpdate.
  ///
  /// In en, this message translates to:
  /// **'50ms (Fast)'**
  String get fastUpdate;

  /// No description provided for @normalUpdate.
  ///
  /// In en, this message translates to:
  /// **'100ms (Normal)'**
  String get normalUpdate;

  /// No description provided for @slowUpdate.
  ///
  /// In en, this message translates to:
  /// **'200ms (Slow)'**
  String get slowUpdate;

  /// No description provided for @verySlowUpdate.
  ///
  /// In en, this message translates to:
  /// **'500ms (Very Slow)'**
  String get verySlowUpdate;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @confirmReset.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reset'**
  String get confirmReset;

  /// No description provided for @areYouSureResetSettings.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all settings to their default values?'**
  String get areYouSureResetSettings;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisActionCannotBeUndone;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @accelerometer.
  ///
  /// In en, this message translates to:
  /// **'Accelerometer'**
  String get accelerometer;

  /// No description provided for @compass.
  ///
  /// In en, this message translates to:
  /// **'Compass'**
  String get compass;

  /// No description provided for @flashlight.
  ///
  /// In en, this message translates to:
  /// **'Flashlight'**
  String get flashlight;

  /// No description provided for @gyroscope.
  ///
  /// In en, this message translates to:
  /// **'Gyroscope'**
  String get gyroscope;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @lightMeter.
  ///
  /// In en, this message translates to:
  /// **'Light Meter'**
  String get lightMeter;

  /// No description provided for @magnetometer.
  ///
  /// In en, this message translates to:
  /// **'Magnetometer'**
  String get magnetometer;

  /// No description provided for @noiseMeter.
  ///
  /// In en, this message translates to:
  /// **'Noise Meter'**
  String get noiseMeter;

  /// No description provided for @proximity.
  ///
  /// In en, this message translates to:
  /// **'Proximity'**
  String get proximity;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// No description provided for @calorieBurn.
  ///
  /// In en, this message translates to:
  /// **'Calorie Burn'**
  String get calorieBurn;

  /// No description provided for @scanner.
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get scanner;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @qrCodeScanner.
  ///
  /// In en, this message translates to:
  /// **'QR Code Scanner'**
  String get qrCodeScanner;

  /// No description provided for @barcodeScanner.
  ///
  /// In en, this message translates to:
  /// **'Barcode Scanner'**
  String get barcodeScanner;

  /// No description provided for @scanResult.
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get scanResult;

  /// No description provided for @plainText.
  ///
  /// In en, this message translates to:
  /// **'Plain Text'**
  String get plainText;

  /// No description provided for @websiteUrl.
  ///
  /// In en, this message translates to:
  /// **'Website URL'**
  String get websiteUrl;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @smsMessage.
  ///
  /// In en, this message translates to:
  /// **'SMS Message'**
  String get smsMessage;

  /// No description provided for @wifiNetwork.
  ///
  /// In en, this message translates to:
  /// **'WiFi Network'**
  String get wifiNetwork;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contactInfo;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @calendarEvent.
  ///
  /// In en, this message translates to:
  /// **'Calendar Event'**
  String get calendarEvent;

  /// No description provided for @quickResponseCode.
  ///
  /// In en, this message translates to:
  /// **'Quick Response Code'**
  String get quickResponseCode;

  /// No description provided for @europeanArticleNumber13.
  ///
  /// In en, this message translates to:
  /// **'European Article Number (13 digits)'**
  String get europeanArticleNumber13;

  /// No description provided for @europeanArticleNumber8.
  ///
  /// In en, this message translates to:
  /// **'European Article Number (8 digits)'**
  String get europeanArticleNumber8;

  /// No description provided for @universalProductCode12.
  ///
  /// In en, this message translates to:
  /// **'Universal Product Code (12 digits)'**
  String get universalProductCode12;

  /// No description provided for @universalProductCode8.
  ///
  /// In en, this message translates to:
  /// **'Universal Product Code (8 digits)'**
  String get universalProductCode8;

  /// No description provided for @code128.
  ///
  /// In en, this message translates to:
  /// **'Code 128 (Variable length)'**
  String get code128;

  /// No description provided for @code39.
  ///
  /// In en, this message translates to:
  /// **'Code 39 (Alphanumeric)'**
  String get code39;

  /// No description provided for @code93.
  ///
  /// In en, this message translates to:
  /// **'Code 93 (Alphanumeric)'**
  String get code93;

  /// No description provided for @codabar.
  ///
  /// In en, this message translates to:
  /// **'Codabar (Numeric with special chars)'**
  String get codabar;

  /// No description provided for @interleaved2of5.
  ///
  /// In en, this message translates to:
  /// **'Interleaved 2 of 5'**
  String get interleaved2of5;

  /// No description provided for @dataMatrix.
  ///
  /// In en, this message translates to:
  /// **'Data Matrix (2D)'**
  String get dataMatrix;

  /// No description provided for @aztecCode.
  ///
  /// In en, this message translates to:
  /// **'Aztec Code (2D)'**
  String get aztecCode;

  /// No description provided for @torchNotAvailableOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Torch not available on this device'**
  String get torchNotAvailableOnDevice;

  /// No description provided for @failedToInitializeFlashlight.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize flashlight'**
  String get failedToInitializeFlashlight;

  /// No description provided for @failedToToggleFlashlight.
  ///
  /// In en, this message translates to:
  /// **'Failed to toggle flashlight'**
  String get failedToToggleFlashlight;

  /// No description provided for @cameraIsInUse.
  ///
  /// In en, this message translates to:
  /// **'Camera is in use'**
  String get cameraIsInUse;

  /// No description provided for @torchNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Torch not available'**
  String get torchNotAvailable;

  /// No description provided for @failedToEnableTorch.
  ///
  /// In en, this message translates to:
  /// **'Failed to enable torch'**
  String get failedToEnableTorch;

  /// No description provided for @failedToDisableTorch.
  ///
  /// In en, this message translates to:
  /// **'Failed to disable torch'**
  String get failedToDisableTorch;

  /// No description provided for @intensityControlNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Intensity control not supported by torch_light package'**
  String get intensityControlNotSupported;

  /// No description provided for @failedToSetMode.
  ///
  /// In en, this message translates to:
  /// **'Failed to set mode'**
  String get failedToSetMode;

  /// No description provided for @failedToPerformQuickFlash.
  ///
  /// In en, this message translates to:
  /// **'Failed to perform quick flash'**
  String get failedToPerformQuickFlash;

  /// No description provided for @noCamerasFound.
  ///
  /// In en, this message translates to:
  /// **'No cameras found'**
  String get noCamerasFound;

  /// No description provided for @readyCoverCameraWithFinger.
  ///
  /// In en, this message translates to:
  /// **'Ready - Cover camera with finger'**
  String get readyCoverCameraWithFinger;

  /// No description provided for @cameraError.
  ///
  /// In en, this message translates to:
  /// **'Camera error'**
  String get cameraError;

  /// No description provided for @placeFingerFirmlyOnCamera.
  ///
  /// In en, this message translates to:
  /// **'Place finger firmly on camera'**
  String get placeFingerFirmlyOnCamera;

  /// No description provided for @pressFingerFirmlyOnCamera.
  ///
  /// In en, this message translates to:
  /// **'Press finger firmly on camera'**
  String get pressFingerFirmlyOnCamera;

  /// No description provided for @fingerMovedPlaceFirmlyOnCamera.
  ///
  /// In en, this message translates to:
  /// **'Finger moved! Place firmly on camera'**
  String get fingerMovedPlaceFirmlyOnCamera;

  /// No description provided for @heartRateBpm.
  ///
  /// In en, this message translates to:
  /// **'Heart rate: {bpm} BPM'**
  String heartRateBpm(int bpm);

  /// No description provided for @holdStill.
  ///
  /// In en, this message translates to:
  /// **'Hold still...'**
  String get holdStill;

  /// No description provided for @adjustFingerPressure.
  ///
  /// In en, this message translates to:
  /// **'Adjust finger pressure'**
  String get adjustFingerPressure;

  /// No description provided for @flashError.
  ///
  /// In en, this message translates to:
  /// **'Flash error'**
  String get flashError;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @heightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightCm;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;

  /// No description provided for @enterYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Details'**
  String get enterYourDetails;

  /// No description provided for @initializationFailed.
  ///
  /// In en, this message translates to:
  /// **'Initialization failed'**
  String get initializationFailed;

  /// No description provided for @allYourSensorsInOnePlace.
  ///
  /// In en, this message translates to:
  /// **'All your sensors in one place'**
  String get allYourSensorsInOnePlace;

  /// No description provided for @noSensorsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No sensors available'**
  String get noSensorsAvailable;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get active;

  /// No description provided for @moveYourDevice.
  ///
  /// In en, this message translates to:
  /// **'MOVE YOUR DEVICE'**
  String get moveYourDevice;

  /// No description provided for @accelerationUnit.
  ///
  /// In en, this message translates to:
  /// **'Acceleration (m/s²)'**
  String get accelerationUnit;

  /// No description provided for @axis.
  ///
  /// In en, this message translates to:
  /// **'Axis'**
  String get axis;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// No description provided for @xAxis.
  ///
  /// In en, this message translates to:
  /// **'X'**
  String get xAxis;

  /// No description provided for @yAxis.
  ///
  /// In en, this message translates to:
  /// **'Y'**
  String get yAxis;

  /// No description provided for @zAxis.
  ///
  /// In en, this message translates to:
  /// **'Z'**
  String get zAxis;

  /// No description provided for @calibrate.
  ///
  /// In en, this message translates to:
  /// **'Calibrate'**
  String get calibrate;

  /// No description provided for @calibrating.
  ///
  /// In en, this message translates to:
  /// **'Calibrating...'**
  String get calibrating;

  /// No description provided for @magneticHeading.
  ///
  /// In en, this message translates to:
  /// **'Magnetic Heading'**
  String get magneticHeading;

  /// No description provided for @highAccuracy.
  ///
  /// In en, this message translates to:
  /// **'High Accuracy'**
  String get highAccuracy;

  /// No description provided for @compassError.
  ///
  /// In en, this message translates to:
  /// **'Compass Error'**
  String get compassError;

  /// No description provided for @resetSession.
  ///
  /// In en, this message translates to:
  /// **'Reset Session'**
  String get resetSession;

  /// No description provided for @flashlightNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Flashlight Not Available'**
  String get flashlightNotAvailable;

  /// No description provided for @initializingFlashlight.
  ///
  /// In en, this message translates to:
  /// **'Initializing Flashlight...'**
  String get initializingFlashlight;

  /// No description provided for @deviceDoesNotHaveFlashlight.
  ///
  /// In en, this message translates to:
  /// **'Device does not have a flashlight or it\'s not accessible'**
  String get deviceDoesNotHaveFlashlight;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @quickFlash.
  ///
  /// In en, this message translates to:
  /// **'Quick Flash'**
  String get quickFlash;

  /// No description provided for @turnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn Off'**
  String get turnOff;

  /// No description provided for @turnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn On'**
  String get turnOn;

  /// No description provided for @intensityControl.
  ///
  /// In en, this message translates to:
  /// **'Intensity Control'**
  String get intensityControl;

  /// No description provided for @currentIntensity.
  ///
  /// In en, this message translates to:
  /// **'Current: {intensity}'**
  String currentIntensity(String intensity);

  /// No description provided for @flashlightModes.
  ///
  /// In en, this message translates to:
  /// **'Flashlight Modes'**
  String get flashlightModes;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @strobe.
  ///
  /// In en, this message translates to:
  /// **'Strobe'**
  String get strobe;

  /// No description provided for @sos.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sos;

  /// No description provided for @sessionStatistics.
  ///
  /// In en, this message translates to:
  /// **'Session Statistics'**
  String get sessionStatistics;

  /// No description provided for @sessionTime.
  ///
  /// In en, this message translates to:
  /// **'Session Time'**
  String get sessionTime;

  /// No description provided for @toggles.
  ///
  /// In en, this message translates to:
  /// **'Toggles'**
  String get toggles;

  /// No description provided for @onTime.
  ///
  /// In en, this message translates to:
  /// **'On Time'**
  String get onTime;

  /// No description provided for @batteryUsage.
  ///
  /// In en, this message translates to:
  /// **'Battery Usage'**
  String get batteryUsage;

  /// No description provided for @batteryUsageWarning.
  ///
  /// In en, this message translates to:
  /// **'Battery Usage Warning'**
  String get batteryUsageWarning;

  /// No description provided for @flashlightOnFor.
  ///
  /// In en, this message translates to:
  /// **'Flashlight has been on for {time}. Consider turning it off to save battery.'**
  String flashlightOnFor(String time);

  /// No description provided for @usageTips.
  ///
  /// In en, this message translates to:
  /// **'Usage Tips'**
  String get usageTips;

  /// No description provided for @normalMode.
  ///
  /// In en, this message translates to:
  /// **'Normal Mode'**
  String get normalMode;

  /// No description provided for @normalModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Standard flashlight operation'**
  String get normalModeDescription;

  /// No description provided for @strobeMode.
  ///
  /// In en, this message translates to:
  /// **'Strobe Mode'**
  String get strobeMode;

  /// No description provided for @strobeModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Flashing light for attention'**
  String get strobeModeDescription;

  /// No description provided for @sosMode.
  ///
  /// In en, this message translates to:
  /// **'SOS Mode'**
  String get sosMode;

  /// No description provided for @sosModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Emergency signal (... --- ...)'**
  String get sosModeDescription;

  /// No description provided for @battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get battery;

  /// No description provided for @batteryTip.
  ///
  /// In en, this message translates to:
  /// **'Monitor usage to preserve battery life'**
  String get batteryTip;

  /// No description provided for @intensity.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get intensity;

  /// No description provided for @intensityTip.
  ///
  /// In en, this message translates to:
  /// **'Adjust brightness to save power'**
  String get intensityTip;

  /// No description provided for @pressButtonToGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Press the button to get location'**
  String get pressButtonToGetLocation;

  /// No description provided for @addressWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Address will appear here'**
  String get addressWillAppearHere;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionsPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied'**
  String get locationPermissionsPermanentlyDenied;

  /// No description provided for @errorGettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Error getting location: {error}'**
  String errorGettingLocation(String error);

  /// No description provided for @failedToGetAddress.
  ///
  /// In en, this message translates to:
  /// **'Failed to get address: {error}'**
  String failedToGetAddress(String error);

  /// No description provided for @noAppToOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'No app available to open maps'**
  String get noAppToOpenMaps;

  /// No description provided for @geolocator.
  ///
  /// In en, this message translates to:
  /// **'Geolocator'**
  String get geolocator;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy: {accuracy}'**
  String accuracy(String accuracy);

  /// No description provided for @pleaseEnableLocationServices.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services'**
  String get pleaseEnableLocationServices;

  /// No description provided for @pleaseGrantLocationPermissions.
  ///
  /// In en, this message translates to:
  /// **'Please grant location permissions'**
  String get pleaseGrantLocationPermissions;

  /// No description provided for @locating.
  ///
  /// In en, this message translates to:
  /// **'Locating...'**
  String get locating;

  /// No description provided for @getCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Get Current Location'**
  String get getCurrentLocation;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get openInMaps;

  /// No description provided for @aboutGeolocator.
  ///
  /// In en, this message translates to:
  /// **'About Geolocator'**
  String get aboutGeolocator;

  /// No description provided for @geolocatorDescription.
  ///
  /// In en, this message translates to:
  /// **'This tool shows your current location using your device\'s GPS.\n\nFeatures:\n• Precise latitude/longitude coordinates\n• Estimated accuracy measurement\n• Reverse geocoding to get address\n• Open location in maps\n\nFor best results, ensure you have:\n• Location services enabled\n• Clear view of the sky\n• Internet connection for address lookup'**
  String get geolocatorDescription;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @motionIntensity.
  ///
  /// In en, this message translates to:
  /// **'Motion Intensity'**
  String get motionIntensity;

  /// No description provided for @liveSensorGraph.
  ///
  /// In en, this message translates to:
  /// **'Live Sensor Graph (X - Red, Y - Green, Z - Blue)'**
  String get liveSensorGraph;

  /// No description provided for @angularVelocity.
  ///
  /// In en, this message translates to:
  /// **'Angular velocity (rad/s)'**
  String get angularVelocity;

  /// No description provided for @healthTracker.
  ///
  /// In en, this message translates to:
  /// **'Health Tracker'**
  String get healthTracker;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String helloUser(String name);

  /// No description provided for @readyToTrackSession.
  ///
  /// In en, this message translates to:
  /// **'Ready to track your {activity} session?'**
  String readyToTrackSession(String activity);

  /// No description provided for @bmi.
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get bmi;

  /// No description provided for @bmr.
  ///
  /// In en, this message translates to:
  /// **'BMR'**
  String get bmr;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @activityType.
  ///
  /// In en, this message translates to:
  /// **'Activity Type'**
  String get activityType;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @liveSensorData.
  ///
  /// In en, this message translates to:
  /// **'Live Sensor Data'**
  String get liveSensorData;

  /// No description provided for @avgIntensity.
  ///
  /// In en, this message translates to:
  /// **'Avg Intensity'**
  String get avgIntensity;

  /// No description provided for @peakIntensity.
  ///
  /// In en, this message translates to:
  /// **'Peak Intensity'**
  String get peakIntensity;

  /// No description provided for @movements.
  ///
  /// In en, this message translates to:
  /// **'Movements'**
  String get movements;

  /// No description provided for @caloriesBurned.
  ///
  /// In en, this message translates to:
  /// **'Calories Burned'**
  String get caloriesBurned;

  /// No description provided for @bmrPerDay.
  ///
  /// In en, this message translates to:
  /// **'BMR: {bmr} cal/day'**
  String bmrPerDay(String bmr);

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @heartRateMonitor.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate Monitor'**
  String get heartRateMonitor;

  /// No description provided for @toggleFlash.
  ///
  /// In en, this message translates to:
  /// **'Toggle flash'**
  String get toggleFlash;

  /// No description provided for @quietEnvironmentNeeded.
  ///
  /// In en, this message translates to:
  /// **'Quiet environment needed ({seconds} s)'**
  String quietEnvironmentNeeded(String seconds);

  /// No description provided for @estimatedHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Estimated Heart Rate'**
  String get estimatedHeartRate;

  /// No description provided for @flashOff.
  ///
  /// In en, this message translates to:
  /// **'Flash Off'**
  String get flashOff;

  /// No description provided for @flashOn.
  ///
  /// In en, this message translates to:
  /// **'Flash On'**
  String get flashOn;

  /// No description provided for @stableMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Stable measurement'**
  String get stableMeasurement;

  /// No description provided for @resetData.
  ///
  /// In en, this message translates to:
  /// **'Reset Data'**
  String get resetData;

  /// No description provided for @noHumiditySensor.
  ///
  /// In en, this message translates to:
  /// **'No Humidity Sensor Detected'**
  String get noHumiditySensor;

  /// No description provided for @noHumiditySensorDescription.
  ///
  /// In en, this message translates to:
  /// **'Most smartphones don\'t have humidity sensors. Showing simulated data for demonstration.'**
  String get noHumiditySensorDescription;

  /// No description provided for @checkAgain.
  ///
  /// In en, this message translates to:
  /// **'Check Again'**
  String get checkAgain;

  /// No description provided for @measuring.
  ///
  /// In en, this message translates to:
  /// **'Measuring'**
  String get measuring;

  /// No description provided for @stopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get stopped;

  /// No description provided for @singleReading.
  ///
  /// In en, this message translates to:
  /// **'Single Reading'**
  String get singleReading;

  /// No description provided for @continuous.
  ///
  /// In en, this message translates to:
  /// **'Continuous'**
  String get continuous;

  /// No description provided for @comfortAssessment.
  ///
  /// In en, this message translates to:
  /// **'Comfort Assessment'**
  String get comfortAssessment;

  /// No description provided for @readings.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get readings;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @realTimeHumidityLevels.
  ///
  /// In en, this message translates to:
  /// **'Real-time Humidity Levels'**
  String get realTimeHumidityLevels;

  /// No description provided for @humidityLevelGuide.
  ///
  /// In en, this message translates to:
  /// **'Humidity Level Guide'**
  String get humidityLevelGuide;

  /// No description provided for @veryDry.
  ///
  /// In en, this message translates to:
  /// **'Very Dry'**
  String get veryDry;

  /// No description provided for @dry.
  ///
  /// In en, this message translates to:
  /// **'Dry'**
  String get dry;

  /// No description provided for @comfortable.
  ///
  /// In en, this message translates to:
  /// **'Comfortable'**
  String get comfortable;

  /// No description provided for @humid.
  ///
  /// In en, this message translates to:
  /// **'Humid'**
  String get humid;

  /// No description provided for @veryHumid.
  ///
  /// In en, this message translates to:
  /// **'Very Humid'**
  String get veryHumid;

  /// No description provided for @proximitySensor.
  ///
  /// In en, this message translates to:
  /// **'Proximity Sensor'**
  String get proximitySensor;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// No description provided for @sensorNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Sensor Not Available'**
  String get sensorNotAvailable;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @monitor.
  ///
  /// In en, this message translates to:
  /// **'Monitor'**
  String get monitor;

  /// No description provided for @totalReadings.
  ///
  /// In en, this message translates to:
  /// **'Total Readings'**
  String get totalReadings;

  /// No description provided for @near.
  ///
  /// In en, this message translates to:
  /// **'Near'**
  String get near;

  /// No description provided for @far.
  ///
  /// In en, this message translates to:
  /// **'Far'**
  String get far;

  /// No description provided for @proximityActivityTimeline.
  ///
  /// In en, this message translates to:
  /// **'Proximity Activity Timeline'**
  String get proximityActivityTimeline;

  /// No description provided for @howProximitySensorWorks.
  ///
  /// In en, this message translates to:
  /// **'How Proximity Sensor Works'**
  String get howProximitySensorWorks;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcode;

  /// No description provided for @positionBarcodeInFrame.
  ///
  /// In en, this message translates to:
  /// **'Position the barcode within the frame'**
  String get positionBarcodeInFrame;

  /// No description provided for @scanningForBarcodes.
  ///
  /// In en, this message translates to:
  /// **'Scanning for UPC, EAN, Code 128, Code 39, and other linear barcodes'**
  String get scanningForBarcodes;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @positionQrCodeInFrame.
  ///
  /// In en, this message translates to:
  /// **'Position the QR code within the frame'**
  String get positionQrCodeInFrame;

  /// No description provided for @scanningForQrCodes.
  ///
  /// In en, this message translates to:
  /// **'Scanning for QR codes, Data Matrix, PDF417, and Aztec codes'**
  String get scanningForQrCodes;

  /// No description provided for @scannedOn.
  ///
  /// In en, this message translates to:
  /// **'Scanned {timestamp}'**
  String scannedOn(String timestamp);

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @technicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Technical Details'**
  String get technicalDetails;

  /// No description provided for @format.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get format;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @dataLength.
  ///
  /// In en, this message translates to:
  /// **'Data Length'**
  String get dataLength;

  /// No description provided for @scanType.
  ///
  /// In en, this message translates to:
  /// **'Scan Type'**
  String get scanType;

  /// No description provided for @contentType.
  ///
  /// In en, this message translates to:
  /// **'Content Type'**
  String get contentType;

  /// No description provided for @copyAll.
  ///
  /// In en, this message translates to:
  /// **'Copy All'**
  String get copyAll;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @scanAnother.
  ///
  /// In en, this message translates to:
  /// **'Scan Another'**
  String get scanAnother;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @contentCopied.
  ///
  /// In en, this message translates to:
  /// **'Content copied to clipboard for sharing'**
  String get contentCopied;

  /// No description provided for @cannotOpenUrl.
  ///
  /// In en, this message translates to:
  /// **'Cannot open URL'**
  String get cannotOpenUrl;

  /// No description provided for @chooseScannerType.
  ///
  /// In en, this message translates to:
  /// **'Choose Scanner Type'**
  String get chooseScannerType;

  /// No description provided for @selectScannerDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the type of code you want to scan'**
  String get selectScannerDescription;

  /// No description provided for @commonUses.
  ///
  /// In en, this message translates to:
  /// **'Common uses:'**
  String get commonUses;

  /// No description provided for @scanningTips.
  ///
  /// In en, this message translates to:
  /// **'Scanning Tips'**
  String get scanningTips;

  /// No description provided for @scanningTipsDescription.
  ///
  /// In en, this message translates to:
  /// **'Hold your device steady and ensure the code is well-lit and clearly visible within the scanner frame.'**
  String get scanningTipsDescription;

  /// No description provided for @minStat.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get minStat;

  /// No description provided for @maxStat.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get maxStat;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @selectActivity.
  ///
  /// In en, this message translates to:
  /// **'Select Activity'**
  String get selectActivity;

  /// No description provided for @walking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get walking;

  /// No description provided for @running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// No description provided for @cycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get cycling;

  /// No description provided for @environment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environment;

  /// No description provided for @navigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get navigation;

  /// No description provided for @motion.
  ///
  /// In en, this message translates to:
  /// **'Motion'**
  String get motion;

  /// No description provided for @magnetic.
  ///
  /// In en, this message translates to:
  /// **'Magnetic'**
  String get magnetic;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @utility.
  ///
  /// In en, this message translates to:
  /// **'Utility'**
  String get utility;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @kmh.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get kmh;

  /// No description provided for @moving.
  ///
  /// In en, this message translates to:
  /// **'MOVING'**
  String get moving;

  /// No description provided for @stationary.
  ///
  /// In en, this message translates to:
  /// **'STATIONARY'**
  String get stationary;

  /// No description provided for @feet.
  ///
  /// In en, this message translates to:
  /// **'Feet'**
  String get feet;

  /// No description provided for @inches.
  ///
  /// In en, this message translates to:
  /// **'Inches'**
  String get inches;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'ja', 'km'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'ja': return AppLocalizationsJa();
    case 'km': return AppLocalizationsKm();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
