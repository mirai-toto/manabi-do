abstract final class AppDimens {
  // Max content width: applied to all screens for consistent centering
  static const double screenMaxWidth = 1100;

  // Border radius: matches mockup CSS variables
  static const double radiusXxs = 2;
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 28;
  static const double radiusPill = 100;

  // Spacing
  static const double spaceXxs = 2;
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  // Half-steps, for dense layouts where the 8 / 16 scale is too coarse.
  static const double spaceTight = 6;
  static const double spaceSnug = 10;
  static const double spaceCozy = 12;

  // Shared across widgets that have to agree with each other. A value only
  // belongs here if two widgets diverging on it would be a bug; one that is
  // merely the same number in two places lives in the widget that uses it.
  static const double chipPaddingH = 14;
  static const double chipPaddingV = 6;
  static const double buttonPaddingV = 12;
  static const double optionTilePaddingV = 14;
  static const double iconTextGap = 14;
  static const double fabClearance = 80;
}
