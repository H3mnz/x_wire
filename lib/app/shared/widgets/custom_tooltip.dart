// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

typedef PositionBuilder = double Function(Size size);

class CustomTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final Color? color;

  final MouseCursor cursor;
  const CustomTooltip({
    super.key,
    required this.child,
    required this.message,
    this.color,
    this.cursor = MouseCursor.defer,
  });

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final OverlayPortalController _tooltipController = OverlayPortalController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: key,
      cursor: widget.cursor,
      child: OverlayPortal(
        controller: _tooltipController,
        child: widget.child,
        overlayChildBuilder: (context) {
          return Align(
            alignment: Alignment.center,
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final curvedAnimation = CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.fastOutSlowIn,
                    reverseCurve: Curves.fastOutSlowIn,
                  );
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0),
                      end: Offset.zero,
                    ).animate(curvedAnimation),
                    child: ScaleTransition(
                      alignment: Alignment.center,
                      scale: Tween<double>(begin: 0.7, end: 1).animate(curvedAnimation),
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
                        child: Card.filled(
                          elevation: 0,
                          margin: const EdgeInsets.all(0),
                          color: widget.color ?? Theme.of(context).colorScheme.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: Text(widget.message),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      onEnter: (event) {
        if (_tooltipController.isShowing) return;
        _tooltipController.show();
        _animationController.forward();
      },
      onExit: (event) {
        _animationController.reverse().then(
              (value) => _tooltipController.hide(),
            );
      },
    );
  }
}

class _TooltipPositionDelegate extends SingleChildLayoutDelegate {
  /// Creates a delegate for computing the layout of a tooltip.
  _TooltipPositionDelegate({
    required this.target,
    required this.verticalOffset,
    required this.margin,
    required this.preferBelow,
  });

  /// The offset of the target the tooltip is positioned near in the global
  /// coordinate system.
  final Offset target;

  /// The amount of vertical distance between the target and the displayed
  /// tooltip.
  final double verticalOffset;
  final double margin;

  /// Whether the tooltip is displayed below its widget by default.
  ///
  /// If there is insufficient space to display the tooltip in the preferred
  /// direction, the tooltip will be displayed in the opposite direction.
  final bool preferBelow;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) => constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return positionDependentBox(
      size: size,
      childSize: childSize,
      target: target,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
      margin: margin,
    );
  }

  @override
  bool shouldRelayout(_TooltipPositionDelegate oldDelegate) {
    return target != oldDelegate.target || verticalOffset != oldDelegate.verticalOffset || preferBelow != oldDelegate.preferBelow;
  }
}
