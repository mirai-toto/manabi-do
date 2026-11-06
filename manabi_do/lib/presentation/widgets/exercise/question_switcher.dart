import 'package:flutter/material.dart';

import '../../../core/theme/app_motion.dart';

/// Moves a session from one question to the next: the next question pushes
/// the answered one out to the left, both fully visible, like turning a card.
///
/// [index] identifies the question, so each one gets fresh state, as the
/// keyed subtree this replaces did. The question on its way out ignores taps:
/// a second tap during the slide must not answer it twice.
class QuestionSwitcher extends StatelessWidget {
  final int index;
  final Widget child;

  const QuestionSwitcher({super.key, required this.index, required this.child});

  /// How far a question travels, as a share of its width: all the way, so
  /// the two cards meet edge to edge.
  static const double _travel = 1;

  @override
  Widget build(BuildContext context) {
    final Key current = ValueKey(index);
    return ClipRect(
      child: AnimatedSwitcher(
        duration: context.motion(AppMotion.medium),
        switchInCurve: AppMotion.enter,
        switchOutCurve: AppMotion.enter,
        layoutBuilder: (currentChild, previousChildren) => Stack(
          alignment: Alignment.topCenter,
          children: [...previousChildren, ?currentChild],
        ),
        transitionBuilder: (child, animation) {
          final bool incoming = child.key == current;
          // An outgoing child's animation runs from 1 back to 0, so its start
          // offset is where it ends up: to the left.
          final Offset start = Offset(incoming ? _travel : -_travel, 0);
          return IgnorePointer(
            ignoring: !incoming,
            child: SlideTransition(
              position: Tween(
                begin: start,
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(key: current, child: child),
      ),
    );
  }
}
