import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/src/features/app_settings/provider/settings_provider.dart';
import 'package:sensorlab/src/l10n/app_localizations.dart';

import '../widgets/settings_item.dart';
import '../widgets/settings_section.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return settingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.info_circle, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              l10n.failedToLoadSettings,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Iconsax.refresh),
              label: Text(l10n.retry),
              onPressed: () => ref.invalidate(settingsControllerProvider),
            ),
          ],
        ),
      ),
      data: (settings) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            SettingsSection(
              title: 'Appearance',
              icon: Iconsax.eye,
              children: [
                SettingsItem(
                  icon: Iconsax.moon,
                  title: 'Dark Mode',
                  subtitle: 'Switch between light and dark themes',
                  trailing: DropdownButton<ThemeMode>(
                    value: settings.themeModeEnum,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                    ],
                    onChanged: (mode) {
                      if (mode != null) {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .updateThemeMode(mode);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Notifications Section
            SettingsSection(
              title: 'Notifications & Feedback',
              icon: Iconsax.notification,
              children: [
                SettingsItem(
                  icon: Iconsax.notification,
                  title: 'Notifications',
                  subtitle: 'Receive app notifications',
                  trailing: Switch(
                    value: settings.notificationsEnabled,
                    onChanged: (_) => ref
                        .read(settingsControllerProvider.notifier)
                        .toggleNotifications(),
                  ),
                ),
                SettingsItem(
                  icon: Iconsax.mobile_programming,
                  title: 'Vibration',
                  subtitle: 'Haptic feedback for interactions',
                  trailing: Switch(
                    value: settings.vibrationEnabled,
                    onChanged: (_) => ref
                        .read(settingsControllerProvider.notifier)
                        .toggleVibration(),
                  ),
                ),
                SettingsItem(
                  icon: Iconsax.volume_high,
                  title: 'Sound Effects',
                  subtitle: 'Audio feedback for app actions',
                  trailing: Switch(
                    value: settings.soundEnabled,
                    onChanged: (_) => ref
                        .read(settingsControllerProvider.notifier)
                        .toggleSound(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Sensor Settings Section
            SettingsSection(
              title: 'Sensor Settings',
              icon: Iconsax.cpu,
              children: [
                SettingsItem(
                  icon: Iconsax.scan,
                  title: 'Auto Scan',
                  subtitle: 'Automatically scan when opening scanner',
                  trailing: Switch(
                    value: settings.autoScanEnabled,
                    onChanged: (_) => ref
                        .read(settingsControllerProvider.notifier)
                        .toggleAutoScan(),
                  ),
                ),
                SettingsItem(
                  icon: Iconsax.speedometer,
                  title: 'Sensor Update Frequency',
                  subtitle: '${settings.sensorUpdateFrequency}ms intervals',
                  onTap: () => _showFrequencyDialog(
                    context,
                    ref,
                    settings.sensorUpdateFrequency,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Privacy & Data Section
            SettingsSection(
              title: 'Privacy & Data',
              icon: Iconsax.shield_security,
              children: [
                SettingsItem(
                  icon: Iconsax.data,
                  title: 'Data Collection',
                  subtitle: 'Allow anonymous usage analytics',
                  trailing: Switch(
                    value: settings.dataCollectionEnabled,
                    onChanged: (_) => ref
                        .read(settingsControllerProvider.notifier)
                        .toggleDataCollection(),
                  ),
                ),
                SettingsItem(
                  icon: Iconsax.shield_tick,
                  title: 'Privacy Mode',
                  subtitle: 'Enhanced privacy protection',
                  trailing: Switch(
                    value: settings.privacyMode,
                    onChanged: (_) => ref
                        .read(settingsControllerProvider.notifier)
                        .togglePrivacyMode(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Monetization Section
            SettingsSection(
              title: 'App Support',
              icon: Iconsax.heart,
              children: [
                SettingsItem(
                  icon: Iconsax.mobile,
                  title: 'Show Ads',
                  subtitle: 'Support app development',
                  trailing: Switch(
                    value: settings.adsEnabled,
                    onChanged: (_) => ref
                        .read(settingsControllerProvider.notifier)
                        .toggleAds(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Reset Section
            Card(
              color: colorScheme.errorContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.refresh_square_2,
                          color: colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Reset Settings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Reset all settings to their default values. This action cannot be undone.',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Iconsax.refresh_square_2),
                        label: const Text('Reset to Defaults'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.error,
                          side: BorderSide(color: colorScheme.error),
                        ),
                        onPressed: () => _showResetDialog(context, ref),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFrequencyDialog(
    BuildContext context,
    WidgetRef ref,
    int currentFrequency,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sensor Update Frequency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose how often sensors should update:'),
            const SizedBox(height: 16),
            ...[
              '50ms (Fast)',
              '100ms (Normal)',
              '200ms (Slow)',
              '500ms (Very Slow)',
            ].asMap().entries.map((entry) {
              final frequencies = [50, 100, 200, 500];
              final frequency = frequencies[entry.key];
              return RadioListTile<int>(
                title: Text(entry.value),
                value: frequency,
                groupValue: currentFrequency,
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(settingsControllerProvider.notifier)
                        .updateSensorFrequency(value);
                    Navigator.pop(context);
                  }
                },
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(settingsControllerProvider.notifier).resetToDefaults();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
