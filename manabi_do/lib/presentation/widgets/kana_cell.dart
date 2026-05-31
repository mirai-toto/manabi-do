import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class KanaCell extends StatelessWidget {
  final String kana;
  final String romaji;
  final bool isKnown;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const KanaCell({
    super.key,
    required this.kana,
    required this.romaji,
    this.isKnown = false,
    this.onTap,
    this.width = 72,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isKnown ? AppColors.successContainer : Colors.white,
          border: Border.all(
            color: isKnown ? AppColors.success : AppColors.outlineVariant,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              kana,
              style: GoogleFonts.notoSansJp(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                height: 1,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              romaji,
              style: AppTextStyles.label.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: isKnown ? AppColors.success : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
