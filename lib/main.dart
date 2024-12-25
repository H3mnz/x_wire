import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

import 'app/shared/providers/wireguard_provider.dart';
import 'app/shared/services/storage_service.dart';
import 'app/shared/services/tray_service.dart';
import 'app/shared/services/window_service.dart';
import 'app/shared/theme/theme.dart';
import 'app/shared/utils/utils.dart';
import 'app/ui/main/pages/main_page.dart';
import 'app/ui/main/widgets/window_frame.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await TrayService.init();
    await StorageService.instance.init();
    final providerContainer = ProviderContainer();
    await providerContainer.read(wireguardProvider).initialize();
    await WindowService.setupWindowManager();
    runApp(
      UncontrolledProviderScope(
        container: providerContainer,
        child: const App(),
      ),
    );
  } catch (e) {
    exit(1);
  }
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      config: ToastificationConfig(
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        marginBuilder: (alignment) => const EdgeInsets.all(0),
      ),
      child: const CustomMaterialApp(),
    );
  }
}

class CustomMaterialApp extends MaterialApp {
  const CustomMaterialApp({super.key});

  @override
  String get title => Utils.appLabel;

  @override
  Widget? get home => const MainPage();

  @override
  ThemeData? get theme => AppTheme.themeData;

  @override
  bool get debugShowCheckedModeBanner => false;

  @override
  TransitionBuilder? get builder => (context, child) => WindowFrameBuilder(child: child);
}
