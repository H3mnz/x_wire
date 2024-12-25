import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../shared/theme/colors.dart';
import '../providers/current_index_provider.dart';

class Navbar extends ConsumerWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    return ColoredBox(
      color: Colors.white.withOpacity(0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 2, color: Colors.white12),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ..._navItems.map(
                  (item) => TweenAnimationBuilder(
                    tween: Tween<double>(end: currentIndex == _navItems.indexOf(item) ? 1 : 0),
                    duration: const Duration(milliseconds: 200),
                    builder: (context, t, child) {
                      return IconButton(
                        onPressed: () {
                          ref.read(currentIndexProvider.notifier).update(
                                (state) => _navItems.indexOf(item),
                              );
                        },
                        icon: Icon(
                          item,
                          color: Color.lerp(Colors.white70, AppColors.color1, t),
                          shadows: [
                            BoxShadow(
                              color: Color.lerp(Colors.transparent, AppColors.color1, t) ?? Colors.transparent,
                              blurRadius: 6,
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                        ),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        style: IconButton.styleFrom(
                          elevation: 4 * t,
                          backgroundColor: Color.lerp(
                            Colors.transparent,
                            Theme.of(context).scaffoldBackgroundColor,
                            t,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              width: 1.5 * t,
                              color: Color.lerp(Colors.transparent, Colors.black54, t) ?? Colors.transparent,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<IconData> _navItems = [
  HugeIcons.strokeRoundedHome01,
  HugeIcons.strokeRoundedGlobal,
  HugeIcons.strokeRoundedSettings03,
];
