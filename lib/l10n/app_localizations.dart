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

  /// No description provided for @speedMeter.
  ///
  /// In en, this message translates to:
  /// **'Speed Meter'**
  String get speedMeter;

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

  /// No description provided for @tracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get tracking;

  /// No description provided for @waitingForGps.
  ///
  /// In en, this message translates to:
  /// **'Waiting for GPS...'**
  String get waitingForGps;

  /// No description provided for @maxSpeed.
  ///
  /// In en, this message translates to:
  /// **'Max Speed'**
  String get maxSpeed;

  /// No description provided for @avgSpeed.
  ///
  /// In en, this message translates to:
  /// **'Avg Speed'**
  String get avgSpeed;

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

  /// No description provided for @sitting.
  ///
  /// In en, this message translates to:
  /// **'Sitting'**
  String get sitting;

  /// No description provided for @standing.
  ///
  /// In en, this message translates to:
  /// **'Standing'**
  String get standing;

  /// No description provided for @stairs.
  ///
  /// In en, this message translates to:
  /// **'Stairs'**
  String get stairs;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

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

  /// No description provided for @productBarcodes.
  ///
  /// In en, this message translates to:
  /// **'Product barcodes'**
  String get productBarcodes;

  /// No description provided for @isbnNumbers.
  ///
  /// In en, this message translates to:
  /// **'ISBN numbers'**
  String get isbnNumbers;

  /// No description provided for @upcCodes.
  ///
  /// In en, this message translates to:
  /// **'UPC codes'**
  String get upcCodes;

  /// No description provided for @eanCodes.
  ///
  /// In en, this message translates to:
  /// **'EAN codes'**
  String get eanCodes;

  /// No description provided for @code128_39.
  ///
  /// In en, this message translates to:
  /// **'Code 128/39'**
  String get code128_39;

  /// No description provided for @websiteUrls.
  ///
  /// In en, this message translates to:
  /// **'Website URLs'**
  String get websiteUrls;

  /// No description provided for @wifiPasswords.
  ///
  /// In en, this message translates to:
  /// **'WiFi passwords'**
  String get wifiPasswords;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact information'**
  String get contactInformation;

  /// No description provided for @locationCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Location coordinates'**
  String get locationCoordinates;

  /// No description provided for @calendarEvents.
  ///
  /// In en, this message translates to:
  /// **'Calendar events'**
  String get calendarEvents;

  /// No description provided for @nearDetection.
  ///
  /// In en, this message translates to:
  /// **'Near Detection'**
  String get nearDetection;

  /// No description provided for @objectDetectedClose.
  ///
  /// In en, this message translates to:
  /// **'Object detected close to sensor'**
  String get objectDetectedClose;

  /// No description provided for @usuallyWithin5cm.
  ///
  /// In en, this message translates to:
  /// **'Usually when something is within 5cm of the sensor'**
  String get usuallyWithin5cm;

  /// No description provided for @farDetection.
  ///
  /// In en, this message translates to:
  /// **'Far Detection'**
  String get farDetection;

  /// No description provided for @noObjectDetected.
  ///
  /// In en, this message translates to:
  /// **'No object detected nearby'**
  String get noObjectDetected;

  /// No description provided for @clearAreaAroundSensor.
  ///
  /// In en, this message translates to:
  /// **'Clear area around the proximity sensor'**
  String get clearAreaAroundSensor;

  /// No description provided for @tooDryIrritation.
  ///
  /// In en, this message translates to:
  /// **'Too dry - may cause skin and respiratory irritation'**
  String get tooDryIrritation;

  /// No description provided for @somewhatDryHumidifier.
  ///
  /// In en, this message translates to:
  /// **'Somewhat dry - consider using a humidifier'**
  String get somewhatDryHumidifier;

  /// No description provided for @idealHumidityLevel.
  ///
  /// In en, this message translates to:
  /// **'Ideal humidity level for comfort and health'**
  String get idealHumidityLevel;

  /// No description provided for @somewhatHumidSticky.
  ///
  /// In en, this message translates to:
  /// **'Somewhat humid - may feel sticky'**
  String get somewhatHumidSticky;

  /// No description provided for @tooHumidMold.
  ///
  /// In en, this message translates to:
  /// **'Too humid - may promote mold growth'**
  String get tooHumidMold;

  /// No description provided for @flashlightOn.
  ///
  /// In en, this message translates to:
  /// **'Flashlight ON'**
  String get flashlightOn;

  /// No description provided for @flashlightOff.
  ///
  /// In en, this message translates to:
  /// **'Flashlight OFF'**
  String get flashlightOff;

  /// No description provided for @meters.
  ///
  /// In en, this message translates to:
  /// **'meters'**
  String get meters;

  /// No description provided for @realTimeLightLevels.
  ///
  /// In en, this message translates to:
  /// **'Real-time Light Levels'**
  String get realTimeLightLevels;

  /// No description provided for @lightLevelGuide.
  ///
  /// In en, this message translates to:
  /// **'Light Level Guide'**
  String get lightLevelGuide;

  /// No description provided for @darkLevel.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkLevel;

  /// No description provided for @dimLevel.
  ///
  /// In en, this message translates to:
  /// **'Dim'**
  String get dimLevel;

  /// No description provided for @indoorLevel.
  ///
  /// In en, this message translates to:
  /// **'Indoor'**
  String get indoorLevel;

  /// No description provided for @officeLevel.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get officeLevel;

  /// No description provided for @brightLevel.
  ///
  /// In en, this message translates to:
  /// **'Bright'**
  String get brightLevel;

  /// No description provided for @daylightLevel.
  ///
  /// In en, this message translates to:
  /// **'Daylight'**
  String get daylightLevel;

  /// No description provided for @darkRange.
  ///
  /// In en, this message translates to:
  /// **'0-10 lux'**
  String get darkRange;

  /// No description provided for @dimRange.
  ///
  /// In en, this message translates to:
  /// **'10-200 lux'**
  String get dimRange;

  /// No description provided for @indoorRange.
  ///
  /// In en, this message translates to:
  /// **'200-500 lux'**
  String get indoorRange;

  /// No description provided for @officeRange.
  ///
  /// In en, this message translates to:
  /// **'500-1000 lux'**
  String get officeRange;

  /// No description provided for @brightRange.
  ///
  /// In en, this message translates to:
  /// **'1000-10000 lux'**
  String get brightRange;

  /// No description provided for @daylightRange.
  ///
  /// In en, this message translates to:
  /// **'10000+ lux'**
  String get daylightRange;

  /// No description provided for @darkExample.
  ///
  /// In en, this message translates to:
  /// **'Night, no moonlight'**
  String get darkExample;

  /// No description provided for @dimExample.
  ///
  /// In en, this message translates to:
  /// **'Moonlight, candle'**
  String get dimExample;

  /// No description provided for @indoorExample.
  ///
  /// In en, this message translates to:
  /// **'Living room lighting'**
  String get indoorExample;

  /// No description provided for @officeExample.
  ///
  /// In en, this message translates to:
  /// **'Office workspace'**
  String get officeExample;

  /// No description provided for @brightExample.
  ///
  /// In en, this message translates to:
  /// **'Bright room, cloudy day'**
  String get brightExample;

  /// No description provided for @daylightExample.
  ///
  /// In en, this message translates to:
  /// **'Direct sunlight'**
  String get daylightExample;

  /// No description provided for @grantSensorPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant sensor permission to access proximity sensor'**
  String get grantSensorPermission;

  /// No description provided for @deviceNoProximitySensor.
  ///
  /// In en, this message translates to:
  /// **'Device does not have a proximity sensor'**
  String get deviceNoProximitySensor;

  /// No description provided for @proximitySensorLocation.
  ///
  /// In en, this message translates to:
  /// **'The proximity sensor is typically located near the earpiece and is used to turn off the screen during phone calls.'**
  String get proximitySensorLocation;

  /// No description provided for @pausedCameraInUse.
  ///
  /// In en, this message translates to:
  /// **'Paused - Camera in use by another feature'**
  String get pausedCameraInUse;

  /// No description provided for @generalError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String generalError(String error);

  /// No description provided for @currentMode.
  ///
  /// In en, this message translates to:
  /// **'Current mode: {mode}'**
  String currentMode(String mode);

  /// No description provided for @noiseLevelGuide.
  ///
  /// In en, this message translates to:
  /// **'Noise Level Guide'**
  String get noiseLevelGuide;

  /// No description provided for @quiet.
  ///
  /// In en, this message translates to:
  /// **'Quiet'**
  String get quiet;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @loud.
  ///
  /// In en, this message translates to:
  /// **'Loud'**
  String get loud;

  /// No description provided for @veryLoud.
  ///
  /// In en, this message translates to:
  /// **'Very Loud'**
  String get veryLoud;

  /// No description provided for @dangerous.
  ///
  /// In en, this message translates to:
  /// **'Dangerous'**
  String get dangerous;

  /// No description provided for @whisperLibrary.
  ///
  /// In en, this message translates to:
  /// **'Whisper, library'**
  String get whisperLibrary;

  /// No description provided for @normalConversation.
  ///
  /// In en, this message translates to:
  /// **'Normal conversation'**
  String get normalConversation;

  /// No description provided for @trafficOffice.
  ///
  /// In en, this message translates to:
  /// **'Traffic, office'**
  String get trafficOffice;

  /// No description provided for @motorcycleShouting.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle, shouting'**
  String get motorcycleShouting;

  /// No description provided for @rockConcertChainsaw.
  ///
  /// In en, this message translates to:
  /// **'Rock concert, chainsaw'**
  String get rockConcertChainsaw;

  /// No description provided for @qrBarcodeScanner.
  ///
  /// In en, this message translates to:
  /// **'QR/Barcode Scanner'**
  String get qrBarcodeScanner;

  /// No description provided for @scannedData.
  ///
  /// In en, this message translates to:
  /// **'Scanned Data'**
  String get scannedData;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get pageNotFound;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// No description provided for @pageNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Page not found: {uri}'**
  String pageNotFoundMessage(String uri);

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @allSettings.
  ///
  /// In en, this message translates to:
  /// **'All Settings'**
  String get allSettings;

  /// No description provided for @getNotifiedAboutSensorReadings.
  ///
  /// In en, this message translates to:
  /// **'Get notified about sensor readings'**
  String get getNotifiedAboutSensorReadings;

  /// No description provided for @themeChangeRequiresRestart.
  ///
  /// In en, this message translates to:
  /// **'Theme switching requires app restart'**
  String get themeChangeRequiresRestart;

  /// No description provided for @quickSettings.
  ///
  /// In en, this message translates to:
  /// **'Quick Settings'**
  String get quickSettings;

  /// No description provided for @darkModeActive.
  ///
  /// In en, this message translates to:
  /// **'Dark mode active'**
  String get darkModeActive;

  /// No description provided for @lightModeActive.
  ///
  /// In en, this message translates to:
  /// **'Light mode active'**
  String get lightModeActive;

  /// No description provided for @sensorData.
  ///
  /// In en, this message translates to:
  /// **'SENSOR DATA'**
  String get sensorData;

  /// No description provided for @stepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get stepsLabel;

  /// No description provided for @accelX.
  ///
  /// In en, this message translates to:
  /// **'Accel X'**
  String get accelX;

  /// No description provided for @accelY.
  ///
  /// In en, this message translates to:
  /// **'Accel Y'**
  String get accelY;

  /// No description provided for @accelZ.
  ///
  /// In en, this message translates to:
  /// **'Accel Z'**
  String get accelZ;

  /// No description provided for @gyroX.
  ///
  /// In en, this message translates to:
  /// **'Gyro X'**
  String get gyroX;

  /// No description provided for @gyroY.
  ///
  /// In en, this message translates to:
  /// **'Gyro Y'**
  String get gyroY;

  /// No description provided for @gyroZ.
  ///
  /// In en, this message translates to:
  /// **'Gyro Z'**
  String get gyroZ;

  /// No description provided for @qrScannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan QR codes, Data Matrix, PDF417, and Aztec codes'**
  String get qrScannerSubtitle;

  /// No description provided for @barcodeScannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan product barcodes like UPC, EAN, Code 128, and more'**
  String get barcodeScannerSubtitle;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @startTracking.
  ///
  /// In en, this message translates to:
  /// **'START TRACKING'**
  String get startTracking;

  /// No description provided for @stopTracking.
  ///
  /// In en, this message translates to:
  /// **'STOP TRACKING'**
  String get stopTracking;

  /// No description provided for @trackingActive.
  ///
  /// In en, this message translates to:
  /// **'Tracking Active'**
  String get trackingActive;

  /// No description provided for @sessionPaused.
  ///
  /// In en, this message translates to:
  /// **'Session Paused'**
  String get sessionPaused;

  /// No description provided for @updateYourPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get updateYourPersonalInformation;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @physicalMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Physical Measurements'**
  String get physicalMeasurements;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @enterYourAge.
  ///
  /// In en, this message translates to:
  /// **'Enter your age'**
  String get enterYourAge;

  /// No description provided for @pleaseEnterYourAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter your age'**
  String get pleaseEnterYourAge;

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// No description provided for @selectYourGender.
  ///
  /// In en, this message translates to:
  /// **'Select your gender'**
  String get selectYourGender;

  /// No description provided for @enterYourWeightInKg.
  ///
  /// In en, this message translates to:
  /// **'Enter your weight in kg'**
  String get enterYourWeightInKg;

  /// No description provided for @pleaseEnterYourWeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter your weight'**
  String get pleaseEnterYourWeight;

  /// No description provided for @enterYourHeightInCm.
  ///
  /// In en, this message translates to:
  /// **'Enter your height in cm'**
  String get enterYourHeightInCm;

  /// No description provided for @pleaseEnterYourHeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter your height'**
  String get pleaseEnterYourHeight;

  /// No description provided for @pedometer.
  ///
  /// In en, this message translates to:
  /// **'Pedometer'**
  String get pedometer;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// No description provided for @stepsToGo.
  ///
  /// In en, this message translates to:
  /// **'to go'**
  String get stepsToGo;

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'Goal Reached!'**
  String get goalReached;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @pace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get pace;

  /// No description provided for @cadence.
  ///
  /// In en, this message translates to:
  /// **'Cadence'**
  String get cadence;

  /// No description provided for @setDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Set Daily Goal'**
  String get setDailyGoal;

  /// No description provided for @resetSessionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset your current session? All progress will be lost.'**
  String get resetSessionConfirmation;

  /// No description provided for @barometer.
  ///
  /// In en, this message translates to:
  /// **'Barometer'**
  String get barometer;

  /// No description provided for @waitingForSensor.
  ///
  /// In en, this message translates to:
  /// **'Waiting for sensor...'**
  String get waitingForSensor;

  /// No description provided for @clearWeather.
  ///
  /// In en, this message translates to:
  /// **'Clear Weather'**
  String get clearWeather;

  /// No description provided for @cloudyWeather.
  ///
  /// In en, this message translates to:
  /// **'Cloudy Weather'**
  String get cloudyWeather;

  /// No description provided for @stableWeather.
  ///
  /// In en, this message translates to:
  /// **'Stable Weather'**
  String get stableWeather;

  /// No description provided for @pressureRising.
  ///
  /// In en, this message translates to:
  /// **'Rising'**
  String get pressureRising;

  /// No description provided for @pressureFalling.
  ///
  /// In en, this message translates to:
  /// **'Falling'**
  String get pressureFalling;

  /// No description provided for @pressureSteady.
  ///
  /// In en, this message translates to:
  /// **'Steady'**
  String get pressureSteady;

  /// No description provided for @maximum.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get maximum;

  /// No description provided for @minimum.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get minimum;

  /// No description provided for @altitude.
  ///
  /// In en, this message translates to:
  /// **'Altitude'**
  String get altitude;

  /// No description provided for @altimeter.
  ///
  /// In en, this message translates to:
  /// **'Altimeter'**
  String get altimeter;

  /// No description provided for @altimeterWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for GPS and barometer data...'**
  String get altimeterWaiting;

  /// No description provided for @aboveSeaLevel.
  ///
  /// In en, this message translates to:
  /// **'Above Sea Level'**
  String get aboveSeaLevel;

  /// No description provided for @climbing.
  ///
  /// In en, this message translates to:
  /// **'Climbing'**
  String get climbing;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @usingGpsOnly.
  ///
  /// In en, this message translates to:
  /// **'Using GPS data only'**
  String get usingGpsOnly;

  /// No description provided for @usingBarometerOnly.
  ///
  /// In en, this message translates to:
  /// **'Using barometer data only'**
  String get usingBarometerOnly;

  /// No description provided for @usingFusedData.
  ///
  /// In en, this message translates to:
  /// **'Combining GPS and barometer for accuracy'**
  String get usingFusedData;

  /// No description provided for @dataSource.
  ///
  /// In en, this message translates to:
  /// **'Data Source'**
  String get dataSource;

  /// No description provided for @sensorReadings.
  ///
  /// In en, this message translates to:
  /// **'Sensor Readings'**
  String get sensorReadings;

  /// No description provided for @gpsAltitude.
  ///
  /// In en, this message translates to:
  /// **'GPS Altitude'**
  String get gpsAltitude;

  /// No description provided for @baroAltitude.
  ///
  /// In en, this message translates to:
  /// **'Baro Altitude'**
  String get baroAltitude;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @gain.
  ///
  /// In en, this message translates to:
  /// **'Gain'**
  String get gain;

  /// No description provided for @loss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get loss;

  /// No description provided for @calibrateAltimeter.
  ///
  /// In en, this message translates to:
  /// **'Calibrate Altimeter'**
  String get calibrateAltimeter;

  /// No description provided for @calibrateDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your current known altitude in meters to calibrate the barometric sensor for better accuracy.'**
  String get calibrateDescription;

  /// No description provided for @knownAltitude.
  ///
  /// In en, this message translates to:
  /// **'Known Altitude'**
  String get knownAltitude;

  /// No description provided for @calibrationComplete.
  ///
  /// In en, this message translates to:
  /// **'Calibration complete!'**
  String get calibrationComplete;

  /// No description provided for @statsReset.
  ///
  /// In en, this message translates to:
  /// **'Statistics reset!'**
  String get statsReset;

  /// No description provided for @vibrationMeter.
  ///
  /// In en, this message translates to:
  /// **'Vibration Meter'**
  String get vibrationMeter;

  /// No description provided for @vibrationWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for accelerometer data...'**
  String get vibrationWaiting;

  /// No description provided for @vibrationMagnitude.
  ///
  /// In en, this message translates to:
  /// **'Vibration Magnitude'**
  String get vibrationMagnitude;

  /// No description provided for @vibrationLevel.
  ///
  /// In en, this message translates to:
  /// **'Vibration Level'**
  String get vibrationLevel;

  /// No description provided for @realtimeWaveform.
  ///
  /// In en, this message translates to:
  /// **'Real-time Waveform'**
  String get realtimeWaveform;

  /// No description provided for @pattern.
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get pattern;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @axisBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Axis Breakdown'**
  String get axisBreakdown;

  /// No description provided for @advancedMetrics.
  ///
  /// In en, this message translates to:
  /// **'Advanced Metrics'**
  String get advancedMetrics;

  /// No description provided for @rms.
  ///
  /// In en, this message translates to:
  /// **'RMS'**
  String get rms;

  /// No description provided for @peakToPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak-to-Peak'**
  String get peakToPeak;

  /// No description provided for @crestFactor.
  ///
  /// In en, this message translates to:
  /// **'Crest Factor'**
  String get crestFactor;

  /// No description provided for @acousticAnalyzer.
  ///
  /// In en, this message translates to:
  /// **'Acoustic Analyzer'**
  String get acousticAnalyzer;

  /// No description provided for @acousticAnalyzerTitle.
  ///
  /// In en, this message translates to:
  /// **'Acoustic Environment Analyzer'**
  String get acousticAnalyzerTitle;

  /// No description provided for @acousticEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Acoustic Environment'**
  String get acousticEnvironment;

  /// No description provided for @noiseLevel.
  ///
  /// In en, this message translates to:
  /// **'Noise Level'**
  String get noiseLevel;

  /// No description provided for @decibelUnit.
  ///
  /// In en, this message translates to:
  /// **'dB'**
  String get decibelUnit;

  /// No description provided for @presetSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Recording Preset'**
  String get presetSelectTitle;

  /// No description provided for @presetSelectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select a preset to analyze your acoustic environment over time'**
  String get presetSelectSubtitle;

  /// No description provided for @presetSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get presetSleep;

  /// No description provided for @presetSleepTitle.
  ///
  /// In en, this message translates to:
  /// **'Analyze Sleep Environment'**
  String get presetSleepTitle;

  /// No description provided for @presetSleepDuration.
  ///
  /// In en, this message translates to:
  /// **'8 hours'**
  String get presetSleepDuration;

  /// No description provided for @presetSleepDescription.
  ///
  /// In en, this message translates to:
  /// **'Monitor bedroom noise throughout the night to improve sleep quality'**
  String get presetSleepDescription;

  /// No description provided for @presetWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get presetWork;

  /// No description provided for @presetWorkTitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor Office Environment'**
  String get presetWorkTitle;

  /// No description provided for @presetWorkDuration.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get presetWorkDuration;

  /// No description provided for @presetWorkDescription.
  ///
  /// In en, this message translates to:
  /// **'Track workplace noise levels and identify distractions'**
  String get presetWorkDescription;

  /// No description provided for @presetFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get presetFocus;

  /// No description provided for @presetFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus Session Analysis'**
  String get presetFocusTitle;

  /// No description provided for @presetFocusDuration.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get presetFocusDuration;

  /// No description provided for @presetFocusDescription.
  ///
  /// In en, this message translates to:
  /// **'Analyze your study or focus session environment'**
  String get presetFocusDescription;

  /// No description provided for @presetCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get presetCustom;

  /// No description provided for @presetSleepAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Sleep Analysis (8h)'**
  String get presetSleepAnalysis;

  /// No description provided for @presetWorkEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Work Environment (1h)'**
  String get presetWorkEnvironment;

  /// No description provided for @presetFocusSession.
  ///
  /// In en, this message translates to:
  /// **'Focus Session (30m)'**
  String get presetFocusSession;

  /// No description provided for @presetCustomRecording.
  ///
  /// In en, this message translates to:
  /// **'Custom Recording'**
  String get presetCustomRecording;

  /// No description provided for @monitoringTitle.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get monitoringTitle;

  /// No description provided for @monitoringActive.
  ///
  /// In en, this message translates to:
  /// **'Recording Active'**
  String get monitoringActive;

  /// No description provided for @monitoringStopped.
  ///
  /// In en, this message translates to:
  /// **'Recording Stopped'**
  String get monitoringStopped;

  /// No description provided for @monitoringProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get monitoringProgress;

  /// No description provided for @monitoringCurrentLevel.
  ///
  /// In en, this message translates to:
  /// **'Current Level'**
  String get monitoringCurrentLevel;

  /// No description provided for @monitoringLiveChart.
  ///
  /// In en, this message translates to:
  /// **'Live Monitoring'**
  String get monitoringLiveChart;

  /// No description provided for @monitoringEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Monitoring acoustic environment...'**
  String get monitoringEnvironment;

  /// No description provided for @recordingStart.
  ///
  /// In en, this message translates to:
  /// **'Start Recording'**
  String get recordingStart;

  /// No description provided for @recordingStop.
  ///
  /// In en, this message translates to:
  /// **'Stop Recording'**
  String get recordingStop;

  /// No description provided for @recordingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Recording completed'**
  String get recordingCompleted;

  /// No description provided for @reportGeneratedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Report generated successfully!'**
  String get reportGeneratedSuccess;

  /// No description provided for @stopRecordingTooltip.
  ///
  /// In en, this message translates to:
  /// **'Stop Recording'**
  String get stopRecordingTooltip;

  /// No description provided for @stopRecordingConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop Recording?'**
  String get stopRecordingConfirmTitle;

  /// No description provided for @stopRecordingConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to stop the recording? The report will be generated with the current data.'**
  String get stopRecordingConfirmMessage;

  /// No description provided for @continueRecording.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueRecording;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Acoustic Reports'**
  String get reportsTitle;

  /// No description provided for @reportsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No Reports Yet'**
  String get reportsEmpty;

  /// No description provided for @reportsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Start an acoustic analysis session to generate your first report'**
  String get reportsEmptyDescription;

  /// No description provided for @reportsSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Selected'**
  String reportsSelectedCount(int count);

  /// No description provided for @reportExportCSV.
  ///
  /// In en, this message translates to:
  /// **'Export as CSV'**
  String get reportExportCSV;

  /// No description provided for @reportExportAll.
  ///
  /// In en, this message translates to:
  /// **'Export All'**
  String get reportExportAll;

  /// No description provided for @reportDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get reportDelete;

  /// No description provided for @reportDeleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get reportDeleteSelected;

  /// No description provided for @reportDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Reports?'**
  String get reportDeleteConfirmTitle;

  /// No description provided for @reportDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} report(s)? This action cannot be undone.'**
  String reportDeleteConfirmMessage(int count);

  /// No description provided for @reportDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reports deleted'**
  String get reportDeleteSuccess;

  /// No description provided for @reportFilterByPreset.
  ///
  /// In en, this message translates to:
  /// **'Filter by Preset'**
  String get reportFilterByPreset;

  /// No description provided for @reportFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All Presets'**
  String get reportFilterAll;

  /// No description provided for @reportStartAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Start Analysis'**
  String get reportStartAnalysis;

  /// No description provided for @csvCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'CSV data copied to clipboard!'**
  String get csvCopiedToClipboard;

  /// No description provided for @reportDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Acoustic Report'**
  String get reportDetailTitle;

  /// No description provided for @reportQualityTitle.
  ///
  /// In en, this message translates to:
  /// **'Environment Quality'**
  String get reportQualityTitle;

  /// No description provided for @reportQualityScore.
  ///
  /// In en, this message translates to:
  /// **'Quality Score'**
  String get reportQualityScore;

  /// No description provided for @reportAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get reportAverage;

  /// No description provided for @reportPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak'**
  String get reportPeak;

  /// No description provided for @reportHourlyBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Hourly Breakdown'**
  String get reportHourlyBreakdown;

  /// No description provided for @reportNoiseEvents.
  ///
  /// In en, this message translates to:
  /// **'Noise Events'**
  String get reportNoiseEvents;

  /// No description provided for @reportNoEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Interruptions Detected'**
  String get reportNoEventsTitle;

  /// No description provided for @reportNoEventsMessage.
  ///
  /// In en, this message translates to:
  /// **'Your environment was consistently quiet'**
  String get reportNoEventsMessage;

  /// No description provided for @reportShare.
  ///
  /// In en, this message translates to:
  /// **'Share Report'**
  String get reportShare;

  /// No description provided for @reportRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get reportRecommendations;

  /// No description provided for @reportDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get reportDuration;

  /// No description provided for @reportEvents.
  ///
  /// In en, this message translates to:
  /// **'events'**
  String get reportEvents;

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h'**
  String durationHours(int hours);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String durationMinutes(int minutes);

  /// No description provided for @durationSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String durationSeconds(int seconds);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @qualityExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get qualityExcellent;

  /// No description provided for @qualityGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get qualityGood;

  /// No description provided for @qualityFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get qualityFair;

  /// No description provided for @qualityPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get qualityPoor;

  /// No description provided for @unitDecibels.
  ///
  /// In en, this message translates to:
  /// **'dB'**
  String get unitDecibels;

  /// No description provided for @unitHours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get unitHours;

  /// No description provided for @unitMinutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get unitMinutes;

  /// No description provided for @unitSeconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get unitSeconds;

  /// No description provided for @actionOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get actionStop;

  /// No description provided for @actionStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get actionStart;

  /// No description provided for @actionView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get actionView;

  /// No description provided for @actionExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get actionExport;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @viewHistoricalReports.
  ///
  /// In en, this message translates to:
  /// **'View Historical Reports'**
  String get viewHistoricalReports;

  /// No description provided for @csvHeaderID.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get csvHeaderID;

  /// No description provided for @csvHeaderStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get csvHeaderStartTime;

  /// No description provided for @csvHeaderEndTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get csvHeaderEndTime;

  /// No description provided for @csvHeaderDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration (min)'**
  String get csvHeaderDuration;

  /// No description provided for @csvHeaderPreset.
  ///
  /// In en, this message translates to:
  /// **'Preset'**
  String get csvHeaderPreset;

  /// No description provided for @csvHeaderAverageDB.
  ///
  /// In en, this message translates to:
  /// **'Average dB'**
  String get csvHeaderAverageDB;

  /// No description provided for @csvHeaderMinDB.
  ///
  /// In en, this message translates to:
  /// **'Min dB'**
  String get csvHeaderMinDB;

  /// No description provided for @csvHeaderMaxDB.
  ///
  /// In en, this message translates to:
  /// **'Max dB'**
  String get csvHeaderMaxDB;

  /// No description provided for @csvHeaderEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get csvHeaderEvents;

  /// No description provided for @csvHeaderQualityScore.
  ///
  /// In en, this message translates to:
  /// **'Quality Score'**
  String get csvHeaderQualityScore;

  /// No description provided for @csvHeaderQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get csvHeaderQuality;

  /// No description provided for @csvHeaderRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get csvHeaderRecommendation;

  /// No description provided for @sleepAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Sleep Analysis'**
  String get sleepAnalysis;

  /// No description provided for @workEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Work Environment'**
  String get workEnvironment;

  /// No description provided for @focusSession.
  ///
  /// In en, this message translates to:
  /// **'Focus Session'**
  String get focusSession;

  /// No description provided for @recordingComplete.
  ///
  /// In en, this message translates to:
  /// **'Recording Complete'**
  String get recordingComplete;

  /// No description provided for @presetName.
  ///
  /// In en, this message translates to:
  /// **'Preset Name'**
  String get presetName;

  /// No description provided for @averageDecibels.
  ///
  /// In en, this message translates to:
  /// **'Average Decibels'**
  String get averageDecibels;

  /// No description provided for @peakDecibels.
  ///
  /// In en, this message translates to:
  /// **'Peak Decibels'**
  String get peakDecibels;

  /// No description provided for @environmentQuality.
  ///
  /// In en, this message translates to:
  /// **'Environment Quality'**
  String get environmentQuality;

  /// No description provided for @viewReport.
  ///
  /// In en, this message translates to:
  /// **'View Report'**
  String get viewReport;
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
