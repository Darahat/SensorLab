import 'package:flutter/material.dart';
import 'package:sensorlab/src/features/app_settings/presentation/pages/settings_page.dart';

void showSettings(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6, // start height (60% of screen)
        minChildSize: 0.4, // can shrink to 40%
        maxChildSize: 0.95, // can expand to 95%
        expand: false, // do not force full height
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Make settings scrollable with the provided controller
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(24),
                      physics: const BouncingScrollPhysics(),
                      child: const SettingsPage(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
