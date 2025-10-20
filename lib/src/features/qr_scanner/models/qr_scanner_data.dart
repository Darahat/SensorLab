import 'dart:ui' show Offset;

import 'package:mobile_scanner/mobile_scanner.dart';

enum QRCodeType {
  qrCode,
  barcode,
  dataMatrix,
  pdf417,
  aztec,
  unknown;

  String get displayName {
    switch (this) {
      case QRCodeType.qrCode:
        return 'QR Code';
      case QRCodeType.barcode:
        return 'Barcode';
      case QRCodeType.dataMatrix:
        return 'Data Matrix';
      case QRCodeType.pdf417:
        return 'PDF417';
      case QRCodeType.aztec:
        return 'Aztec';
      case QRCodeType.unknown:
        return 'Unknown';
    }
  }

  String get icon {
    switch (this) {
      case QRCodeType.qrCode:
        return '📱';
      case QRCodeType.barcode:
        return '🏷️';
      case QRCodeType.dataMatrix:
        return '▫️';
      case QRCodeType.pdf417:
        return '📄';
      case QRCodeType.aztec:
        return '🎯';
      case QRCodeType.unknown:
        return '❓';
    }
  }

  static QRCodeType fromBarcodeFormat(BarcodeFormat format) {
    switch (format) {
      case BarcodeFormat.qrCode:
        return QRCodeType.qrCode;
      case BarcodeFormat.code128:
      case BarcodeFormat.code39:
      case BarcodeFormat.code93:
      case BarcodeFormat.codebar:
      case BarcodeFormat.ean13:
      case BarcodeFormat.ean8:
      case BarcodeFormat.itf:
      case BarcodeFormat.upcA:
      case BarcodeFormat.upcE:
        return QRCodeType.barcode;
      case BarcodeFormat.dataMatrix:
        return QRCodeType.dataMatrix;
      case BarcodeFormat.pdf417:
        return QRCodeType.pdf417;
      case BarcodeFormat.aztec:
        return QRCodeType.aztec;
      default:
        return QRCodeType.unknown;
    }
  }
}

enum QRContentType {
  url,
  email,
  phone,
  sms,
  wifi,
  contact,
  calendar,
  location,
  text,
  product;

  String get displayName {
    switch (this) {
      case QRContentType.url:
        return 'Website URL';
      case QRContentType.email:
        return 'Email';
      case QRContentType.phone:
        return 'Phone Number';
      case QRContentType.sms:
        return 'SMS';
      case QRContentType.wifi:
        return 'WiFi Network';
      case QRContentType.contact:
        return 'Contact Card';
      case QRContentType.calendar:
        return 'Calendar Event';
      case QRContentType.location:
        return 'Location';
      case QRContentType.text:
        return 'Plain Text';
      case QRContentType.product:
        return 'Product';
    }
  }

  String get icon {
    switch (this) {
      case QRContentType.url:
        return '🌐';
      case QRContentType.email:
        return '📧';
      case QRContentType.phone:
        return '📞';
      case QRContentType.sms:
        return '💬';
      case QRContentType.wifi:
        return '📶';
      case QRContentType.contact:
        return '👤';
      case QRContentType.calendar:
        return '📅';
      case QRContentType.location:
        return '📍';
      case QRContentType.text:
        return '📝';
      case QRContentType.product:
        return '🛒';
    }
  }

  static QRContentType fromData(String data) {
    final lowerData = data.toLowerCase();

    if (lowerData.startsWith('http://') || lowerData.startsWith('https://')) {
      return QRContentType.url;
    }
    if (lowerData.startsWith('mailto:')) {
      return QRContentType.email;
    }
    if (lowerData.startsWith('tel:') || lowerData.startsWith('phone:')) {
      return QRContentType.phone;
    }
    if (lowerData.startsWith('sms:') || lowerData.startsWith('smsto:')) {
      return QRContentType.sms;
    }
    if (lowerData.startsWith('wifi:')) {
      return QRContentType.wifi;
    }
    if (lowerData.startsWith('vcard:') || lowerData.startsWith('begin:vcard')) {
      return QRContentType.contact;
    }
    if (lowerData.startsWith('vevent:') ||
        lowerData.startsWith('begin:vevent')) {
      return QRContentType.calendar;
    }
    if (lowerData.startsWith('geo:') || lowerData.contains('maps.google.com')) {
      return QRContentType.location;
    }

    // Check if it's a product code (UPC, EAN, etc.)
    if (RegExp(r'^\d+$').hasMatch(data) &&
        (data.length == 8 || data.length == 12 || data.length == 13)) {
      return QRContentType.product;
    }

    return QRContentType.text;
  }
}

enum ScannerState {
  idle,
  scanning,
  paused,
  error;

