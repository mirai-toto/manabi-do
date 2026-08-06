import 'package:flutter/material.dart';

import '../../../core/theme/app_brand_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';

class LandingHeroPanel extends StatelessWidget {
  const LandingHeroPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppBrandColors.heroDeep,
            AppBrandColors.heroMid,
            t.primaryLight,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '学び',
              style: AppTextStyles.jpHero.copyWith(
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: t.primary.withValues(alpha: 0.6),
                    blurRadius: 32,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'MANABI DO',
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                letterSpacing: 3,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.tagline,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
