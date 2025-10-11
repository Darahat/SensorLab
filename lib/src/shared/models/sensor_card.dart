import 'package:flutter/material.dart'; // Add this import

class SensorCard {
  final IconData icon;
  final String label;
  final Color color;
  final Widget screen;
  final String category;

  SensorCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.screen,
    required this.category,
  });
}
