import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Reusable status indicator card with animated dot
class StatusCard extends StatelessWidget {
  final bool isActive;
  final String title;
  final String subtitle;
  final Color? activeColor;
  final Color? inactiveColor;

  const StatusCard({
    super.key,
    required this.isActive,
    required this.title,
    required this.subtitle,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive
        ? (activeColor ?? Colors.green)
        : (inactiveColor ?? Colors.grey);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Animated indicator dot
            _AnimatedIndicatorDot(color: color, isActive: isActive),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedIndicatorDot extends StatelessWidget {
  final Color color;
  final bool isActive;

  const _AnimatedIndicatorDot({required this.color, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
    );
  }
}
