import 'package:mobile_scanner/mobile_scanner.dart';

enum ScanType {
  qrCode,
  barcode;

  String get displayName {
    switch (this) {
      case ScanType.qrCode:
        return 'QR Code';
      case ScanType.barcode:
        return 'Barcode';
    }
  }

  String get icon {
    switch (this) {
      case ScanType.qrCode:
        return '📱';
      case ScanType.barcode:
        return '🏷️';
    }
  }
}

enum ContentType {
  text,
  url,
  email,
  phone,
  sms,
  wifi,
  contact,
  location,
  product,
  calendar;

  String get displayName {
    switch (this) {
      case ContentType.text:
        return 'Plain Text';
      case ContentType.url:
        return 'Website URL';
      case ContentType.email:
        return 'Email Address';
      case ContentType.phone:
        return 'Phone Number';
      case ContentType.sms:
        return 'SMS Message';
      case ContentType.wifi:
        return 'WiFi Network';
      case ContentType.contact:
        return 'Contact Info';
      case ContentType.location:
        return 'Location';
      case ContentType.product:
        return 'Product';
      case ContentType.calendar:
        return 'Calendar Event';
    }
  }

  String get icon {
    switch (this) {
      case ContentType.text:
        return '📝';
      case ContentType.url:
        return '🌐';
      case ContentType.email:
        return '📧';
      case ContentType.phone:
        return '📞';
      case ContentType.sms:
        return '💬';
      case ContentType.wifi:
        return '📶';
      case ContentType.contact:
        return '👤';
      case ContentType.location:
        return '📍';
      case ContentType.product:
        return '🛒';
      case ContentType.calendar:
        return '📅';
    }
  }
}

class ScanResult {
  final String rawData;
  final ScanType scanType;
  final ContentType contentType;
  final BarcodeFormat format;
  final DateTime timestamp;
  final String? formatDetails;

  const ScanResult({
    required this.rawData,
    required this.scanType,
    required this.contentType,
    required this.format,
    required this.timestamp,
    this.formatDetails,
  });

  factory ScanResult.fromBarcode(Barcode barcode) {
    final scanType = _determineScanType(barcode.format);
    final contentType = _determineContentType(barcode.rawValue ?? '', scanType);

    return ScanResult(
      rawData: barcode.rawValue ?? '',
      scanType: scanType,
      contentType: contentType,
      format: barcode.format,
      timestamp: DateTime.now(),
      formatDetails: _getFormatDetails(barcode.format),
    );
  }

  static ScanType _determineScanType(BarcodeFormat format) {
    switch (format) {
      case BarcodeFormat.qrCode:
      case BarcodeFormat.dataMatrix:
      case BarcodeFormat.aztec:
      case BarcodeFormat.pdf417:
        return ScanType.qrCode;
      case BarcodeFormat.ean13:
      case BarcodeFormat.ean8:
      case BarcodeFormat.upcA:
      case BarcodeFormat.upcE:
      case BarcodeFormat.code128:
      case BarcodeFormat.code39:
      case BarcodeFormat.code93:
      case BarcodeFormat.codabar:
      case BarcodeFormat.itf:
        return ScanType.barcode;
      default:
        return ScanType.qrCode;
    }
  }

  static ContentType _determineContentType(String data, ScanType scanType) {
    if (data.isEmpty) return ContentType.text;

    final lowerData = data.toLowerCase();

    // URLs
    if (lowerData.startsWith('http://') || lowerData.startsWith('https://')) {
      return ContentType.url;
    }

    // Email
    if (lowerData.startsWith('mailto:') || _isEmailPattern(data)) {
      return ContentType.email;
    }

    // Phone
    if (lowerData.startsWith('tel:') || _isPhonePattern(data)) {
      return ContentType.phone;
    }

    // SMS
    if (lowerData.startsWith('sms:') || lowerData.startsWith('smsto:')) {
      return ContentType.sms;
    }

    // WiFi
    if (lowerData.startsWith('wifi:')) {
      return ContentType.wifi;
    }

    // Contact (vCard)
    if (lowerData.startsWith('vcard:') || lowerData.startsWith('begin:vcard')) {
      return ContentType.contact;
    }

    // Location
    if (lowerData.startsWith('geo:') || lowerData.contains('maps.google.com')) {
      return ContentType.location;
    }

    // Calendar
    if (lowerData.startsWith('vevent:') ||
        lowerData.startsWith('begin:vevent')) {
      return ContentType.calendar;
    }

    // Product codes for barcodes
    if (scanType == ScanType.barcode && _isProductCode(data)) {
      return ContentType.product;
    }

    return ContentType.text;
  }

