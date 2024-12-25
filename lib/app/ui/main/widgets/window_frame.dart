import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '../../../shared/extension/toastification_ext.dart';
import '../../../shared/providers/wireguard_provider.dart';
import '../../../shared/utils/utils.dart';

class WindowFrameBuilder extends ConsumerStatefulWidget {
  final Widget? child;
  const WindowFrameBuilder({
    super.key,
    this.child,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WindowFrameBuilderState();
}

class _WindowFrameBuilderState extends ConsumerState<WindowFrameBuilder> with WindowListener, TrayListener {
  bool focused = true;
  @override
  void initState() {
    super.initState();
    trayManager.addListener(this);
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowFocus() {
    focused = true;
    setState(() {});
    super.onWindowFocus();
  }

  @override
  void onWindowBlur() {
    focused = false;
    setState(() {});
    super.onWindowBlur();
  }

  @override
  void onWindowClose() async {
    toastification.showLoadingOverlay();
    await Future.delayed(const Duration(seconds: 1));
    await ref.read(wireguardProvider).dispose();
    toastification.dismissAll();
    windowManager.destroy();
    super.onWindowClose();
  }

  @override
  void onTrayIconMouseDown() async {
    if (await windowManager.isVisible()) {
      windowManager.hide();
    } else {
      windowManager.show();
    }
    super.onTrayIconMouseDown();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
    super.onTrayIconRightMouseDown();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(0.9),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: focused ? 1 : 0),
        duration: const Duration(milliseconds: 100),
        builder: (context, t, child) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xff222126),
                boxShadow: [
                  BoxShadow(
                    blurRadius: Utils.lerpDouble(3, 9, t),
                    color: Colors.black,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.black,
                  width: Utils.lerpDouble(1, 1.5, t),
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              child: child,
            ),
          );
        },
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          // type: MaterialType.canvas,
          margin: const EdgeInsets.all(0),
          borderOnForeground: true,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
