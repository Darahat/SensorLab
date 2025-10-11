import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../models/qr_scanner_data.dart';

// Provider instance
final qrScannerProvider =
    StateNotifierProvider<QRScannerProvider, QRScannerData>(
      (ref) => QRScannerProvider(),
    );

class QRScannerProvider extends StateNotifier<QRScannerData> {
  QRScannerProvider() : super(QRScannerData());

  MobileScannerController? _controller;
  Timer? _sessionTimer;

  @override
  void dispose() {
    stopScanner();
    super.dispose();
  }

  // Initialize scanner
  Future<void> initialize() async {
    state = state.copyWith(
      isInitialized: false,
      errorMessage: null,
      sessionStartTime: DateTime.now(),
    );

    try {
      _controller = MobileScannerController(
        facing: state.cameraFacing,
        detectionSpeed: DetectionSpeed.noDuplicates,
        returnImage: false,
      );

      // Check permissions
      await _controller!.start();

      // Start session timer
      _sessionTimer = Timer.periodic(Duration(seconds: 1), (_) {
        _updateSessionDuration();
      });

      state = state.copyWith(
        isInitialized: true,
        hasPermission: true,
        scannerState: ScannerState.idle,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to initialize scanner: $e',
        hasPermission: false,
        isInitialized: true,
      );
    }
  }

  // Scanner control
  Future<void> startScanner() async {
    if (!state.canScan || state.isScanning) return;

    try {
      if (_controller == null) {
        await initialize();
        return;
      }

      await _controller!.start();

      state = state.copyWith(
        scannerState: ScannerState.scanning,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to start scanner: $e',
        scannerState: ScannerState.error,
      );
    }
  }

  Future<void> stopScanner() async {
    try {
      _sessionTimer?.cancel();

      if (_controller != null) {
        await _controller!.stop();
      }

      state = state.copyWith(scannerState: ScannerState.idle);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to stop scanner: $e');
    }
  }

  Future<void> pauseScanner() async {
    if (!state.isScanning) return;

    try {
      await _controller?.stop();
      state = state.copyWith(scannerState: ScannerState.paused);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to pause scanner: $e');
    }
  }

  Future<void> resumeScanner() async {
    if (state.scannerState != ScannerState.paused) return;

    try {
      await _controller?.start();
      state = state.copyWith(scannerState: ScannerState.scanning);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to resume scanner: $e');
    }
  }

  // Torch control
  Future<void> toggleTorch() async {
    try {
      await _controller?.toggleTorch();
      state = state.copyWith(isTorchOn: !state.isTorchOn);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to toggle torch: $e');
    }
  }

  Future<void> setTorch(bool enabled) async {
    if (state.isTorchOn == enabled) return;

    try {
      if (enabled) {
        await _controller?.toggleTorch();
      } else {
        await _controller?.toggleTorch();
      }

      state = state.copyWith(isTorchOn: enabled);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to set torch: $e');
    }
  }

  // Camera control
  Future<void> switchCamera() async {
    try {
      final newFacing =
          state.cameraFacing == CameraFacing.back
              ? CameraFacing.front
              : CameraFacing.back;

      await _controller?.switchCamera();

      state = state.copyWith(cameraFacing: newFacing);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to switch camera: $e');
    }
  }

  Future<void> setZoom(double zoom) async {
    try {
      await _controller?.setZoomScale(zoom);
      state = state.copyWith(zoomFactor: zoom);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to set zoom: $e');
    }
  }

  // Scan handling
  void handleBarcodeDetection(BarcodeCapture capture) {
    if (capture.barcodes.isEmpty) return;

    final scanResult = QRScanResult.fromCapture(capture);

    // Check for duplicates
    final isDuplicate = state.scanHistory.any(
      (scan) => scan.rawData == scanResult.rawData,
    );

    // Update scan history
    final updatedHistory = List<QRScanResult>.from(state.scanHistory);
    updatedHistory.insert(0, scanResult); // Add to beginning

    // Keep only last 100 scans
    if (updatedHistory.length > 100) {
      updatedHistory.removeLast();
    }

    // Update statistics
    final newTotalScans = state.totalScans + 1;
    final newUniqueScans =
        isDuplicate ? state.uniqueScans : state.uniqueScans + 1;

    state = state.copyWith(
      lastScanResult: scanResult,
      scanHistory: updatedHistory,
      totalScans: newTotalScans,
      uniqueScans: newUniqueScans,
    );

    // Auto-pause if scan once is enabled
    if (state.scanOnce) {
      pauseScanner();
    }
  }