  static bool _isEmailPattern(String data) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(data);
  }

  static bool _isPhonePattern(String data) {
    return RegExp(r'^[\+]?[\d\s\-\(\)]+$').hasMatch(data) && data.length >= 7;
  }

  static bool _isProductCode(String data) {
    // Check for common product code patterns
    if (RegExp(r'^\d{8}$').hasMatch(data)) return true; // EAN-8
    if (RegExp(r'^\d{12,13}$').hasMatch(data)) return true; // UPC/EAN-13
    if (RegExp(r'^\d{14}$').hasMatch(data)) return true; // ITF-14
    return false;
  }

  static String? _getFormatDetails(BarcodeFormat format) {
    switch (format) {
      case BarcodeFormat.qrCode:
        return 'Quick Response Code';
      case BarcodeFormat.ean13:
        return 'European Article Number (13 digits)';
      case BarcodeFormat.ean8:
        return 'European Article Number (8 digits)';
      case BarcodeFormat.upcA:
        return 'Universal Product Code (12 digits)';
      case BarcodeFormat.upcE:
        return 'Universal Product Code (8 digits)';
      case BarcodeFormat.code128:
        return 'Code 128 (Variable length)';
      case BarcodeFormat.code39:
        return 'Code 39 (Alphanumeric)';
      case BarcodeFormat.code93:
        return 'Code 93 (Alphanumeric)';
      case BarcodeFormat.codabar:
        return 'Codabar (Numeric with special chars)';
      case BarcodeFormat.itf:
        return 'Interleaved 2 of 5';
      case BarcodeFormat.dataMatrix:
        return 'Data Matrix (2D)';
      case BarcodeFormat.pdf417:
        return 'PDF417 (Stacked linear)';
      case BarcodeFormat.aztec:
        return 'Aztec Code (2D)';
      default:
        return null;
    }
  }

  // Formatted display properties
  String get displayData {
    if (rawData.length <= 100) return rawData;
    return '${rawData.substring(0, 97)}...';
  }

  String get shortData {
    if (rawData.length <= 50) return rawData;
    return '${rawData.substring(0, 47)}...';
  }

  String get formattedTimestamp {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  // Content-specific parsing
  Map<String, String> get parsedContent {
    switch (contentType) {
      case ContentType.wifi:
        return _parseWiFiData();
      case ContentType.contact:
        return _parseContactData();
      case ContentType.location:
        return _parseLocationData();
      default:
        return {'content': rawData};
    }
  }

  Map<String, String> _parseWiFiData() {
    final result = <String, String>{};
    if (!rawData.toLowerCase().startsWith('wifi:')) return result;

    final data = rawData.substring(5);
    final parts = data.split(';');

    for (final part in parts) {
      if (part.contains(':')) {
        final keyValue = part.split(':');
        if (keyValue.length >= 2) {
          final key = keyValue[0].toUpperCase();
          final value = keyValue.sublist(1).join(':');

          switch (key) {
            case 'T':
              result['Security'] = value;
              break;
            case 'S':
              result['Network Name'] = value;
              break;
            case 'P':
              result['Password'] = value;
              break;
            case 'H':
              result['Hidden'] = value == 'true' ? 'Yes' : 'No';
              break;
          }
        }
      }
    }
    return result;
  }

  Map<String, String> _parseContactData() {
    final result = <String, String>{};
    final lines = rawData.split('\n');

    for (final line in lines) {
      if (line.contains(':')) {
        final parts = line.split(':');
        if (parts.length >= 2) {
          final key = parts[0];
          final value = parts.sublist(1).join(':');

          switch (key.toUpperCase()) {
            case 'FN':
              result['Name'] = value;
              break;
            case 'TEL':
              result['Phone'] = value;
              break;
            case 'EMAIL':
              result['Email'] = value;
              break;
            case 'ORG':
              result['Organization'] = value;
              break;
            case 'URL':
              result['Website'] = value;
              break;
          }
        }
      }
    }
    return result;
  }

  Map<String, String> _parseLocationData() {
    final result = <String, String>{};

    if (rawData.toLowerCase().startsWith('geo:')) {
      final coords = rawData.substring(4).split(',');
      if (coords.length >= 2) {
        result['Latitude'] = coords[0].trim();
        result['Longitude'] = coords[1].trim();
      }
    }

    return result;
  }

  // Action availability
  bool get isActionable {
    return contentType != ContentType.text &&
        contentType != ContentType.product;
  }

  String get actionLabel {
    switch (contentType) {
      case ContentType.url:
        return 'Open URL';
      case ContentType.email:
        return 'Send Email';
      case ContentType.phone:
        return 'Call Number';
      case ContentType.sms:
        return 'Send SMS';
      case ContentType.wifi:
        return 'Connect to WiFi';
      case ContentType.contact:
        return 'Add Contact';
      case ContentType.location:
        return 'Open in Maps';
      case ContentType.calendar:
        return 'Add to Calendar';
      default:
        return 'View Details';
    }
  }
}
