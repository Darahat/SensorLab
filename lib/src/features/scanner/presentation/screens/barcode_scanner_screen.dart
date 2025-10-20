import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

import '../../../heart_beat/presentation/providers/heart_beat_provider.dart';
import '../../models/scan_result.dart';
import '../widgets/scanner_overlay.dart';
import 'scan_result_screen.dart';

class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  ConsumerState<BarcodeScannerScreen> createState() =>
      _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen> {
  late final MobileScannerController _controller;
  bool _isTorchOn = false;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      formats: [
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
        BarcodeFormat.upcA,
        BarcodeFormat.upcE,
        BarcodeFormat.code128,
        BarcodeFormat.code39,
        BarcodeFormat.code93,
        BarcodeFormat.codabar,
        BarcodeFormat.itf,
      ],
      detectionTimeoutMs: 1000, // Limit detection frequency
    );

    // Pause heart rate monitoring when scanner is active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(heartBeatProvider.notifier).pauseMonitoring();
    });
  }

  @override
  void dispose() {
    // Resume heart rate monitoring when leaving scanner
    ref.read(heartBeatProvider.notifier).resumeMonitoring();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.barcodeScanner),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: Icon(_isTorchOn ? Iconsax.flash_slash : Iconsax.flash_1),
                onPressed: () {
                  _controller.toggleTorch();
                  setState(() => _isTorchOn = !_isTorchOn);
                },
              ),
              IconButton(
                icon: Icon(_isScanning ? Iconsax.pause : Iconsax.play),
                onPressed: () {
                  if (_isScanning) {
                    _controller.stop();
                  } else {
                    _controller.start();
                  }
                  setState(() => _isScanning = !_isScanning);
                },
              ),
            ],
          ),
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Camera preview
              MobileScanner(
                controller: _controller,
                onDetect: _onBarcodeDetected,
              ),

              Align(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                  child: ScannerOverlay(
                    title: l10n.scanBarcode,
                    subtitle: l10n.positionBarcodeInFrame,
                    scanType: ScanType.barcode,
                  ),
                ),
              ),
              // Bottom instruction panel
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.barcode,
                        color: colorScheme.secondary,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.barcodeScanner,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.scanningForBarcodes,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    if (barcode.rawValue == null || barcode.rawValue!.isEmpty) return;

    // Filter only barcode-type codes
    final allowedFormats = [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.code93,
      BarcodeFormat.codabar,
      BarcodeFormat.itf,
    ];

    if (!allowedFormats.contains(barcode.format)) return;

    // Stop scanning and navigate to result
    _controller.stop();

    final result = ScanResult.fromBarcode(barcode);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ScanResultScreen(result: result)),
    );
  }
}
