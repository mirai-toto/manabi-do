import 'package:flutter/material.dart';

// Colors that are intentionally invariant across light/dark themes — brand identity, not semantic.
abstract final class AppBrandColors {
  // Landing screen hero gradient (always shown on a dark surface)
  static const heroDeep = Color(0xFF0D0630);
  static const heroMid  = Color(0xFF3D1FCC);

  // Apple sign-in button (black per Apple HIG — must not change with app theme)
  static const appleButton = Color(0xFF1C1C1E);

  // Streak card gradient (orange — invariant, not a semantic colour)
  static const streakStart = Color(0xFFFF6B35);
  static const streakEnd   = Color(0xFFFF8C42);
}
