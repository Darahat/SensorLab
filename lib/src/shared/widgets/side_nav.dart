// side_nav.dart
import 'package:flutter/material.dart';
import 'package:sensorlab/l10n/app_localizations.dart';

class SideNav extends StatelessWidget {
  const SideNav({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Text(
              l10n.menu,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(leading: const Icon(Icons.home), title: Text(l10n.home)),
        ],
      ),
    );
  }
}