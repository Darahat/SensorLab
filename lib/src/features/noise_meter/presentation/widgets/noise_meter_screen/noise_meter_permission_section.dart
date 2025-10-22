import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/noise_meter/application/notifiers/enhanced_noise_meter_notifier.dart';
import 'package:sensorlab/src/features/noise_meter/application/state/enhanced_noise_data.dart';

class NoiseMeterPermissionSection extends StatelessWidget {
  final EnhancedNoiseMeterData data;
  final EnhancedNoiseMeterNotifier notifier;
  final AppLocalizations l10n;

  const NoiseMeterPermissionSection({
    super.key,
    required this.data,
    required this.notifier,
    required this.l10n,
  });

  Future<void> _requestMicrophonePermission(BuildContext context) async {
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      // Permission granted - refresh the notifier state
      await notifier.refreshPermissionStatus();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.permissionGranted),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else if (status.isPermanentlyDenied) {
      // User permanently denied permission
      if (context.mounted) {
        _showPermissionDialog(context);
      }
    } else {
      // User denied permission
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.microphonePermissionDenied),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: l10n.retry,
              textColor: Colors.white,
              onPressed: () => _requestMicrophonePermission(context),
            ),
          ),
        );
      }
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.settings, size: 48, color: Colors.blue),
        title: Text(l10n.permissionRequired),
        content: Text(l10n.microphonePermissionPermanentlyDenied),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: Text(l10n.openSettings),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data.hasPermission) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Modern microphone illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mic_none_rounded,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              l10n.microphoneAccessNeeded,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              l10n.microphoneAccessDescription,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Features list
            _FeatureItem(
              icon: Icons.graphic_eq_rounded,
              title: l10n.measureNoiseLevels,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _FeatureItem(
              icon: Icons.analytics_rounded,
              title: l10n.analyzeAcoustics,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 12),
            _FeatureItem(
              icon: Icons.bar_chart_rounded,
              title: l10n.generateReports,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 40),

            // Primary action button
            FilledButton.icon(
              onPressed: () => _requestMicrophonePermission(context),
              icon: const Icon(Icons.mic),
              label: Text(l10n.allowMicrophoneAccess),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Privacy note
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l10n.audioNotRecorded,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final ColorScheme colorScheme;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: colorScheme.onPrimary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
