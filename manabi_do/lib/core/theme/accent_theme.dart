import 'package:flutter/material.dart';

import 'app_tokens.dart';

/// Scopes [child] to a level's colour: everything below it that paints itself
/// `t.primary` (or the rest of the primary ramp) uses [accent] instead of the
/// app-wide purple.
///
/// Wrap the *body* of a screen rather than its whole `Scaffold`. Modal routes
/// such as `showModalBottomSheet` capture the inherited themes of the context
/// they are opened from, so leaving the app bar outside keeps sheets launched
/// from it on the app's own accent.
class AccentTheme extends StatelessWidget {
  final Color accent;
  final Widget child;

  const AccentTheme({super.key, required this.accent, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.tokens;

    // copyWith replaces the whole extension set, so carry the others over
    // rather than dropping them.
    final extensions =
        List<ThemeExtension<dynamic>>.from(theme.extensions.values)
          ..removeWhere((e) => e is AppTokens)
          ..add(tokens.accented(accent, theme.brightness));

    return Theme(
      data: theme.copyWith(extensions: extensions),
      child: child,
    );
  }
}
