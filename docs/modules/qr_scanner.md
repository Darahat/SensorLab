# 📱 QR Scanner Module Documentation

## Overview

The QR Scanner module provides comprehensive QR code and barcode scanning capabilities using the device camera. Supports multiple formats including QR codes, Data Matrix, PDF417, Aztec codes, and various barcode standards.

## 🎯 Features

- **Multi-Format Support**: QR, DataMatrix, PDF417, Aztec, UPC, EAN, Code128
- **Real-time Scanning**: Live camera preview with instant recognition
- **Flashlight Control**: Toggle flashlight for low-light scanning
- **Gallery Import**: Scan codes from gallery images
- **History Management**: Store and manage scan history
- **Custom Actions**: Handle different scan result types

## 📋 Integration Guide

### Dependencies

```yaml
dependencies:
  mobile_scanner: ^3.5.6
  permission_handler: ^11.1.0
  camera: ^0.10.5+5
```

### Basic Implementation

```dart
// Scanner Screen
class QRScannerScreen extends StatefulWidget {
  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: [
          IconButton(
            onPressed: controller.toggleTorch,
            icon: Icon(Icons.flash_on),
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: _onDetect,
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      _handleScanResult(barcode.rawValue ?? '');
    }
  }

  void _handleScanResult(String result) {
    // Process scan result
    if (result.startsWith('http')) {
      // Handle URL
    } else if (result.contains('@')) {
      // Handle email
    } else {
      // Handle text
    }
  }
}
```

## 🔧 Advanced Features

### Custom Scan Overlay

```dart
class ScannerOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.srcOut,
          ),
          child: Container(color: Colors.transparent),
        ),
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
```

### Scan History

```dart
class ScanHistoryProvider extends StateNotifier<List<ScanResult>> {
  ScanHistoryProvider() : super([]);

  void addScan(String result, BarcodeType type) {
    state = [
      ScanResult(
        content: result,
        type: type,
        timestamp: DateTime.now(),
      ),
      ...state,
    ];
  }

  void clearHistory() => state = [];
}
```

## 📱 Usage Examples

### URL Handler

```dart
void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}
```

### Contact Card

```dart
void _addContact(String vCard) {
  // Parse vCard format and add to contacts
}
```

## 🔧 Permissions

```dart
Future<bool> _requestPermissions() async {
  final status = await Permission.camera.request();
  return status == PermissionStatus.granted;
}
```

---
