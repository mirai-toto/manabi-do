import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTextStyles {
  // UI / Latin
  static TextStyle get display => GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w700, height: 1.1);
  static TextStyle get headline => GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, height: 1.2);
  static TextStyle get title => GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3);
  static TextStyle get body => GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, height: 1.6);
  static TextStyle get label => GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.3);
  static TextStyle get labelLarge => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600);

  // Japanese
  static TextStyle get jpDisplay => GoogleFonts.notoSansJp(fontSize: 48, fontWeight: FontWeight.w700);
  static TextStyle get jpLarge => GoogleFonts.notoSansJp(fontSize: 32, fontWeight: FontWeight.w500);
  static TextStyle get jpBody => GoogleFonts.notoSansJp(fontSize: 16, fontWeight: FontWeight.w400);
}
