import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

extension ToastificationExt on Toastification {
  ToastificationItem showSimple({required Widget title, Color? color}) {
    dismissAll();
    return show(
      animationDuration: const Duration(milliseconds: 300),
      autoCloseDuration: const Duration(milliseconds: 2500),
      title: title,
      dragToClose: false,
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.only(bottom: 100),
      style: ToastificationStyle.simple,
      padding: const EdgeInsets.all(8),
      backgroundColor: color ?? Colors.grey.shade900,
      boxShadow: const [
        BoxShadow(
          blurRadius: 20,
          color: Colors.black54,
          offset: Offset(0, 1),
        ),
      ],
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(color: Colors.white12, width: 1.5),
      animationBuilder: (context, animation, alignment, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn,
        );
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  ToastificationItem showLoadingOverlay() {
    dismissAll();
    return showCustom(
      alignment: Alignment.center,
      animationDuration: const Duration(milliseconds: 200),
      builder: (context, holder) => Center(
        child: Card.filled(
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
      animationBuilder: (context, animation, alignment, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn,
        );
        return SizedBox.fromSize(
          size: MediaQuery.sizeOf(context),
          child: AnimatedBuilder(
            animation: curvedAnimation,
            child: child,
            builder: (context, ch) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: FadeTransition(
                      opacity: curvedAnimation,
                      child: const ColoredBox(
                        color: Colors.black87,
                        child: SizedBox.expand(),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.5, end: 1).animate(curvedAnimation),
                          child: ch,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
