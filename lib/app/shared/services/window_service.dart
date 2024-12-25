import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../utils/utils.dart';

class WindowService {
  WindowService._();
  static Future<void> setupWindowManager() async {
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow(
      WindowOptions(
        size: Utils.windowSize,
        minimumSize: Utils.windowSize,
        titleBarStyle: TitleBarStyle.hidden,
        title: Utils.appLabel,
        backgroundColor: Colors.black.withOpacity(0),
      ),
      () async {
        await Future.wait([
          windowManager.setPreventClose(true),
          windowManager.setMaximizable(false),
          windowManager.setAsFrameless(),
          windowManager.setResizable(false),
          windowManager.show(),
        ]);
      },
    );
  }
}
