// bottom_nav.dart
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        // BottomNavigationBarItem(icon: Icon(Icons.sensors), label: 'Sensors'),
      ],
    );
  }
}
