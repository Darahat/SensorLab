// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'SensorLab';

  @override
  String get signInToContinue => 'Inicia sesión para continuar';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get home => 'Inicio';

  @override
  String get cancel => 'Cancelar';

  @override
  String get done => 'Hecho';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get search => 'Buscar';

  @override
  String get settings => 'Ajustes';

  @override
  String get retry => 'Reintentar';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Cargando';

  @override
  String get failedToLoadSettings => 'Error al cargar configuraciones';

  @override
  String get appearance => 'Apariencia';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get switchBetweenLightAndDarkThemes =>
      'Cambiar entre temas claro y oscuro';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get notificationsAndFeedback => 'Notificaciones y comentarios';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get receiveAppNotifications => 'Recibir notificaciones de la app';

  @override
  String get vibration => 'Vibración';

  @override
  String get hapticFeedbackForInteractions =>
      'Respuesta háptica para interacciones';

  @override
  String get soundEffects => 'Efectos de sonido';

  @override
  String get audioFeedbackForAppActions =>
      'Retroalimentación de audio para acciones de la app';

  @override
  String get sensorSettings => 'Configuraciones de sensores';

  @override
  String get autoScan => 'Escaneo automático';

  @override
  String get automaticallyScanWhenOpeningScanner =>
      'Escanear automáticamente al abrir el escáner';

  @override
  String get sensorUpdateFrequency => 'Frecuencia de actualización del sensor';

  @override
  String sensorUpdateFrequencySubtitle(int frequency) {
    return '$frequency ms de intervalo';
  }

  @override
  String get privacyAndData => 'Privacidad y datos';

  @override
  String get dataCollection => 'Recolección de datos';

  @override
  String get allowAnonymousUsageAnalytics => 'Permitir análisis de uso anónimo';

  @override
  String get privacyMode => 'Modo de privacidad';

  @override
  String get enhancedPrivacyProtection => 'Protección de privacidad mejorada';

  @override
  String get appSupport => 'Soporte de la app';

  @override
  String get showAds => 'Mostrar anuncios';

  @override
  String get supportAppDevelopment => 'Apoyar el desarrollo de la app';

  @override
  String get resetSettings => 'Restablecer configuraciones';

  @override
  String get resetAllSettingsToDefaultValues =>
      'Restablecer todas las configuraciones a sus valores predeterminados. Esta acción no se puede deshacer.';

  @override
  String get resetToDefaults => 'Restablecer por defecto';

  @override
  String get chooseSensorUpdateFrequency =>
      'Elija con qué frecuencia deben actualizarse los sensores:';

  @override
  String get fastUpdate => '50 ms (Rápido)';

  @override
  String get normalUpdate => '100 ms (Normal)';

  @override
  String get slowUpdate => '200 ms (Lento)';

  @override
  String get verySlowUpdate => '500 ms (Muy lento)';

  @override
  String get apply => 'Aplicar';

  @override
  String get confirmReset => 'Confirmar restablecimiento';

  @override
  String get areYouSureResetSettings =>
      '¿Estás seguro de que deseas restablecer todas las configuraciones a sus valores predeterminados?';

  @override
  String get thisActionCannotBeUndone => 'Esta acción no se puede deshacer.';

  @override
  String get reset => 'Restablecer';

  @override
  String get accelerometer => 'Acelerómetro';

  @override
  String get compass => 'Brújula';

  @override
  String get flashlight => 'Linterna';

  @override
  String get gyroscope => 'Giroscopio';

  @override
  String get health => 'Salud';

  @override
  String get humidity => 'Humedad';

  @override
  String get lightMeter => 'Medidor de luz';

  @override
  String get magnetometer => 'Magnetómetro';

  @override
  String get noiseMeter => 'Medidor de ruido';

  @override
  String get proximity => 'Proximidad';

  @override
  String get heartRate => 'Frecuencia cardíaca';

  @override
  String get calorieBurn => 'Quema de calorías';

  @override
  String get scanner => 'Escáner';

  @override
  String get qrCode => 'Código QR';

  @override
  String get barcode => 'Código de barras';

  @override
  String get qrCodeScanner => 'Escáner QR';

  @override
  String get barcodeScanner => 'Escáner de código de barras';

  @override
  String get scanResult => 'Resultado del escaneo';

  @override
  String get plainText => 'Texto plano';

  @override
  String get websiteUrl => 'URL del sitio web';

  @override
  String get emailAddress => 'Dirección de correo';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get smsMessage => 'Mensaje SMS';

  @override
  String get wifiNetwork => 'Red WiFi';

  @override
  String get contactInfo => 'Información de contacto';

  @override
  String get location => 'Ubicación';

  @override
  String get product => 'Producto';

  @override
  String get calendarEvent => 'Evento del calendario';

  @override
  String get quickResponseCode => 'Código de respuesta rápida';

  @override
  String get europeanArticleNumber13 =>
      'Número de artículo europeo (13 dígitos)';

  @override
  String get europeanArticleNumber8 => 'Número de artículo europeo (8 dígitos)';

  @override
  String get universalProductCode12 =>
      'Código de producto universal (12 dígitos)';

  @override
  String get universalProductCode8 =>
      'Código de producto universal (8 dígitos)';

  @override
  String get code128 => 'Código 128 (Longitud variable)';

  @override
  String get code39 => 'Código 39 (Alfanumérico)';

  @override
  String get code93 => 'Código 93 (Alfanumérico)';

  @override
  String get codabar => 'Codabar (Numérico con caracteres especiales)';

  @override
  String get interleaved2of5 => 'Intercalado 2 de 5';

  @override
  String get dataMatrix => 'Data Matrix (2D)';

  @override
  String get aztecCode => 'Código Azteca (2D)';

  @override
  String get torchNotAvailableOnDevice =>
      'Linterna no disponible en este dispositivo';

  @override
  String get failedToInitializeFlashlight => 'Error al inicializar la linterna';

  @override
  String get failedToToggleFlashlight =>
      'Error al activar/desactivar la linterna';

  @override
  String get cameraIsInUse => 'La cámara está en uso';

  @override
  String get torchNotAvailable => 'La linterna no está disponible';

  @override
  String get failedToEnableTorch => 'Error al habilitar la linterna';

  @override
  String get failedToDisableTorch => 'Error al deshabilitar la linterna';

  @override
  String get intensityControlNotSupported =>
      'Control de intensidad no compatible con el paquete torch_light';

  @override
  String get failedToSetMode => 'Error al establecer el modo';

  @override
  String get failedToPerformQuickFlash => 'Error al realizar un flash rápido';

  @override
  String get noCamerasFound => 'No se encontraron cámaras';

  @override
  String get readyCoverCameraWithFinger => 'Listo: cubre la cámara con el dedo';

  @override
  String get cameraError => 'Error de cámara';

  @override
  String get placeFingerFirmlyOnCamera =>
      'Coloca el dedo firmemente sobre la cámara';

  @override
  String get pressFingerFirmlyOnCamera =>
      'Presiona el dedo firmemente sobre la cámara';

  @override
  String get fingerMovedPlaceFirmlyOnCamera =>
      'El dedo se movió. Colócalo firmemente sobre la cámara';

  @override
  String heartRateBpm(int bpm) {
    return 'Frecuencia cardíaca: $bpm BPM';
  }

  @override
  String get holdStill => 'Permanece inmóvil...';

  @override
  String get adjustFingerPressure => 'Ajusta la presión del dedo';

  @override
  String get flashError => 'Error de flash';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get weightKg => 'Peso (kg)';

  @override
  String get heightCm => 'Altura (cm)';

  @override
  String get male => 'Masculino';

  @override
  String get female => 'Femenino';

  @override
  String get other => 'Otro';

  @override
  String get saveProfile => 'Guardar perfil';

  @override
  String get enterYourDetails => 'Ingresa tus datos';

  @override
  String get initializationFailed => 'La inicialización falló';
}
