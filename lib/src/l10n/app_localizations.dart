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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
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
    Locale('km'),
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
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ja', 'km'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'km':
      return AppLocalizationsKm();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
