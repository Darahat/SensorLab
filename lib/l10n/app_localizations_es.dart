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
  String get done => 'Listo';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get search => 'Buscar';

  @override
  String get settings => 'Configuración';

  @override
  String get retry => 'Reintentar';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Cargando';

  @override
  String get failedToLoadSettings => 'Error al cargar la configuración';

  @override
  String get appearance => 'Apariencia';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get switchBetweenLightAndDarkThemes => 'Alternar entre temas claro y oscuro';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageSubtitle => 'Elige tu idioma preferido';

  @override
  String get notificationsAndFeedback => 'Notificaciones y comentarios';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get receiveAppNotifications => 'Recibir notificaciones de la aplicación';

  @override
  String get vibration => 'Vibración';

  @override
  String get hapticFeedbackForInteractions => 'Retroalimentación háptica para las interacciones';

  @override
  String get soundEffects => 'Efectos de sonido';

  @override
  String get audioFeedbackForAppActions => 'Retroalimentación de audio para acciones de la app';

  @override
  String get sensorSettings => 'Configuración de sensores';

  @override
  String get autoScan => 'Escaneo automático';

  @override
  String get automaticallyScanWhenOpeningScanner => 'Escanear automáticamente al abrir el escáner';

  @override
  String get sensorUpdateFrequency => 'Frecuencia de actualización del sensor';

  @override
  String sensorUpdateFrequencySubtitle(int frequency) {
    return '$frequency ms intervalos';
  }

  @override
  String get privacyAndData => 'Privacidad y datos';

  @override
  String get dataCollection => 'Recolección de datos';

  @override
  String get allowAnonymousUsageAnalytics => 'Permitir análisis anónimo de uso';

  @override
  String get privacyMode => 'Modo privacidad';

  @override
  String get enhancedPrivacyProtection => 'Protección de privacidad mejorada';

  @override
  String get appSupport => 'Soporte de la aplicación';

  @override
  String get showAds => 'Mostrar anuncios';

  @override
  String get supportAppDevelopment => 'Apoyar el desarrollo de la app';

  @override
  String get resetSettings => 'Restablecer ajustes';

  @override
  String get resetAllSettingsToDefaultValues => 'Restablecer todos los ajustes a sus valores predeterminados. Esta acción no puede deshacerse.';

  @override
  String get resetToDefaults => 'Restablecer a los valores predeterminados';

  @override
  String get chooseSensorUpdateFrequency => 'Elige con qué frecuencia deben actualizarse los sensores:';

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
  String get areYouSureResetSettings => '¿Estás seguro de que deseas restablecer todos los ajustes a sus valores predeterminados?';

  @override
  String get thisActionCannotBeUndone => 'Esta acción no puede deshacerse.';

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
  String get speedMeter => 'Velocímetro';

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
  String get qrCodeScanner => 'Escáner de QR';

  @override
  String get barcodeScanner => 'Escáner de código de barras';

  @override
  String get scanResult => 'Resultado del escaneo';

  @override
  String get plainText => 'Texto plano';

  @override
  String get websiteUrl => 'URL del sitio web';

  @override
  String get emailAddress => 'Correo electrónico';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get smsMessage => 'Mensaje SMS';

  @override
  String get wifiNetwork => 'Red Wi-Fi';

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
  String get europeanArticleNumber13 => 'Número de artículo europeo (13 dígitos)';

  @override
  String get europeanArticleNumber8 => 'Número de artículo europeo (8 dígitos)';

  @override
  String get universalProductCode12 => 'Código universal de producto (12 dígitos)';

  @override
  String get universalProductCode8 => 'Código universal de producto (8 dígitos)';

  @override
  String get code128 => 'Código 128 (longitud variable)';

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
  String get torchNotAvailableOnDevice => 'Linterna no disponible en este dispositivo';

  @override
  String get failedToInitializeFlashlight => 'Error al inicializar la linterna';

  @override
  String get failedToToggleFlashlight => 'Error al activar/desactivar la linterna';

  @override
  String get cameraIsInUse => 'La cámara está en uso';

  @override
  String get torchNotAvailable => 'Linterna no disponible';

  @override
  String get failedToEnableTorch => 'Error al habilitar la linterna';

  @override
  String get failedToDisableTorch => 'Error al deshabilitar la linterna';

  @override
  String get intensityControlNotSupported => 'Control de intensidad no compatible con el paquete torch_light';

  @override
  String get failedToSetMode => 'Error al establecer el modo';

  @override
  String get failedToPerformQuickFlash => 'Error al realizar flash rápido';

  @override
  String get noCamerasFound => 'No se encontraron cámaras';

  @override
  String get readyCoverCameraWithFinger => 'Listo — cubre la cámara con el dedo';

  @override
  String get cameraError => 'Error de cámara';

  @override
  String get placeFingerFirmlyOnCamera => 'Coloca el dedo firmemente sobre la cámara';

  @override
  String get pressFingerFirmlyOnCamera => 'Presiona el dedo firmemente sobre la cámara';

  @override
  String get fingerMovedPlaceFirmlyOnCamera => 'El dedo se movió — colócalo firmemente en la cámara';

  @override
  String heartRateBpm(int bpm) {
    return 'Frecuencia cardíaca: $bpm BPM';
  }

  @override
  String get holdStill => 'Mantente quieto…';

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
  String get male => 'Hombre';

  @override
  String get female => 'Mujer';

  @override
  String get other => 'Otro';

  @override
  String get saveProfile => 'Guardar perfil';

  @override
  String get enterYourDetails => 'Introduce tus datos';

  @override
  String get initializationFailed => 'Inicialización fallida';

  @override
  String get allYourSensorsInOnePlace => 'Todos tus sensores en un lugar';

  @override
  String get noSensorsAvailable => 'No hay sensores disponibles';

  @override
  String get active => 'ACTIVO';

  @override
  String get moveYourDevice => 'MUEVE TU DISPOSITIVO';

  @override
  String get accelerationUnit => 'Aceleración (m/s²)';

  @override
  String get axis => 'Eje';

  @override
  String get current => 'Actual';

  @override
  String get max => 'Máximo';

  @override
  String get xAxis => 'X';

  @override
  String get yAxis => 'Y';

  @override
  String get zAxis => 'Z';

  @override
  String get calibrate => 'Calibrar';

  @override
  String get calibrating => 'Calibrando…';

  @override
  String get magneticHeading => 'Dirección magnética';

  @override
  String get highAccuracy => 'Alta precisión';

  @override
  String get compassError => 'Error en la brújula';

  @override
  String get resetSession => 'Reiniciar sesión';

  @override
  String get flashlightNotAvailable => 'Linterna no disponible';

  @override
  String get initializingFlashlight => 'Inicializando linterna…';

  @override
  String get deviceDoesNotHaveFlashlight => 'El dispositivo no tiene linterna o no es accesible';

  @override
  String get tryAgain => 'Intenta de nuevo';

  @override
  String get quickFlash => 'Flash rápido';

  @override
  String get turnOff => 'Apagar';

  @override
  String get turnOn => 'Encender';

  @override
  String get intensityControl => 'Control de intensidad';

  @override
  String currentIntensity(String intensity) {
    return 'Actual: $intensity';
  }

  @override
  String get flashlightModes => 'Modos de linterna';

  @override
  String get normal => 'Normal';

  @override
  String get strobe => 'Estroboscópico';

  @override
  String get sos => 'SOS';

  @override
  String get sessionStatistics => 'Estadísticas de la sesión';

  @override
  String get sessionTime => 'Tiempo de sesión';

  @override
  String get toggles => 'Controles';

  @override
  String get onTime => 'Tiempo activo';

  @override
  String get batteryUsage => 'Uso de batería';

  @override
  String get batteryUsageWarning => 'Advertencia de uso de batería';

  @override
  String flashlightOnFor(String time) {
    return 'La linterna ha estado encendida por $time. Considera apagarla para ahorrar batería.';
  }

  @override
  String get usageTips => 'Consejos de uso';

  @override
  String get normalMode => 'Modo normal';

  @override
  String get normalModeDescription => 'Operación estándar de linterna';

  @override
  String get strobeMode => 'Modo estroboscópico';

  @override
  String get strobeModeDescription => 'Luz parpadeante para llamar la atención';

  @override
  String get sosMode => 'Modo SOS';

  @override
  String get sosModeDescription => 'Señal de emergencia (... --- ...)';

  @override
  String get battery => 'Batería';

  @override
  String get batteryTip => 'Monitorea el uso para preservar la batería';

  @override
  String get intensity => 'Intensidad';

  @override
  String get intensityTip => 'Ajusta el brillo para ahorrar energía';

  @override
  String get pressButtonToGetLocation => 'Presiona el botón para obtener ubicación';

  @override
  String get addressWillAppearHere => 'La dirección aparecerá aquí';

  @override
  String get locationServicesDisabled => 'Los servicios de ubicación están desactivados';

  @override
  String get locationPermissionDenied => 'Permiso de ubicación denegado';

  @override
  String get locationPermissionsPermanentlyDenied => 'Permisos de ubicación permanentemente denegados';

  @override
  String errorGettingLocation(String error) {
    return 'Error al obtener ubicación: $error';
  }

  @override
  String failedToGetAddress(String error) {
    return 'Error al obtener dirección: $error';
  }

  @override
  String get noAppToOpenMaps => 'No hay aplicación para abrir mapas';

  @override
  String get geolocator => 'Geolocalizador';

  @override
  String accuracy(String accuracy) {
    return 'Precisión: $accuracy';
  }

  @override
  String get pleaseEnableLocationServices => 'Por favor, activa los servicios de ubicación';

  @override
  String get pleaseGrantLocationPermissions => 'Por favor, concede los permisos de ubicación';

  @override
  String get locating => 'Localizando...';

  @override
  String get getCurrentLocation => 'Obtener ubicación actual';

  @override
  String get openInMaps => 'Abrir en mapas';

  @override
  String get aboutGeolocator => 'Acerca del geolocalizador';

  @override
  String get geolocatorDescription => 'Esta herramienta muestra tu ubicación actual usando el GPS del dispositivo.\n\nCaracterísticas:\n• Coordenadas precisas de latitud/longitud\n• Estimación de precisión\n• Geocodificación inversa para obtener dirección\n• Abrir ubicación en mapas\n\nPara mejores resultados, asegúrate de:\n• Tener activados los servicios de ubicación\n• Tener una vista despejada del cielo\n• Estar conectado a Internet para buscar dirección';

  @override
  String get ok => 'Aceptar';

  @override
  String get tracking => 'Rastreando';

  @override
  String get waitingForGps => 'Esperando GPS...';

  @override
  String get maxSpeed => 'Velocidad máxima';

  @override
  String get avgSpeed => 'Velocidad promedio';

  @override
  String get motionIntensity => 'Intensidad de movimiento';

  @override
  String get liveSensorGraph => 'Gráfico de sensores en vivo (X – Rojo, Y – Verde, Z – Azul)';

  @override
  String get angularVelocity => 'Velocidad angular (rad/s)';

  @override
  String get healthTracker => 'Rastreador de salud';

  @override
  String helloUser(String name) {
    return 'Hola, $name!';
  }

  @override
  String readyToTrackSession(String activity) {
    return '¿Listo para rastrear tu sesión de $activity?';
  }

  @override
  String get bmi => 'IMC';

  @override
  String get bmr => 'TMB';

  @override
  String get steps => 'Pasos';

  @override
  String get distance => 'Distancia';

  @override
  String get duration => 'Duración';

  @override
  String get activityType => 'Tipo de actividad';

  @override
  String get stop => 'Detener';

  @override
  String get resume => 'Reanudar';

  @override
  String get start => 'Iniciar';

  @override
  String get pause => 'Pausa';

  @override
  String get liveSensorData => 'Datos de sensores en vivo';

  @override
  String get avgIntensity => 'Intensidad promedio';

  @override
  String get peakIntensity => 'Intensidad máxima';

  @override
  String get movements => 'Movimientos';

  @override
  String get caloriesBurned => 'Calorías quemadas';

  @override
  String bmrPerDay(String bmr) {
    return 'TMB: $bmr cal/día';
  }

  @override
  String get profileSettings => 'Configuración de perfil';

  @override
  String get name => 'Nombre';

  @override
  String get age => 'Edad';

  @override
  String get weight => 'Peso';

  @override
  String get height => 'Altura';

  @override
  String get heartRateMonitor => 'Monitor de frecuencia cardíaca';

  @override
  String get toggleFlash => 'Alternar flash';

  @override
  String quietEnvironmentNeeded(String seconds) {
    return 'Se necesita ambiente silencioso ($seconds s)';
  }

  @override
  String get estimatedHeartRate => 'Frecuencia cardíaca estimada';

  @override
  String get flashOff => 'Flash apagado';

  @override
  String get flashOn => 'Flash encendido';

  @override
  String get stableMeasurement => 'Medición estable';

  @override
  String get resetData => 'Restablecer datos';

  @override
  String get noHumiditySensor => 'No se detectó sensor de humedad';

  @override
  String get noHumiditySensorDescription => 'La mayoría de los smartphones no tienen sensores de humedad. Mostrando datos simulados para demostración.';

  @override
  String get checkAgain => 'Comprobar de nuevo';

  @override
  String get measuring => 'Midiendo';

  @override
  String get stopped => 'Detenido';

  @override
  String get singleReading => 'Lectura única';

  @override
  String get continuous => 'Continuo';

  @override
  String get comfortAssessment => 'Evaluación de confort';

  @override
  String get readings => 'Lecturas';

  @override
  String get average => 'Promedio';

  @override
  String get realTimeHumidityLevels => 'Niveles de humedad en tiempo real';

  @override
  String get humidityLevelGuide => 'Guía de niveles de humedad';

  @override
  String get veryDry => 'Muy seco';

  @override
  String get dry => 'Seco';

  @override
  String get comfortable => 'Cómodo';

  @override
  String get humid => 'Húmedo';

  @override
  String get veryHumid => 'Muy húmedo';

  @override
  String get proximitySensor => 'Sensor de proximidad';

  @override
  String get permissionRequired => 'Permiso requerido';

  @override
  String get sensorNotAvailable => 'Sensor no disponible';

  @override
  String get grantPermission => 'Conceder permiso';

  @override
  String get permissionGranted => 'Permiso concedido';

  @override
  String get microphonePermissionDenied => 'Permiso de micrófono denegado';

  @override
  String get microphonePermissionPermanentlyDenied => 'El permiso del micrófono fue denegado permanentemente. Por favor, habilítalo en la configuración de tu dispositivo para usar el medidor de ruido.';

  @override
  String get openSettings => 'Abrir configuración';

  @override
  String get microphoneAccessNeeded => 'Acceso al micrófono necesario';

  @override
  String get microphoneAccessDescription => 'Para medir y analizar los niveles de sonido con precisión, necesitamos acceso al micrófono de tu dispositivo. Tu audio nunca se graba ni se almacena.';

  @override
  String get measureNoiseLevels => 'Medir niveles de ruido en tiempo real';

  @override
  String get analyzeAcoustics => 'Analizar el entorno acústico';

  @override
  String get generateReports => 'Generar informes detallados';

  @override
  String get allowMicrophoneAccess => 'Permitir acceso al micrófono';

  @override
  String get audioNotRecorded => 'El audio nunca se graba ni se almacena';

  @override
  String get inactive => 'Inactivo';

  @override
  String get monitor => 'Monitorear';

  @override
  String get totalReadings => 'Lecturas totales';

  @override
  String get near => 'Cerca';

  @override
  String get far => 'Lejos';

  @override
  String get proximityActivityTimeline => 'Cronología de actividad de proximidad';

  @override
  String get howProximitySensorWorks => 'Cómo funciona el sensor de proximidad';

  @override
  String get scanBarcode => 'Escanear código de barras';

  @override
  String get positionBarcodeInFrame => 'Coloca el código dentro del marco';

  @override
  String get scanningForBarcodes => 'Escaneando UPC, EAN, Código 128, Código 39 y otros códigos lineales';

  @override
  String get scanQrCode => 'Escanear código QR';

  @override
  String get positionQrCodeInFrame => 'Coloca el QR dentro del marco';

  @override
  String get scanningForQrCodes => 'Escaneando códigos QR, Data Matrix, PDF417 y códigos Azteca';

  @override
  String scannedOn(String timestamp) {
    return 'Escaneado el $timestamp';
  }

  @override
  String get content => 'Contenido';

  @override
  String get quickActions => 'Acciones rápidas';

  @override
  String get technicalDetails => 'Detalles técnicos';

  @override
  String get format => 'Formato';

  @override
  String get description => 'Descripción';

  @override
  String get dataLength => 'Longitud de datos';

  @override
  String get scanType => 'Tipo de escaneo';

  @override
  String get contentType => 'Tipo de contenido';

  @override
  String get copyAll => 'Copiar todo';

  @override
  String get share => 'Compartir';

  @override
  String get scanAnother => 'Escanear otro';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get contentCopied => 'Contenido copiado al portapapeles para compartir';

  @override
  String get cannotOpenUrl => 'No se puede abrir la URL';

  @override
  String get chooseScannerType => 'Elige tipo de escáner';

  @override
  String get selectScannerDescription => 'Selecciona el tipo de código que deseas escanear';

  @override
  String get commonUses => 'Usos comunes:';

  @override
  String get scanningTips => 'Consejos de escaneo';

  @override
  String get scanningTipsDescription => 'Mantén tu dispositivo estable y asegúrate de que el código esté bien iluminado y claramente visible dentro del marco del escáner.';

  @override
  String get minStat => 'Mín';

  @override
  String get maxStat => 'Máx';

  @override
  String get gender => 'Género';

  @override
  String get selectActivity => 'Seleccionar actividad';

  @override
  String get walking => 'Caminando';

  @override
  String get running => 'Corriendo';

  @override
  String get cycling => 'Ciclismo';

  @override
  String get sitting => 'Sentado';

  @override
  String get standing => 'De pie';

  @override
  String get stairs => 'Escaleras';

  @override
  String get workout => 'Ejercicio';

  @override
  String get environment => 'Entorno';

  @override
  String get navigation => 'Navegación';

  @override
  String get motion => 'Movimiento';

  @override
  String get magnetic => 'Magnético';

  @override
  String get device => 'Dispositivo';

  @override
  String get utility => 'Utilidad';

  @override
  String get menu => 'Menú';

  @override
  String get kmh => 'km/h';

  @override
  String get moving => 'EN MOVIMIENTO';

  @override
  String get stationary => 'DETENIDO';

  @override
  String get feet => 'Pies';

  @override
  String get inches => 'Pulgadas';

  @override
  String get productBarcodes => 'Códigos de barras de productos';

  @override
  String get isbnNumbers => 'Números ISBN';

  @override
  String get upcCodes => 'Códigos UPC';

  @override
  String get eanCodes => 'Códigos EAN';

  @override
  String get code128_39 => 'Code 128/39';

  @override
  String get websiteUrls => 'URLs de sitios web';

  @override
  String get wifiPasswords => 'Contraseñas WiFi';

  @override
  String get contactInformation => 'Información de contacto';

  @override
  String get locationCoordinates => 'Coordenadas de ubicación';

  @override
  String get calendarEvents => 'Eventos de calendario';

  @override
  String get nearDetection => 'Detección Cercana';

  @override
  String get objectDetectedClose => 'Objeto detectado cerca del sensor';

  @override
  String get usuallyWithin5cm => 'Generalmente cuando algo está dentro de 5cm del sensor';

  @override
  String get farDetection => 'Detección Lejana';

  @override
  String get noObjectDetected => 'No se detectó ningún objeto cerca';

  @override
  String get clearAreaAroundSensor => 'Área despejada alrededor del sensor';

  @override
  String get tooDryIrritation => 'Demasiado seco - puede causar irritación en la piel y respiración';

  @override
  String get somewhatDryHumidifier => 'Algo seco - considera usar un humidificador';

  @override
  String get idealHumidityLevel => 'Nivel de humedad ideal para comodidad y salud';

  @override
  String get somewhatHumidSticky => 'Algo húmedo - puede sentirse pegajoso';

  @override
  String get tooHumidMold => 'Demasiado húmedo - puede favorecer el crecimiento de moho';

  @override
  String get flashlightOn => 'Linterna ENCENDIDA';

  @override
  String get flashlightOff => 'Linterna APAGADA';

  @override
  String get meters => 'metros';

  @override
  String get realTimeLightLevels => 'Niveles de Luz en Tiempo Real';

  @override
  String get lightLevelGuide => 'Guía de Niveles de Luz';

  @override
  String get darkLevel => 'Oscuro';

  @override
  String get dimLevel => 'Tenue';

  @override
  String get indoorLevel => 'Interior';

  @override
  String get officeLevel => 'Oficina';

  @override
  String get brightLevel => 'Brillante';

  @override
  String get daylightLevel => 'Luz del día';

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
  String get darkExample => 'Noche, sin luz de luna';

  @override
  String get dimExample => 'Luz de luna, vela';

  @override
  String get indoorExample => 'Iluminación de sala de estar';

  @override
  String get officeExample => 'Espacio de trabajo de oficina';

  @override
  String get brightExample => 'Habitación brillante, día nublado';

  @override
  String get daylightExample => 'Luz solar directa';

  @override
  String get grantSensorPermission => 'Conceder permisos de sensor para acceder al sensor de proximidad';

  @override
  String get deviceNoProximitySensor => 'El dispositivo no tiene un sensor de proximidad';

  @override
  String get proximitySensorLocation => 'El sensor de proximidad se encuentra típicamente cerca del auricular y se usa para apagar la pantalla durante las llamadas telefónicas.';

  @override
  String get pausedCameraInUse => 'Pausado - Cámara en uso por otra función';

  @override
  String generalError(String error) {
    return 'Error: $error';
  }

  @override
  String currentMode(String mode) {
    return 'Modo actual: $mode';
  }

  @override
  String get noiseLevelGuide => 'Guía de Niveles de Ruido';

  @override
  String get quiet => 'Silencioso';

  @override
  String get moderate => 'Moderado';

  @override
  String get loud => 'Fuerte';

  @override
  String get veryLoud => 'Muy Fuerte';

  @override
  String get dangerous => 'Peligroso';

  @override
  String get whisperLibrary => 'Susurro, biblioteca';

  @override
  String get normalConversation => 'Conversación normal';

  @override
  String get trafficOffice => 'Tráfico, oficina';

  @override
  String get motorcycleShouting => 'Motocicleta, gritos';

  @override
  String get rockConcertChainsaw => 'Concierto de rock, motosierra';

  @override
  String get qrBarcodeScanner => 'Escáner QR/Código de Barras';

  @override
  String get scannedData => 'Datos Escaneados';

  @override
  String get copy => 'Copiar';

  @override
  String get clear => 'Limpiar';

  @override
  String get pageNotFound => 'Página No Encontrada';

  @override
  String get goHome => 'Ir al Inicio';

  @override
  String pageNotFoundMessage(String uri) {
    return 'Página no encontrada: $uri';
  }

  @override
  String get more => 'Más';

  @override
  String get theme => 'Tema';

  @override
  String get about => 'Acerca de';

  @override
  String get allSettings => 'Todas las Configuraciones';

  @override
  String get getNotifiedAboutSensorReadings => 'Recibir notificaciones sobre lecturas de sensores';

  @override
  String get themeChangeRequiresRestart => 'El cambio de tema requiere reiniciar la aplicación';

  @override
  String get quickSettings => 'Configuración Rápida';

  @override
  String get darkModeActive => 'Modo oscuro activo';

  @override
  String get lightModeActive => 'Modo claro activo';

  @override
  String get sensorData => 'DATOS DEL SENSOR';

  @override
  String get stepsLabel => 'Pasos';

  @override
  String get accelX => 'Acel X';

  @override
  String get accelY => 'Acel Y';

  @override
  String get accelZ => 'Acel Z';

  @override
  String get gyroX => 'Giro X';

  @override
  String get gyroY => 'Giro Y';

  @override
  String get gyroZ => 'Giro Z';

  @override
  String get qrScannerSubtitle => 'Escanear códigos QR, Data Matrix, PDF417 y códigos Azteca';

  @override
  String get barcodeScannerSubtitle => 'Escanear códigos de barras de productos como UPC, EAN, Code 128 y más';

  @override
  String get activity => 'Actividad';

  @override
  String get startTracking => 'INICIAR SEGUIMIENTO';

  @override
  String get stopTracking => 'DETENER SEGUIMIENTO';

  @override
  String get trackingActive => 'Seguimiento Activo';

  @override
  String get sessionPaused => 'Sesión Pausada';

  @override
  String get updateYourPersonalInformation => 'Actualiza tu información personal';

  @override
  String get personalInformation => 'Información Personal';

  @override
  String get physicalMeasurements => 'Medidas Físicas';

  @override
  String get enterYourFullName => 'Ingresa tu nombre completo';

  @override
  String get pleaseEnterYourName => 'Por favor ingresa tu nombre';

  @override
  String get enterYourAge => 'Ingresa tu edad';

  @override
  String get pleaseEnterYourAge => 'Por favor ingresa tu edad';

  @override
  String get pleaseEnterValidNumber => 'Por favor ingresa un número válido';

  @override
  String get selectYourGender => 'Selecciona tu género';

  @override
  String get enterYourWeightInKg => 'Ingresa tu peso en kg';

  @override
  String get pleaseEnterYourWeight => 'Por favor ingresa tu peso';

  @override
  String get enterYourHeightInCm => 'Ingresa tu altura en cm';

  @override
  String get pleaseEnterYourHeight => 'Por favor ingresa tu altura';

  @override
  String get pedometer => 'Podómetro';

  @override
  String get dailyGoal => 'Meta Diaria';

  @override
  String get stepsToGo => 'por alcanzar';

  @override
  String get goalReached => '¡Meta Alcanzada!';

  @override
  String get calories => 'Calorías';

  @override
  String get pace => 'Ritmo';

  @override
  String get cadence => 'Cadencia';

  @override
  String get setDailyGoal => 'Establecer Meta Diaria';

  @override
  String get resetSessionConfirmation => '¿Estás seguro de que deseas reiniciar tu sesión actual? Todo el progreso se perderá.';

  @override
  String get barometer => 'Barómetro';

  @override
  String get waitingForSensor => 'Esperando sensor...';

  @override
  String get clearWeather => 'Clima Despejado';

  @override
  String get cloudyWeather => 'Clima Nublado';

  @override
  String get stableWeather => 'Clima Estable';

  @override
  String get pressureRising => 'Subiendo';

  @override
  String get pressureFalling => 'Bajando';

  @override
  String get pressureSteady => 'Estable';

  @override
  String get maximum => 'Máximo';

  @override
  String get minimum => 'Mínimo';

  @override
  String get altitude => 'Altitud';

  @override
  String get altimeter => 'Altímetro';

  @override
  String get altimeterWaiting => 'Esperando datos del altímetro...';

  @override
  String get aboveSeaLevel => 'Sobre el nivel del mar';

  @override
  String get climbing => 'Subiendo';

  @override
  String get descending => 'Bajando';

  @override
  String get stable => 'Estable';

  @override
  String get usingGpsOnly => 'Usando solo GPS';

  @override
  String get usingBarometerOnly => 'Usando solo barómetro';

  @override
  String get usingFusedData => 'Usando datos combinados';

  @override
  String get dataSource => 'Fuente de datos';

  @override
  String get sensorReadings => 'Lecturas del sensor';

  @override
  String get gpsAltitude => 'Altitud GPS';

  @override
  String get baroAltitude => 'Altitud Barométrica';

  @override
  String get pressure => 'Presión';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get gain => 'Ganancia';

  @override
  String get loss => 'Pérdida';

  @override
  String get calibrateAltimeter => 'Calibrar Altímetro';

  @override
  String get calibrateDescription => 'Ingrese su altitud conocida actual para calibrar';

  @override
  String get knownAltitude => 'Altitud conocida';

  @override
  String get calibrationComplete => 'Calibración completada';

  @override
  String get statsReset => 'Estadísticas restablecidas';

  @override
  String get vibrationMeter => 'Medidor de vibración';

  @override
  String get vibrationWaiting => 'Esperando datos de vibración...';

  @override
  String get vibrationMagnitude => 'Magnitud de vibración';

  @override
  String get vibrationLevel => 'Nivel de vibración';

  @override
  String get realtimeWaveform => 'Forma de onda en tiempo real';

  @override
  String get pattern => 'Patrón';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get axisBreakdown => 'Desglose por eje';

  @override
  String get advancedMetrics => 'Métricas avanzadas';

  @override
  String get rms => 'RMS';

  @override
  String get peakToPeak => 'Pico a pico';

  @override
  String get crestFactor => 'Factor de cresta';

  @override
  String get acousticAnalyzer => 'Analizador acústico';

  @override
  String get acousticAnalyzerTitle => 'Analizador Acústico';

  @override
  String get acousticEnvironment => 'Entorno acústico';

  @override
  String get noiseLevel => 'Nivel de ruido';

  @override
  String get decibelUnit => 'dB';

  @override
  String get presetSelectTitle => 'Seleccione un Preajuste';

  @override
  String get presetSelectSubtitle => 'Elija el tipo de análisis acústico';

  @override
  String get presetSleep => 'Dormir';

  @override
  String get presetSleepTitle => 'Analizar Entorno de Sueño';

  @override
  String get presetSleepDuration => '8 horas';

  @override
  String get presetSleepDescription => 'Monitorea el ruido del dormitorio durante la noche para mejorar la calidad del sueño';

  @override
  String get presetWork => 'Trabajo';

  @override
  String get presetWorkTitle => 'Monitorear Entorno de Oficina';

  @override
  String get presetWorkDuration => '1 hora';

  @override
  String get presetWorkDescription => 'Rastrea los niveles de ruido en el lugar de trabajo e identifica distracciones';

  @override
  String get presetFocus => 'Concentración';

  @override
  String get presetFocusTitle => 'Análisis de Sesión de Concentración';

  @override
  String get presetFocusDuration => '30 minutos';

  @override
  String get presetFocusDescription => 'Analiza tu entorno de estudio o sesión de concentración';

  @override
  String get presetCustom => 'Personalizado';

  @override
  String get presetSleepAnalysis => 'Análisis de sueño';

  @override
  String get presetWorkEnvironment => 'Entorno de trabajo';

  @override
  String get presetFocusSession => 'Sesión de concentración';

  @override
  String get presetCustomRecording => 'Grabación personalizada';

  @override
  String get monitoringTitle => 'Monitoreo';

  @override
  String get monitoringActive => 'Monitoreo activo';

  @override
  String get monitoringStopped => 'Monitoreo detenido';

  @override
  String get monitoringProgress => 'Progreso del monitoreo';

  @override
  String get monitoringCurrentLevel => 'Nivel actual';

  @override
  String get monitoringLiveChart => 'Gráfico en vivo';

  @override
  String get monitoringEnvironment => 'Monitoreando Entorno';

  @override
  String get recordingStart => 'Iniciar Grabación';

  @override
  String get recordingStop => 'Detener grabación';

  @override
  String get recordingCompleted => 'Grabación completada';

  @override
  String get reportGeneratedSuccess => 'Informe generado exitosamente';

  @override
  String get stopRecordingTooltip => 'Detener grabación';

  @override
  String get stopRecordingConfirmTitle => '¿Detener grabación?';

  @override
  String get stopRecordingConfirmMessage => '¿Está seguro de que desea detener la grabación actual?';

  @override
  String get continueRecording => 'Continuar grabación';

  @override
  String get reportsTitle => 'Informes';

  @override
  String get reportsEmpty => 'Sin informes';

  @override
  String get reportsEmptyDescription => 'No se encontraron informes. Inicie un análisis para crear uno.';

  @override
  String reportsSelectedCount(int count) {
    return '$count seleccionado(s)';
  }

  @override
  String get reportExportCSV => 'Exportar CSV';

  @override
  String get reportExportAll => 'Exportar todo';

  @override
  String get reportDelete => 'Eliminar';

  @override
  String get reportDeleteSelected => 'Eliminar seleccionados';

  @override
  String get reportDeleteConfirmTitle => '¿Eliminar informe(s)?';

  @override
  String reportDeleteConfirmMessage(int count) {
    return '¿Está seguro de que desea eliminar los informes seleccionados?';
  }

  @override
  String get reportDeleteSuccess => 'Informe(s) eliminado(s) exitosamente';

  @override
  String get reportFilterByPreset => 'Filtrar por preajuste';

  @override
  String get reportFilterAll => 'Todos';

  @override
  String get reportStartAnalysis => 'Iniciar análisis';

  @override
  String get csvCopiedToClipboard => 'CSV copiado al portapapeles';

  @override
  String get reportDetailTitle => 'Detalles del informe';

  @override
  String get reportQualityTitle => 'Calidad';

  @override
  String get reportQualityScore => 'Puntuación de calidad';

  @override
  String get reportAverage => 'Promedio';

  @override
  String get reportPeak => 'Pico';

  @override
  String get reportHourlyBreakdown => 'Desglose por hora';

  @override
  String get reportNoiseEvents => 'Eventos de ruido';

  @override
  String get reportNoEventsTitle => 'Sin eventos';

  @override
  String get reportNoEventsMessage => 'No se detectaron eventos de ruido durante esta sesión';

  @override
  String get reportShare => 'Compartir';

  @override
  String get reportRecommendations => 'Recomendaciones';

  @override
  String get reportDuration => 'Duración';

  @override
  String get reportEvents => 'Eventos';

  @override
  String durationHours(int hours) {
    return 'horas';
  }

  @override
  String durationMinutes(int minutes) {
    return 'minutos';
  }

  @override
  String durationSeconds(int seconds) {
    return 'segundos';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get qualityExcellent => 'Excelente';

  @override
  String get qualityGood => 'Bueno';

  @override
  String get qualityFair => 'Regular';

  @override
  String get qualityPoor => 'Pobre';

  @override
  String get unitDecibels => 'dB';

  @override
  String get unitHours => 'horas';

  @override
  String get unitMinutes => 'minutos';

  @override
  String get unitSeconds => 'segundos';

  @override
  String get actionOk => 'OK';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get actionStop => 'Detener';

  @override
  String get actionStart => 'Iniciar';

  @override
  String get actionView => 'Ver';

  @override
  String get actionExport => 'Exportar';

  @override
  String get actionShare => 'Compartir';

  @override
  String get viewHistoricalReports => 'Ver Informes Históricos';

  @override
  String get csvHeaderID => 'ID';

  @override
  String get csvHeaderStartTime => 'Hora de inicio';

  @override
  String get csvHeaderEndTime => 'Hora de finalización';

  @override
  String get csvHeaderDuration => 'Duración (min)';

  @override
  String get csvHeaderPreset => 'Preajuste';

  @override
  String get csvHeaderAverageDB => 'dB promedio';

  @override
  String get csvHeaderMinDB => 'dB mínimo';

  @override
  String get csvHeaderMaxDB => 'dB máximo';

  @override
  String get csvHeaderEvents => 'Eventos';

  @override
  String get csvHeaderQualityScore => 'Puntuación de calidad';

  @override
  String get csvHeaderQuality => 'Calidad';

  @override
  String get csvHeaderRecommendation => 'Recomendación';

  @override
  String get sleepAnalysis => 'Análisis de sueño';

  @override
  String get workEnvironment => 'Entorno de trabajo';

  @override
  String get focusSession => 'Sesión de concentración';

  @override
  String get recordingComplete => 'Grabación completada';

  @override
  String get presetName => 'Nombre del preajuste';

  @override
  String get averageDecibels => 'Decibelios promedio';

  @override
  String get peakDecibels => 'Decibelios máximos';

  @override
  String get environmentQuality => 'Calidad del entorno';

  @override
  String get viewReport => 'Ver informe';

  @override
  String get noiseMeterGuide => 'Guía del Medidor de Ruido';

  @override
  String get environmentAnalyzer => 'Analizador de Ambiente';

  @override
  String get environmentAnalyzerSubtitle => 'Análisis acústico basado en preajustes';

  @override
  String get acousticReportsSubtitle => 'Ver análisis guardados e historial';

  @override
  String get exportReports => 'Exportar Informes';

  @override
  String get exportChooseMethod => 'Elija cómo desea exportar los informes:';

  @override
  String get exportCopyToClipboard => 'Copiar al Portapapeles';

  @override
  String get exportSaveAsFile => 'Guardar como Archivo';

  @override
  String get exportSuccess => 'Exportación Exitosa';

  @override
  String exportSuccessMessage(int count) {
    return '¡$count informe(s) exportado(s) exitosamente!';
  }

  @override
  String get savedTo => 'Guardado en:';

  @override
  String get deletePreset => '¿Eliminar Preajuste?';

  @override
  String deletePresetMessage(String title) {
    return '¿Eliminar \"$title\"? Esto no se puede deshacer.';
  }

  @override
  String get acousticReport => 'Informe Acústico';

  @override
  String get createCustomPreset => 'Crear Preajuste Personalizado';

  @override
  String get durationMustBeGreaterThanZero => 'La duración debe ser mayor que 0';

  @override
  String get allPresets => 'Todos los Preajustes';

  @override
  String get consistency => 'Consistencia';

  @override
  String get peakManagement => 'Gestión de Picos';

  @override
  String get level => 'Nivel';

  @override
  String get avg => 'Prom';

  @override
  String get realtimeNoiseLevels => 'Niveles de Ruido en Tiempo Real';

  @override
  String get decibelStatistics => 'Estadísticas de Decibeles';

  @override
  String get quietEnvironment => 'Ambiente Tranquilo';

  @override
  String get moderateNoise => 'Ruido Moderado';

  @override
  String get loudEnvironment => 'Ambiente Ruidoso';

  @override
  String get veryLoudCaution => 'Muy Ruidoso - Precaución';

  @override
  String get dangerousLevels => 'Niveles Peligrosos';

  @override
  String get keyStatistics => 'Estadísticas Clave';

  @override
  String get noiseEvents => 'Eventos de Ruido';

  @override
  String get noInterruptionsDetected => 'No se Detectaron Interrupciones';

  @override
  String get environmentConsistentlyQuiet => 'Su ambiente estuvo constantemente tranquilo';

  @override
  String get expertAdvice => 'Consejos de Experto';

  @override
  String get quickTips => 'Consejos Rápidos';

  @override
  String get dataPoints => 'Puntos de Datos';

  @override
  String get grantMicrophonePermission => 'Otorgue permiso de micrófono para medir niveles de ruido';

  @override
  String get hourlyBreakdown => 'Desglose por Hora';

  @override
  String get eventTimeline => 'Línea de Tiempo de Eventos';

  @override
  String get noEventsRecorded => 'No se registraron eventos';

  @override
  String get sessionDetails => 'Detalles de la Sesión';

  @override
  String get date => 'Fecha';

  @override
  String get preset => 'Preajuste';

  @override
  String get recommendation => 'Recomendación';

  @override
  String get noInterruptions => 'Sin Interrupciones';

  @override
  String get quietQuiet => 'Silencioso (0-30 dB)';

  @override
  String get quietModerate => 'Moderado (30-60 dB)';

  @override
  String get quietLoud => 'Ruidoso (60-85 dB)';

  @override
  String get quietVeryLoud => 'Muy Ruidoso (85-100 dB)';

  @override
  String get quietDangerous => 'Peligroso (100+ dB)';

  @override
  String get anErrorOccurred => 'Ocurrió un error.';

  @override
  String failedToLoadPresets(String error) {
    return 'Error al cargar preajustes: $error';
  }

  @override
  String createdPreset(String title) {
    return '¡Creado \"$title\"!';
  }

  @override
  String failedToSavePreset(String error) {
    return 'Error al guardar preajuste: $error';
  }

  @override
  String get deleteReportsQuestion => '¿Eliminar Informes?';

  @override
  String get deleteReportsConfirmMessage => '¿Está seguro de que desea eliminar los informes seleccionados? Esta acción no se puede deshacer.';

  @override
  String get reportsDeleted => 'Informes eliminados';

  @override
  String get presetDetails => 'Detalles del Preajuste';

  @override
  String get mustBeAtLeast3Chars => 'Debe tener al menos 3 caracteres';

  @override
  String get mustBeAtLeast10Chars => 'Debe tener al menos 10 caracteres';

  @override
  String get chooseIcon => 'Elegir ícono';

  @override
  String get chooseColor => 'Elegir color';
}
