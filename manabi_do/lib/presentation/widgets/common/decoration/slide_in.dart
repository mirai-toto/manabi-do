import 'package:flutter/material.dart';

import '../../../../core/theme/app_motion.dart';

/// Springs [child] up into place, once, when it is first built. [order]
/// staggers a column of these so they land one after another.
///
/// The child is fully visible throughout: it moves in rather than fading in,
/// which reads as quicker. Plays only on the first build, so a screen kept
/// alive in the tab stack does not replay it on every visit.
class SlideIn extends StatefulWidget {
  final int order;
  final Widget child;

  const SlideIn({super.key, this.order = 0, required this.child});

  /// How far below its place the child starts, in logical pixels.
  static const double _rise = 16;

  @override
  State<SlideIn> createState() => _SlideInState();
}

class _SlideInState extends State<SlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.medium,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.pop,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
      return;
    }
    Future<void>.delayed(AppMotion.stagger * widget.order, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, SlideIn._rise * (1 - _curve.value)),
        child: child,
      ),
    );
  }
}
