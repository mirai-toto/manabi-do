import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/models/mcq_option.dart';
import '../../../core/theme/app_motion.dart';

/// Reacts once when an answer option is marked: a small pop when it turns
/// correct, a short shake when it turns wrong. Nothing happens while the
/// option stays as it is, so rebuilding the card does not replay it.
class AnswerReaction extends StatefulWidget {
  final McqOptionState state;
  final Widget child;

  const AnswerReaction({super.key, required this.state, required this.child});

  /// The pop's peak size, relative to the option.
  static const double _popScale = 1.04;

  /// How far the shake swings each way, in logical pixels.
  static const double _shakeDistance = 6;

  /// Full swings in one shake.
  static const int _shakeSwings = 3;

  @override
  State<AnswerReaction> createState() => _AnswerReactionState();
}

class _AnswerReactionState extends State<AnswerReaction>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.long,
  );

  /// Up to the peak in the first third, settling back for the rest.
  static final Animatable<double> _pop = TweenSequence([
    TweenSequenceItem(
      tween: Tween(
        begin: 1.0,
        end: AnswerReaction._popScale,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: Tween(
        begin: AnswerReaction._popScale,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 2,
    ),
  ]);

  @override
  void didUpdateWidget(AnswerReaction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state == widget.state) return;
    if (widget.state != McqOptionState.correct &&
        widget.state != McqOptionState.wrong) {
      return;
    }
    if (MediaQuery.disableAnimationsOf(context)) return;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final double t = _controller.value;
        if (t == 0 || t == 1) return child!;
        if (widget.state == McqOptionState.wrong) {
          // Swings that die down, so it settles rather than stops.
          final double swing =
              math.sin(t * AnswerReaction._shakeSwings * 2 * math.pi) * (1 - t);
          return Transform.translate(
            offset: Offset(swing * AnswerReaction._shakeDistance, 0),
            child: child,
          );
        }
        final double scale = _pop.transform(t);
        return Transform.scale(scale: scale, child: child);
      },
    );
  }
}
