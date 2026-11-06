import 'package:flutter/material.dart';

/// How things move. One set of durations and curves, so every animation in the
/// app feels like the same app.
///
/// Short enough never to make anyone wait: an animation here decorates a
/// change, it does not hold the change back, and input is never blocked while
/// one runs.
abstract final class AppMotion {
  /// A colour change, a tab sliding over.
  static const Duration short = Duration(milliseconds: 160);

  /// Something moving into place: a card, a row of buttons, a question.
  static const Duration medium = Duration(milliseconds: 220);

  /// A number counting up, a bar filling, a small celebration.
  static const Duration long = Duration(milliseconds: 400);

  /// Gap between items that arrive one after another.
  static const Duration stagger = Duration(milliseconds: 30);

  /// Decelerates into place: for things moving across the screen.
  static const Curve enter = Curves.easeOutCubic;

  /// Lands with a slight overshoot: for things springing into place and for
  /// a pop of approval. Nothing in the app fades in; it moves in.
  static const Curve pop = Curves.easeOutBack;
}

extension MotionContext on BuildContext {
  /// [duration], or nothing when the user turned animations off in the
  /// system settings: everything then changes at once, as it used to.
  Duration motion(Duration duration) =>
      MediaQuery.disableAnimationsOf(this) ? Duration.zero : duration;
}
