import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../l10n/app_localizations.dart';
import '../pages/settings_page.dart';

void showSettings(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    showDragHandle: false,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        final l10n = AppLocalizations.of(context)!;
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.setting_2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.quickSettings,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      icon: const Icon(Iconsax.setting_4, size: 16),
                      label: Text(l10n.more),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Quick Settings Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: const _QuickSettingsContent(),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class _QuickSettingsContent extends StatelessWidget {
  const _QuickSettingsContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Theme toggle
        Card(
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Iconsax.sun_1
                    : Iconsax.moon,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            title: Text(l10n.theme),
            subtitle: Text(
              Theme.of(context).brightness == Brightness.dark
                  ? l10n.darkModeActive
                  : l10n.lightModeActive,
            ),
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                // Note: This would require theme management implementation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.themeChangeRequiresRestart),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Notifications toggle
        Card(
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Iconsax.notification,
                color: colorScheme.secondary,
                size: 20,
              ),
            ),
            title: Text(l10n.notifications),
            subtitle: Text(l10n.getNotifiedAboutSensorReadings),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // Quick toggle implementation
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Vibration toggle
        Card(
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Iconsax.mobile_programming,
                color: Colors.green,
                size: 20,
              ),
            ),
            title: Text(l10n.vibration),
            subtitle: Text(l10n.hapticFeedbackForInteractions),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // Quick toggle implementation
              },
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Quick actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Iconsax.info_circle),
                label: Text(l10n.about),
                onPressed: () {
                  // Show about dialog
                  showAboutDialog(
                    context: context,
                    applicationName: 'SensorLab',
                    applicationVersion: '1.1.1',
                    applicationIcon: const Icon(Iconsax.cpu, size: 48),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                icon: const Icon(Iconsax.setting_4),
                label: Text(l10n.allSettings),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
