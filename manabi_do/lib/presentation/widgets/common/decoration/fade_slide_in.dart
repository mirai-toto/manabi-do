import 'package:flutter/material.dart';

import '../../../../core/theme/app_motion.dart';

/// Fades [child] in while it rises a few pixels into place, once, when it is
/// first built. [order] staggers a column of these so they arrive one after
/// another rather than all at once.
///
/// Plays only on the first build: a screen kept alive in the tab stack does
/// not replay it on every visit.
class FadeSlideIn extends StatefulWidget {
  final int order;
  final Widget child;

  const FadeSlideIn({super.key, this.order = 0, required this.child});

  /// How far below its place the child starts, in logical pixels.
  static const double _rise = 12;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.medium,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.enter,
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
      builder: (context, child) => Opacity(
        opacity: _curve.value,
        child: Transform.translate(
          offset: Offset(0, FadeSlideIn._rise * (1 - _curve.value)),
          child: child,
        ),
      ),
    );
  }
}
