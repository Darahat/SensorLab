import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

/// Large decibel display with animated color
class DecibelDisplay extends StatelessWidget {
  final double decibels;
  final String noiseLevel;
  final String unit;

  const DecibelDisplay({
    super.key,
    required this.decibels,
    required this.noiseLevel,
    required this.unit,
  });

  Color _getColor() {
    if (decibels < 30) {
      return Colors.blue;
    }
    if (decibels < 50) {
      return Colors.green;
    }
    if (decibels < 70) {
      return Colors.orange;
    }
    if (decibels < 85) {
      return Colors.deepOrange;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
        ),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.monitoringCurrentLevel,
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    decibels.toStringAsFixed(1),
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, left: 8),
                    child: Text(
                      unit,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              noiseLevel,
              style: theme.textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
