import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:window_manager/window_manager.dart';

import '../../../shared/utils/utils.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return TooltipTheme(
      data: TooltipThemeData(
        textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white,
            ),
        enableFeedback: false,
        margin: const EdgeInsets.all(0),
        // verticalOffset: 0,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          boxShadow: const [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black54,
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white12, width: 1.5),
        ),
      ),
      child: SizedBox(
        height: 40,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white10),
            ),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (details) => windowManager.startDragging(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(child: Text('${Utils.appLabel} - WireGuard Client')),
                  IconButton(
                    onPressed: windowManager.hide,
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(HugeIcons.strokeRoundedMinusSign, size: 14),
                    style: IconButton.styleFrom(
                      minimumSize: const Size.square(20),
                    ),
                    tooltip: 'Minimize to Tray',
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: windowManager.close,
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(HugeIcons.strokeRoundedCancel01, size: 14),
                    style: IconButton.styleFrom(
                      minimumSize: const Size.square(20),
                      highlightColor: Colors.red,
                      hoverColor: Colors.redAccent,
                    ),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
