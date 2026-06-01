import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  // UI / Latin
  static TextStyle get display   => const TextStyle(fontFamily: 'Inter', fontSize: 36, fontWeight: FontWeight.w700, height: 1.1);
  static TextStyle get headline  => const TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w700, height: 1.2);
  static TextStyle get title     => const TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, height: 1.3);
  static TextStyle get titleLarge => const TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, height: 1.2);
  static TextStyle get body      => const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w400, height: 1.6);
  static TextStyle get bodySmall => const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w400, height: 1.4);
  static TextStyle get label     => const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.3);
  static TextStyle get labelSmall => const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3);
  static TextStyle get labelLarge => const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600);

  // Japanese
  static TextStyle get jpHero    => const TextStyle(fontFamily: 'NotoSansJP', fontSize: 96, fontWeight: FontWeight.w700, height: 1.0);
  static TextStyle get jpFlash   => const TextStyle(fontFamily: 'NotoSansJP', fontSize: 64, fontWeight: FontWeight.w700, height: 1.0);
  static TextStyle get jpKanji   => const TextStyle(fontFamily: 'NotoSansJP', fontSize: 52, fontWeight: FontWeight.w700, height: 1.0);
  static TextStyle get jpDisplay => const TextStyle(fontFamily: 'NotoSansJP', fontSize: 48, fontWeight: FontWeight.w700);
  static TextStyle get jpLarge   => const TextStyle(fontFamily: 'NotoSansJP', fontSize: 32, fontWeight: FontWeight.w500);
  static TextStyle get jpMedium  => const TextStyle(fontFamily: 'NotoSansJP', fontSize: 28, fontWeight: FontWeight.w500);
  static TextStyle get jpBody    => const TextStyle(fontFamily: 'NotoSansJP', fontSize: 16, fontWeight: FontWeight.w400);
}
