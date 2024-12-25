import 'package:tray_manager/tray_manager.dart';

import '../utils/utils.dart';

class TrayService {
  TrayService._();
  static Future<void> init() async {
    final Menu menu = Menu(
      items: [],
    );
    await Future.wait([
      trayManager.setIcon('images/app_icon.ico'),
      trayManager.setToolTip(Utils.appLabel),
      trayManager.setContextMenu(menu),
    ]);
  }
}
