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
}
