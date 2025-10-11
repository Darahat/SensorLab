import 'package:flutter/material.dart';

class TrackingButton extends StatelessWidget {
  final bool isTracking;
  final VoidCallback onPressed;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? size;

  const TrackingButton({
    super.key,
    required this.isTracking,
    required this.onPressed,
    this.activeColor,
    this.inactiveColor,
    this.size = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor:
          isTracking
              ? (activeColor ?? theme.colorScheme.error)
              : (inactiveColor ?? theme.primaryColor),
      elevation: 4.0,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder:
              (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
          child:
              isTracking
                  ? const Icon(Icons.stop, key: ValueKey('stop'))
                  : const Icon(Icons.play_arrow, key: ValueKey('play')),
        ),
      ),
    );
  }
}
