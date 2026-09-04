import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_brand_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/l10n.dart';

class StreakPill extends StatelessWidget {
  final int days;

  const StreakPill({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Semantics(
      label: '$days ${l.streakLabel}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.chipPaddingH,
          vertical: AppDimens.chipPaddingV,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppBrandColors.streakStart, AppBrandColors.streakEnd],
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/fire.svg',
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppDimens.spaceXs),
            Text(
              '$days',
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
