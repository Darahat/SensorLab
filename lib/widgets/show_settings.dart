import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'settings_item.dart';

void showSettings(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder:
        (context) => Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              SettingsItem(
                icon: Iconsax.moon,
                title: 'Dark Mode',
                trailing: Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {
                    // Implement theme switching logic
                  },
                ),
              ),
              SettingsItem(
                icon: Iconsax.notification,
                title: 'Notifications',
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
              SettingsItem(
                icon: Iconsax.activity,
                title: 'Ad Preferences',
                onTap: () {},
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Close Settings'),
              ),
            ],
          ),
        ),
  );
}
