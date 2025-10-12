import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'barcode_scanner_screen.dart';
import 'qr_scanner_screen.dart';

class ScannerMainScreen extends StatelessWidget {
  const ScannerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Choose Scanner Type',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Select the type of code you want to scan',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // QR Code Scanner Card
              _ScannerCard(
                title: 'QR Code Scanner',
                subtitle: 'Scan QR codes, Data Matrix, PDF417, and Aztec codes',
                icon: Iconsax.scan,
                iconColor: colorScheme.primary,
                gradientColors: [
                  colorScheme.primary.withOpacity(0.1),
                  colorScheme.primary.withOpacity(0.05),
                ],
                examples: const [
                  'Website URLs',
                  'WiFi passwords',
                  'Contact information',
                  'Location coordinates',
                  'Calendar events',
                ],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QRScannerScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Barcode Scanner Card
              _ScannerCard(
                title: 'Barcode Scanner',
                subtitle:
                    'Scan product barcodes like UPC, EAN, Code 128, and more',
                icon: Iconsax.barcode,
                iconColor: colorScheme.secondary,
                gradientColors: [
                  colorScheme.secondary.withOpacity(0.1),
                  colorScheme.secondary.withOpacity(0.05),
                ],
                examples: const [
                  'Product barcodes',
                  'ISBN numbers',
                  'UPC codes',
                  'EAN codes',
                  'Code 128/39',
                ],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarcodeScannerScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Help section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Iconsax.info_circle,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scanning Tips',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hold your device steady and ensure the code is well-lit and clearly visible within the scanner frame.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScannerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final List<Color> gradientColors;
  final List<String> examples;
  final VoidCallback onTap;

  const _ScannerCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.gradientColors,
    required this.examples,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Iconsax.arrow_right_3,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Common uses:',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: examples.map((example) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: iconColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      example,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: iconColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
