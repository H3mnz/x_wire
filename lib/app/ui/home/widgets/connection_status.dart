import 'package:flutter/material.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({
    super.key,
    required this.stage,
  });

  final VpnStage stage;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            color: Colors.black54,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black54, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: AnimatedSwitcher(
          switchInCurve: Curves.fastOutSlowIn,
          switchOutCurve: Curves.fastOutSlowIn,
          reverseDuration: const Duration(milliseconds: 1000),
          duration: const Duration(milliseconds: 1000),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              alignment: Alignment.bottomCenter,
              scale: Tween<double>(begin: 0.5, end: 1).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: switch (stage) {
                    VpnStage.connected => Colors.green,
                    VpnStage.disconnected => Colors.red,
                    _ => Colors.white,
                  },
                ),
            child: Text(
              stage.name.toUpperCase(),
              key: ValueKey(stage.name),
            ),
          ),
        ),
      ),
    );
  }
}
