import 'package:flutter/material.dart';

/// The app's loading spinner. Every size it is shown at lives here, so
/// restyling the spinner is one edit rather than one per call site.
///
/// Colour is deliberately left to the theme: a bare indicator reads
/// `ColorScheme.primary`, which `AccentTheme` rebinds to the JLPT level colour,
/// so a spinner inside a level session picks up that level's accent.
///
/// Wrap it in the `Center` or `Padding` the surrounding layout needs — this
/// widget is only the spinner itself.
class AppSpinner extends StatelessWidget {
  /// Fits on a text line, for a count or label that is still loading.
  static const double small = 14;

  /// Stands in for a block of content that has not arrived yet.
  static const double regular = 24;

  final double size;
  final double strokeWidth;

  const AppSpinner({super.key, this.size = regular, this.strokeWidth = 2});

  /// The loader for a screen or section with nothing else on it yet. Matches
  /// the framework's own default size and weight, which is what these loaders
  /// have always shown.
  const AppSpinner.page({super.key}) : size = 36, strokeWidth = 4;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CircularProgressIndicator(strokeWidth: strokeWidth),
  );
}
