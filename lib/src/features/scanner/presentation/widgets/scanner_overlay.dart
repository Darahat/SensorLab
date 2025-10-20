import 'package:flutter/material.dart';

import '../../models/scan_result.dart';

class ScannerOverlay extends StatefulWidget {
  final String title;
  final String subtitle;
  final ScanType scanType;

  const ScannerOverlay({
    super.key,
    required this.title,
    required this.subtitle,
    required this.scanType,
  });

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark overlay
        Container(color: Colors.black.withOpacity(0.5)),

        // Scanner frame
        Center(child: _buildScannerFrame()),

        // Top instruction
        Positioned(
          top: MediaQuery.of(context).padding.top + 80,
          left: 24,
          right: 24,
          child: _buildInstructions(),
        ),
      ],
    );
  }

  Widget _buildScannerFrame() {
    final scannerSize = widget.scanType == ScanType.qrCode ? 280.0 : 320.0;
    final scannerHeight = widget.scanType == ScanType.qrCode ? 280.0 : 160.0;

    return Stack(
      children: [
        // Clear center area
        ClipPath(
          clipper: _ScannerFrameClipper(
            width: scannerSize,
            height: scannerHeight,
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.6),
          ),
        ),

        // Scanner frame border
        Container(
          width: scannerSize,
          height: scannerHeight,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Corner indicators
              ..._buildCornerIndicators(scannerSize, scannerHeight),

              // Animated scan line
              if (widget.scanType == ScanType.qrCode)
                _buildQRScanLine(scannerSize, scannerHeight)
              else
                _buildBarcodeScanLine(scannerSize, scannerHeight),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCornerIndicators(double width, double height) {
    const cornerSize = 24.0;
    const cornerThickness = 4.0;
    final cornerColor = widget.scanType == ScanType.qrCode
        ? Colors.green
        : Colors.orange;

    return [
      // Top-left
      Positioned(
        top: -2,
        left: -2,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: cornerColor, width: cornerThickness),
              left: BorderSide(color: cornerColor, width: cornerThickness),
            ),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(14)),
          ),
        ),
      ),

      // Top-right
      Positioned(
        top: -2,
        right: -2,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: cornerColor, width: cornerThickness),
              right: BorderSide(color: cornerColor, width: cornerThickness),
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(14),
            ),
          ),
        ),
      ),

      // Bottom-left
      Positioned(
        bottom: -2,
        left: -2,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: cornerColor, width: cornerThickness),
              left: BorderSide(color: cornerColor, width: cornerThickness),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(14),
            ),
          ),
        ),
      ),

      // Bottom-right
      Positioned(
        bottom: -2,
        right: -2,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: cornerColor, width: cornerThickness),
              right: BorderSide(color: cornerColor, width: cornerThickness),
            ),
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(14),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildQRScanLine(double width, double height) {
    return AnimatedBuilder(
      animation: _scanLineAnimation,
      builder: (context, child) {
        return Positioned(
          top: height * _scanLineAnimation.value - 1,
          left: 12,
          right: 12,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.green,
                  Colors.green,
                  Colors.transparent,
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBarcodeScanLine(double width, double height) {
    return AnimatedBuilder(
      animation: _scanLineAnimation,
      builder: (context, child) {
        return Positioned(
          top: height * _scanLineAnimation.value - 1,
          left: 12,
          right: 12,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.orange,
                  Colors.orange,
                  Colors.transparent,
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            widget.subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ScannerFrameClipper extends CustomClipper<Path> {
  final double width;
  final double height;

  _ScannerFrameClipper({required this.width, required this.height});

  @override
  Path getClip(Size size) {
    final path = Path();

    // Add the entire screen
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Subtract the scanner frame area
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final rect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: width,
      height: height,
    );

    path.addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)));
    path.fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
