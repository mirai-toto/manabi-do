import 'package:flutter/material.dart';

import '../../../../core/theme/app_motion.dart';

/// A whole number that counts to its value: up from zero when it first
/// appears, and from the old value whenever it changes.
///
/// Screen readers get the final value only, never the numbers in between.
class AnimatedCount extends StatelessWidget {
  final int value;
  final TextStyle? style;

  /// Turns the number being shown into text, e.g. `(n) => '$n%'`.
  final String Function(int value)? format;

  const AnimatedCount({
    super.key,
    required this.value,
    this.style,
    this.format,
  });

  String _text(int n) => format?.call(n) ?? '$n';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _text(value),
      excludeSemantics: true,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: value.toDouble()),
        duration: context.motion(AppMotion.long),
        curve: AppMotion.enter,
        builder: (context, shown, _) =>
            Text(_text(shown.round()), style: style),
      ),
    );
  }
}
