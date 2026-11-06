import 'package:flutter/material.dart';

import '../../../core/theme/app_motion.dart';

/// An [IndexedStack] that slides the newly shown child in from the side of
/// the tab that was tapped: from the right when moving right along the bar,
/// from the left when moving back.
///
/// Every child stays mounted, as with a plain [IndexedStack], so each tab
/// keeps its scroll position and its own navigation stack. Only the arrival
/// moves, and it stays fully visible while it does.
class SlideIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const SlideIndexedStack({
    super.key,
    required this.index,
    required this.children,
  });

  /// How far the arriving tab starts from its place, as a share of its width.
  static const double _travel = 0.08;

  @override
  State<SlideIndexedStack> createState() => _SlideIndexedStackState();
}

class _SlideIndexedStackState extends State<SlideIndexedStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slide = AnimationController(
    vsync: this,
    duration: AppMotion.short,
    value: 1,
  );
  double _from = 0;

  @override
  void didUpdateWidget(SlideIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index == widget.index) return;
    _from = widget.index > oldWidget.index
        ? SlideIndexedStack._travel
        : -SlideIndexedStack._travel;
    _slide.duration = context.motion(AppMotion.short);
    _slide.forward(from: 0);
  }

  @override
  void dispose() {
    _slide.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _slide,
        child: IndexedStack(index: widget.index, children: widget.children),
        builder: (context, child) => FractionalTranslation(
          translation: Offset(
            _from * (1 - AppMotion.enter.transform(_slide.value)),
            0,
          ),
          child: child,
        ),
      ),
    );
  }
}
