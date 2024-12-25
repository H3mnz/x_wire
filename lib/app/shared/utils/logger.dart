import 'package:flutter/foundation.dart';

enum LogLevel { error, warning, success, log }

class Logger {
  Logger._();

  static void log(Object object, [LogLevel level = LogLevel.log]) {
    if (kDebugMode) {
      return switch (level) {
        LogLevel.error => print('\x1B[31m$object\x1B[0m'),
        LogLevel.warning => print('\x1B[33m$object\x1B[0m'),
        LogLevel.success => print('\x1B[32m$object\x1B[0m'),
        LogLevel.log => print('\x1B[37m$object\x1B[0m'),
      };
    }
  }
}
