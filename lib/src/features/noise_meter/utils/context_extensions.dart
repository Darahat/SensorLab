import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // MediaQuery shortcuts
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  // Navigation shortcuts
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  Future<T?> push<T>(Route<T> route) => Navigator.of(this).push(route);
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamed(routeName, arguments: arguments);

  // Show dialog shortcuts
  Future<T?> showAlertDialog<T>({
    required String title,
    required String content,
    List<Widget>? actions,
  }) {
    return showDialog<T>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions:
            actions ?? [TextButton(onPressed: pop, child: const Text('OK'))],
      ),
    );
  }
}

extension DoubleExtensions on double {
  String toDecibelString() => '${toStringAsFixed(1)} dB';

  bool isWithinRange(double min, double max) => this >= min && this <= max;
}

extension DurationExtensions on Duration {
  String toMinutesSeconds() {
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String toReadableString() {
    if (inHours > 0) {
      return '${inHours}h ${inMinutes.remainder(60)}m';
    } else if (inMinutes > 0) {
      return '${inMinutes}m ${inSeconds.remainder(60)}s';
    } else {
      return '${inSeconds}s';
    }
  }
}
