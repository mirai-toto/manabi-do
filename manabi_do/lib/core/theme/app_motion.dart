import 'package:flutter/material.dart';

/// How things move. One set of durations and curves, so every animation in the
/// app feels like the same app.
///
/// Short enough never to make anyone wait: an animation here decorates a
/// change, it does not hold the change back, and input is never blocked while
/// one runs.
abstract final class AppMotion {
  /// A colour, an opacity, a tab cross-fade.
  static const Duration short = Duration(milliseconds: 150);

  /// Something moving into place: a card, a row of buttons.
  static const Duration medium = Duration(milliseconds: 250);

  /// A number counting up, a bar filling, a small celebration.
  static const Duration long = Duration(milliseconds: 450);

  /// Gap between items that arrive one after another.
  static const Duration stagger = Duration(milliseconds: 40);

  /// Decelerates into place: for things arriving.
  static const Curve enter = Curves.easeOutCubic;

  /// Overshoots slightly: for a pop of approval.
  static const Curve pop = Curves.easeOutBack;
}

extension MotionContext on BuildContext {
  /// [duration], or nothing when the user turned animations off in the
  /// system settings: everything then changes at once, as it used to.
  Duration motion(Duration duration) =>
      MediaQuery.disableAnimationsOf(this) ? Duration.zero : duration;
}
