// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../shared/theme/colors.dart';
import '../../../shared/widgets/custom_tooltip.dart';

class ConfigTile extends StatefulWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onCopy;
  final VoidCallback onDetails;
  const ConfigTile({super.key, required this.title, required this.selected, required this.onTap, required this.onDelete, required this.onCopy, required this.onDetails});

  @override
  State<ConfigTile> createState() => _ConfigTileState();
}

class _ConfigTileState extends State<ConfigTile> with TickerProviderStateMixin {
  bool isExpanded = false;

  final key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: widget.selected ? 1 : 0),
      duration: const Duration(milliseconds: 250),
      builder: (context, t, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.black54,
              width: 1.5,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          child: Material(
            elevation: 2 * t,
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: ListTile(
              selectedColor: Colors.white,
              horizontalTitleGap: 12,
              selected: widget.selected,
              // selectedTileColor: AppColors.color1,
              contentPadding: const EdgeInsets.all(8),
              minLeadingWidth: 12,
              leading: Transform.scale(
                scale: t,
                child: Icon(
                  HugeIcons.strokeRoundedCheckmarkCircle01,
                  size: 20,
                  color: Color.lerp(Colors.white12, AppColors.color1, t),
                ),
              ),

              trailing: IconButton(
                key: key,
                onPressed: () {
                  final box = key.currentContext?.findRenderObject() as RenderBox?;
                  if (box == null) return;
                  final offset = box.localToGlobal(Offset.zero);
                  final reverse = offset.dy >= MediaQuery.sizeOf(context).height / 2;
                  final bottom = MediaQuery.sizeOf(context).height - offset.dy;
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: 'popupMenu',
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return TooltipTheme(
                        data: TooltipThemeData(
                          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                              ),
                          margin: const EdgeInsets.only(
                            right: 56,
                          ),
                          verticalOffset: 1,
                          // verticalOffset: 0,
                          padding: const EdgeInsets.all(0),
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
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: offset.dx - 16,
                              top: reverse ? null : offset.dy - 16,
                              bottom: reverse ? bottom - box.size.height - 16 : null,
                              child: ScaleTransition(
                                alignment: reverse ? Alignment.bottomCenter : Alignment.topCenter,
                                scale: Tween<double>(begin: 0.8, end: 1).animate(animation),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: Card(
                                    elevation: 12,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    clipBehavior: Clip.antiAlias,
                                    margin: const EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      side: const BorderSide(
                                        color: Colors.black54,
                                        width: 1.5,
                                        strokeAlign: BorderSide.strokeAlignInside,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        verticalDirection: reverse ? VerticalDirection.up : VerticalDirection.down,
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton.filled(
                                            onPressed: () => Navigator.pop(context),
                                            icon: const Icon(HugeIcons.strokeRoundedArrowUp01),
                                            style: IconButton.styleFrom(
                                              backgroundColor: AppColors.red,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(24),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          CustomTooltip(
                                            message: 'Delete config',
                                            color: Theme.of(context).scaffoldBackgroundColor,
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                widget.onDelete.call();
                                              },
                                              icon: const Icon(HugeIcons.strokeRoundedDelete04),
                                              style: IconButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(24),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          CustomTooltip(
                                            color: Theme.of(context).scaffoldBackgroundColor,
                                            message: 'Copy config',
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                widget.onCopy.call();
                                              },
                                              icon: const Icon(HugeIcons.strokeRoundedCopy02),
                                              style: IconButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(24),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          CustomTooltip(
                                            color: Theme.of(context).scaffoldBackgroundColor,
                                            message: 'View config details',
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                widget.onDetails.call();
                                              },
                                              icon: const Icon(HugeIcons.strokeRoundedFileView),
                                              style: IconButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(24),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(HugeIcons.strokeRoundedArrowDown01),
              ),
              title: Text(widget.title),

              onTap: widget.onTap,
            ),
          ),
        );
      },
    );
  }
}
