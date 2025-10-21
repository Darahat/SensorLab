import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

import '../../models/accelerometer_data.dart';
import '../providers/accelerometer_provider.dart';

class AccelerometerScreen extends ConsumerWidget {
  const AccelerometerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accelerometerData = ref.watch(accelerometerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = colorScheme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accelerometer),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          IconButton(
            icon: Icon(Iconsax.refresh, color: colorScheme.primary),
            onPressed: () =>
                ref.read(accelerometerProvider.notifier).resetMaxValues(),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 3D Visualization
                _build3DIndicator(colorScheme, accelerometerData),
                const SizedBox(height: 40),

                // Status Indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: accelerometerData.isActive
                        ? colorScheme.primary.withOpacity(0.1)
                        : colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: accelerometerData.isActive
                          ? colorScheme.primary
                          : colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    accelerometerData.isActive
                        ? l10n.active
                        : l10n.moveYourDevice,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accelerometerData.isActive
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Data Table
                _buildDataTable(colorScheme, accelerometerData, l10n),
                const SizedBox(height: 30),

                // Measurement Unit
                Text(
                  l10n.accelerationUnit,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _build3DIndicator(ColorScheme colorScheme, AccelerometerData data) {
    return SizedBox(
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surfaceVariant,
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(data.x * 5, -data.y * 5),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [colorScheme.primaryContainer, colorScheme.primary],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Icon(Iconsax.box, size: 30, color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(
    ColorScheme colorScheme,
    AccelerometerData data,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            children: [
              _buildTableHeader(l10n.axis, colorScheme),
              _buildTableHeader(l10n.current, colorScheme),
              _buildTableHeader(l10n.max, colorScheme),
            ],
          ),
          _buildTableRow(l10n.xAxis, data.x, data.maxX, colorScheme),
          _buildTableRow(l10n.yAxis, data.y, data.maxY, colorScheme),
          _buildTableRow(l10n.zAxis, data.z, data.maxZ, colorScheme),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  TableRow _buildTableRow(
    String axis,
    double value,
    double maxValue,
    ColorScheme colorScheme,
  ) {
    return TableRow(
      decoration: BoxDecoration(color: colorScheme.surface),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            axis,
            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.8)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            maxValue.toStringAsFixed(2),
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}