  // Settings
  void setAutoScan(bool enabled) {
    state = state.copyWith(autoScan: enabled);
  }

  void setScanOnce(bool enabled) {
    state = state.copyWith(scanOnce: enabled);
  }

  // History management
  void clearHistory() {
    state = state.copyWith(
      scanHistory: [],
      lastScanResult: null,
      totalScans: 0,
      uniqueScans: 0,
    );
  }

  void removeScanFromHistory(QRScanResult scan) {
    final updatedHistory = List<QRScanResult>.from(state.scanHistory);
    updatedHistory.removeWhere(
      (s) => s.rawData == scan.rawData && s.timestamp == scan.timestamp,
    );

    // Update unique count
    final remainingUniqueCount =
        updatedHistory.map((s) => s.rawData).toSet().length;

    state = state.copyWith(
      scanHistory: updatedHistory,
      uniqueScans: remainingUniqueCount,
    );
  }

  void addManualScan(String data) {
    final scanResult = QRScanResult(
      rawData: data,
      codeType: QRCodeType.unknown,
      contentType: QRContentType.fromData(data),
      format: BarcodeFormat.unknown,
      timestamp: DateTime.now(),
    );

    final updatedHistory = List<QRScanResult>.from(state.scanHistory);
    updatedHistory.insert(0, scanResult);

    final isDuplicate = state.scanHistory.any((scan) => scan.rawData == data);

    state = state.copyWith(
      lastScanResult: scanResult,
      scanHistory: updatedHistory,
      totalScans: state.totalScans + 1,
      uniqueScans: isDuplicate ? state.uniqueScans : state.uniqueScans + 1,
    );
  }

  // Session management
  void resetSession() {
    stopScanner();

    state = QRScannerData(
      hasPermission: state.hasPermission,
      isInitialized: state.isInitialized,
      autoScan: state.autoScan,
      scanOnce: state.scanOnce,
      cameraFacing: state.cameraFacing,
      sessionStartTime: DateTime.now(),
    );
  }

  // Private methods
  void _updateSessionDuration() {
    final duration = DateTime.now().difference(state.sessionStartTime);
    state = state.copyWith(sessionDuration: duration);
  }

  // Quick actions for testing
  void simulateScan(String data) {
    addManualScan(data);
  }

  void generateTestScans() {
    final testData = [
      'https://flutter.dev',
      'mailto:test@example.com',
      'tel:+1234567890',
      'WIFI:T:WPA;S:MyNetwork;P:password123;H:false;',
      'BEGIN:VCARD\nFN:John Doe\nTEL:123-456-7890\nEMAIL:john@example.com\nEND:VCARD',
      'geo:37.7749,-122.4194',
      '1234567890123', // Product barcode
      'Just some plain text content',
    ];

    for (int i = 0; i < testData.length; i++) {
      Timer(Duration(milliseconds: i * 500), () {
        if (mounted) {
          simulateScan(testData[i]);
        }
      });
    }
  }

  // Controller access for UI
  MobileScannerController? get controller => _controller;

  // Capabilities check
  Future<bool> checkCameraPermission() async {
    try {
      await _controller?.start();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> refreshCapabilities() async {
    try {
      // Note: Mobile scanner doesn't have a direct way to check flash capability
      // We'll assume flash is available for back camera
      final hasFlash = state.cameraFacing == CameraFacing.back;

      state = state.copyWith(hasFlash: hasFlash, errorMessage: null);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to check capabilities: $e');
    }
  }
}
