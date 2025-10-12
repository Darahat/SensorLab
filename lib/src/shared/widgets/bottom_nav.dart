// bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: l10n.home),
        // BottomNavigationBarItem(icon: Icon(Icons.sensors), label: 'Sensors'),
      ],
    );
  }
}