  String get displayName {
    switch (this) {
      case ScannerState.idle:
        return 'Ready';
      case ScannerState.scanning:
        return 'Scanning';
      case ScannerState.paused:
        return 'Paused';
      case ScannerState.error:
        return 'Error';
    }
  }

  String get icon {
    switch (this) {
      case ScannerState.idle:
        return '⏸️';
      case ScannerState.scanning:
        return '📷';
      case ScannerState.paused:
        return '⏸️';
      case ScannerState.error:
        return '❌';
    }
  }

  int get statusColor {
    switch (this) {
      case ScannerState.idle:
        return 0xFF2196F3; // Blue
      case ScannerState.scanning:
        return 0xFF4CAF50; // Green
      case ScannerState.paused:
        return 0xFFFF9800; // Orange
      case ScannerState.error:
        return 0xFFF44336; // Red
    }
  }
}

class QRScanResult {
  final String rawData;
  final QRCodeType codeType;
  final QRContentType contentType;
  final BarcodeFormat format;
  final DateTime timestamp;
  final List<Offset> corners;

  const QRScanResult({
    required this.rawData,
    required this.codeType,
    required this.contentType,
    required this.format,
    required this.timestamp,
    this.corners = const [],
  });

  factory QRScanResult.fromCapture(BarcodeCapture capture) {
    final barcode = capture.barcodes.first;
    final data = barcode.rawValue ?? '';

    return QRScanResult(
      rawData: data,
      codeType: QRCodeType.fromBarcodeFormat(barcode.format),
      contentType: QRContentType.fromData(data),
      format: barcode.format,
      timestamp: DateTime.now(),
      corners: barcode.corners
          .map((point) => Offset(point.dx, point.dy))
          .toList(),
    );
  }

  QRScanResult copyWith({
    String? rawData,
    QRCodeType? codeType,
    QRContentType? contentType,
    BarcodeFormat? format,
    DateTime? timestamp,
    List<Offset>? corners,
  }) {
    return QRScanResult(
      rawData: rawData ?? this.rawData,
      codeType: codeType ?? this.codeType,
      contentType: contentType ?? this.contentType,
      format: format ?? this.format,
      timestamp: timestamp ?? this.timestamp,
      corners: corners ?? this.corners,
    );
  }

  // Formatted getters
  String get formattedTimestamp {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  String get displayData {
    if (rawData.length <= 100) return rawData;
    return '${rawData.substring(0, 97)}...';
  }

  String get shortData {
    if (rawData.length <= 50) return rawData;
    return '${rawData.substring(0, 47)}...';
  }

  // Content analysis
  bool get isActionable => contentType != QRContentType.text;

  String get actionDescription {
    switch (contentType) {
      case QRContentType.url:
        return 'Open in browser';
      case QRContentType.email:
        return 'Send email';
      case QRContentType.phone:
        return 'Call number';
      case QRContentType.sms:
        return 'Send SMS';
      case QRContentType.wifi:
        return 'Connect to WiFi';
      case QRContentType.contact:
        return 'Add contact';
      case QRContentType.calendar:
        return 'Add to calendar';
      case QRContentType.location:
        return 'View location';
      case QRContentType.product:
        return 'Search product';
      case QRContentType.text:
        return 'Copy text';
    }
  }

  // WiFi network parsing
  Map<String, String> get wifiInfo {
    if (contentType != QRContentType.wifi) return {};

    final pattern = RegExp(r'WIFI:T:(.*?);S:(.*?);P:(.*?);H:(.*?);');
    final match = pattern.firstMatch(rawData);

    if (match != null) {
      return {
        'security': match.group(1) ?? '',
        'ssid': match.group(2) ?? '',
        'password': match.group(3) ?? '',
        'hidden': match.group(4) ?? '',
      };
    }

    return {};
  }

  // Contact info parsing
  Map<String, String> get contactInfo {
    if (contentType != QRContentType.contact) return {};

    final lines = rawData.split('\n');
    final info = <String, String>{};

    for (final line in lines) {
      if (line.startsWith('FN:')) {
        info['name'] = line.substring(3);
      } else if (line.startsWith('TEL:')) {
        info['phone'] = line.substring(4);
      } else if (line.startsWith('EMAIL:')) {
        info['email'] = line.substring(6);
      } else if (line.startsWith('ORG:')) {
        info['organization'] = line.substring(4);
      }
    }

    return info;
  }

  // URL extraction
  String get url {
    if (contentType == QRContentType.url) {
      return rawData;
    }
    return '';
  }

  // Product code validation
  bool get isValidProductCode {
    if (contentType != QRContentType.product) return false;

    // Basic validation for UPC/EAN codes
    return RegExp(r'^\d{8}$|^\d{12}$|^\d{13}$').hasMatch(rawData);
  }
}

class QRScannerData {
  final QRScanResult? lastScanResult;
  final List<QRScanResult> scanHistory;
  final ScannerState scannerState;
  final bool isTorchOn;
  final bool hasPermission;
  final bool isInitialized;
  final bool autoScan;
  final bool scanOnce;

