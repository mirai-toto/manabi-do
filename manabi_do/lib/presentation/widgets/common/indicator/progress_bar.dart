import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_tokens.dart';

/// Thin horizontal progress bar (0–1). Accepts an optional `color`, track
/// colour, corner radius and `height`.
///
/// Fills smoothly: from empty when it first appears, and from where it was
/// whenever [progress] changes, so an answer in a session or a finished lesson
/// reads as movement rather than a jump.
class AppProgressBar extends StatelessWidget {
  final double progress; // 0.0 – 1.0
  final Color? color;
  final Color? trackColor;
  final double radius;
  final double height;
  final double? width;

  const AppProgressBar({
    super.key,
    required this.progress,
    this.color,
    this.trackColor,
    this.radius = AppDimens.radiusPill,
    this.height = 6,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final double target = progress.clamp(0.0, 1.0);

    return Semantics(
      value: '${(target * 100).round()}%',
      excludeSemantics: true,
      child: SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: target),
            duration: context.motion(AppMotion.long),
            curve: AppMotion.enter,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: height,
              backgroundColor: trackColor ?? t.surfaceVariant,
              valueColor: AlwaysStoppedAnimation(color ?? t.primary),
            ),
          ),
        ),
      ),
    );
  }
}
