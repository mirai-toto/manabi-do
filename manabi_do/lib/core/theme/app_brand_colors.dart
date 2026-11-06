import 'package:flutter/material.dart';

// Colors that are intentionally invariant across light/dark themes: brand identity, not semantic.
abstract final class AppBrandColors {
  // Apple sign-in button (black per Apple HIG: must not change with app theme)
  static const appleButton = Color(0xFF1C1C1E);

  // Streak card gradient (orange: invariant, not a semantic colour)
  static const streakStart = Color(0xFFFF6B35);
  static const streakEnd = Color(0xFFFF8C42);
}