  // Statistics
  final int totalScans;
  final int uniqueScans;
  final DateTime sessionStartTime;
  final Duration sessionDuration;

  // Camera settings
  final bool hasFlash;
  final CameraFacing cameraFacing;
  final double zoomFactor;

  // Error handling
  final String? errorMessage;

  QRScannerData({
    this.lastScanResult,
    this.scanHistory = const [],
    this.scannerState = ScannerState.idle,
    this.isTorchOn = false,
    this.hasPermission = false,
    this.isInitialized = false,
    this.autoScan = true,
    this.scanOnce = false,
    this.totalScans = 0,
    this.uniqueScans = 0,
    DateTime? sessionStartTime,
    this.sessionDuration = Duration.zero,
    this.hasFlash = false,
    this.cameraFacing = CameraFacing.back,
    this.zoomFactor = 1.0,
    this.errorMessage,
  }) : sessionStartTime = sessionStartTime ?? DateTime.now();

  QRScannerData copyWith({
    QRScanResult? lastScanResult,
    List<QRScanResult>? scanHistory,
    ScannerState? scannerState,
    bool? isTorchOn,
    bool? hasPermission,
    bool? isInitialized,
    bool? autoScan,
    bool? scanOnce,
    int? totalScans,
    int? uniqueScans,
    DateTime? sessionStartTime,
    Duration? sessionDuration,
    bool? hasFlash,
    CameraFacing? cameraFacing,
    double? zoomFactor,
    String? errorMessage,
  }) {
    return QRScannerData(
      lastScanResult: lastScanResult ?? this.lastScanResult,
      scanHistory: scanHistory ?? this.scanHistory,
      scannerState: scannerState ?? this.scannerState,
      isTorchOn: isTorchOn ?? this.isTorchOn,
      hasPermission: hasPermission ?? this.hasPermission,
      isInitialized: isInitialized ?? this.isInitialized,
      autoScan: autoScan ?? this.autoScan,
      scanOnce: scanOnce ?? this.scanOnce,
      totalScans: totalScans ?? this.totalScans,
      uniqueScans: uniqueScans ?? this.uniqueScans,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      hasFlash: hasFlash ?? this.hasFlash,
      cameraFacing: cameraFacing ?? this.cameraFacing,
      zoomFactor: zoomFactor ?? this.zoomFactor,
      errorMessage: errorMessage,
    );
  }

  // Status indicators
  String get statusIcon => scannerState.icon;
  String get statusDescription => scannerState.displayName;
  int get statusColor => scannerState.statusColor;

  // Capabilities
  bool get canScan => hasPermission && isInitialized;
  bool get isScanning => scannerState == ScannerState.scanning;
  bool get hasScanHistory => scanHistory.isNotEmpty;
  bool get hasLastScan => lastScanResult != null;

  // Formatted getters
  String get formattedTotalScans => '$totalScans scans';
  String get formattedUniqueScans => '$uniqueScans unique';
  String get formattedZoom => '${(zoomFactor * 100).toInt()}%';

  String get formattedSessionDuration {
    final hours = sessionDuration.inHours;
    final minutes = sessionDuration.inMinutes % 60;
    final seconds = sessionDuration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  // Statistics
  Map<QRContentType, int> get contentTypeStats {
    final stats = <QRContentType, int>{};

    for (final scan in scanHistory) {
      stats[scan.contentType] = (stats[scan.contentType] ?? 0) + 1;
    }

    return stats;
  }

  Map<QRCodeType, int> get codeTypeStats {
    final stats = <QRCodeType, int>{};

    for (final scan in scanHistory) {
      stats[scan.codeType] = (stats[scan.codeType] ?? 0) + 1;
    }

    return stats;
  }

  QRContentType? get mostScannedContentType {
    final stats = contentTypeStats;
    if (stats.isEmpty) return null;

    return stats.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  double get scanSuccessRate {
    if (totalScans == 0) return 0.0;
    return scanHistory.length / totalScans;
  }

  // Session summary
  String get sessionSummary {
    if (scanHistory.isEmpty) return 'No scans yet';
    return '$formattedTotalScans • $formattedUniqueScans • $formattedSessionDuration';
  }

  // Quick access
  String get lastScannedData => lastScanResult?.displayData ?? 'No scans yet';
  String get lastScannedType => lastScanResult?.contentType.displayName ?? '--';
  String get lastScannedTime => lastScanResult?.formattedTimestamp ?? '--';

  // Camera info
  String get cameraInfo =>
      'Camera: ${cameraFacing.name.toUpperCase()} • Zoom: $formattedZoom';
  String get torchStatus => isTorchOn ? 'Torch: ON' : 'Torch: OFF';
}
