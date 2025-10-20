import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Provider for the AppLogger instance.
final appLoggerProvider = Provider<AppLogger>((ref) {
  return AppLogger();
});

/// Represents the severity level of a log message.
enum LogLevel {
  ///For Debug
  debug,

  /// for info
  info,

  /// For warning
  warning,

  /// For Error message show
  error,
}

/// A simple utility for logging messages during development.
class AppLogger {
  late final Logger _logger;

  /// Constructor initializes the logger with the appropriate configuration.
  AppLogger() {
    _logger = Logger(
      printer: kDebugMode
          ? PrettyPrinter(dateTimeFormat: DateTimeFormat.dateAndTime)
          : SimplePrinter(),
      level: kDebugMode ? Level.debug : Level.info,
    );
  }

  /// Log debug message (only in debug mode).
  void debug(String message) {
    if (kDebugMode) {
      _logger.d(message);
      developer.log(message, name: 'Chat AI ');
    }
  }

  /// Log info messages.
  void info(String message) {
    if (kDebugMode) {
      _logger.i(message);
      developer.log(message, name: 'Chat AI ', level: 800);
    }
  }

  /// Log warning messages.
  void warning(String message) {
    if (kDebugMode) {
      _logger.w(message);
      developer.log(message, name: 'Chat AI ', level: 900);
    }
  }

  /// Log error messages with optional error object and stack trace.
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
      developer.log(
        message,
        name: 'Chat AI ',
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Represents the severity level of a log message.

  static void log(String message, {LogLevel level = LogLevel.info}) {
    if (kDebugMode) {
      final emoji = {
        // debug message if in debug mode
        LogLevel.debug: '🐛',

        /// Informational messages.
        LogLevel.info: 'ℹ️',

        /// Warning messages indicating potential issues.
        LogLevel.warning: '⚠️',

        /// Error messages indicating failure or critical issues.
        LogLevel.error: '❌',
      }[level];
      print('$emoji $message');
    }
  }
}

// AppLogger.debug('🚀 ~This is a debug message');
// AppLogger.info('🚀 ~This is an info message');
// AppLogger.warning('🚀 ~This is a warning message');
// AppLogger.error('🚀 ~This is an error message', Exception('Something went wrong'));
// AppLogger.log('🚀 ~This is a custom log message with info level', level: LogLevel.info);
// AppLogger.log('🚀 ~This is a custom log message with error level', level: LogLevel.error);
