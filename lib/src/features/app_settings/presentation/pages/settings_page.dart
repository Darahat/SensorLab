import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sensorlab/l10n/app_localizations.dart';
import 'package:sensorlab/src/features/app_settings/provider/settings_provider.dart';

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
      data: (settings) {
        // WRAP your UI in a Builder widget
        return Builder(
          builder: (BuildContext context) {
            // Get l10n using the NEW, fresh context from the Builder
            final l10n = AppLocalizations.of(context)!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Appearance Section
                  SettingsSection(
                    title: l10n.appearance,
                    icon: Iconsax.eye,
                    children: [
                      SettingsItem(
                        icon: Iconsax.moon,
                        title: l10n.darkMode,
                        subtitle: l10n.switchBetweenLightAndDarkThemes,
                        trailing: DropdownButton<ThemeMode>(
                          value: settings.themeModeEnum,
                          underline: const SizedBox(),
                          items: [
                            DropdownMenuItem(
                              value: ThemeMode.system,
                              child: Text(l10n.system),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.light,
                              child: Text(l10n.light),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.dark,
                              child: Text(l10n.dark),
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
                      SettingsItem(
                        icon: Iconsax.translate,
                        title: l10n.language,
                        subtitle: l10n.languageSubtitle,
                        trailing: DropdownButton<String>(
                          value: settings.languageCode,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(
                              value: 'en',
                              child: Text('English'),
                            ),
                            DropdownMenuItem(
                              value: 'es',
                              child: Text('Español'),
                            ),
                            DropdownMenuItem(value: 'ja', child: Text('日本語')),
                            DropdownMenuItem(value: 'km', child: Text('ខ្មែរ')),
                          ],
                          onChanged: (languageCode) {
                            if (languageCode != null) {
                              ref
                                  .read(settingsControllerProvider.notifier)
                                  .updateLanguage(languageCode);
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Notifications Section
                  SettingsSection(
                    title: l10n.notificationsAndFeedback,
                    icon: Iconsax.notification,
                    children: [
                      SettingsItem(
                        icon: Iconsax.notification,
                        title: l10n.notifications,
                        subtitle: l10n.receiveAppNotifications,
                        trailing: Switch(
                          value: settings.notificationsEnabled,
                          onChanged: (_) => ref
                              .read(settingsControllerProvider.notifier)
                              .toggleNotifications(),
                        ),
                      ),
                      SettingsItem(
                        icon: Iconsax.mobile_programming,
                        title: l10n.vibration,
                        subtitle: l10n.hapticFeedbackForInteractions,
                        trailing: Switch(
                          value: settings.vibrationEnabled,
                          onChanged: (_) => ref
                              .read(settingsControllerProvider.notifier)
                              .toggleVibration(),
                        ),
                      ),
                      SettingsItem(
                        icon: Iconsax.volume_high,
                        title: l10n.soundEffects,
                        subtitle: l10n.audioFeedbackForAppActions,
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
                    title: l10n.sensorSettings,
                    icon: Iconsax.cpu,
                    children: [
                      SettingsItem(
                        icon: Iconsax.scan,
                        title: l10n.autoScan,
                        subtitle: l10n.automaticallyScanWhenOpeningScanner,
                        trailing: Switch(
                          value: settings.autoScanEnabled,
                          onChanged: (_) => ref
                              .read(settingsControllerProvider.notifier)
                              .toggleAutoScan(),
                        ),
                      ),
                      SettingsItem(
                        icon: Iconsax.speedometer,
                        title: l10n.sensorUpdateFrequency,
                        subtitle: l10n.sensorUpdateFrequencySubtitle(
                          settings.sensorUpdateFrequency,
                        ),
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
                    title: l10n.privacyAndData,
                    icon: Iconsax.shield_security,
                    children: [
                      SettingsItem(
                        icon: Iconsax.data,
                        title: l10n.dataCollection,
                        subtitle: l10n.allowAnonymousUsageAnalytics,
                        trailing: Switch(
                          value: settings.dataCollectionEnabled,
                          onChanged: (_) => ref
                              .read(settingsControllerProvider.notifier)
                              .toggleDataCollection(),
                        ),
                      ),
                      SettingsItem(
                        icon: Iconsax.shield_tick,
                        title: l10n.privacyMode,
                        subtitle: l10n.enhancedPrivacyProtection,
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
                    title: l10n.appSupport,
                    icon: Iconsax.heart,
                    children: [
                      SettingsItem(
                        icon: Iconsax.mobile,
                        title: l10n.showAds,
                        subtitle: l10n.supportAppDevelopment,
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
                                l10n.resetSettings,
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
                            l10n.resetAllSettingsToDefaultValues,
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
                              label: Text(l10n.resetToDefaults),
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
            );
          },
        );
      },
    );
  }

  void _showFrequencyDialog(
    BuildContext context,
    WidgetRef ref,
    int currentFrequency,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sensorUpdateFrequency),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.chooseSensorUpdateFrequency),
            const SizedBox(height: 16),
            ...[
              l10n.fastUpdate,
              l10n.normalUpdate,
              l10n.slowUpdate,
              l10n.verySlowUpdate,
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
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetSettings),
        content: Text(
          '${l10n.areYouSureResetSettings} ${l10n.thisActionCannotBeUndone}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              ref.read(settingsControllerProvider.notifier).resetToDefaults();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${l10n.settings} ${l10n.reset.toLowerCase()}'),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.reset),
          ),
        ],
      ),
    );
  }
}
