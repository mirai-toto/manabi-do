import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../widgets.dart';

class HomeHeader extends StatelessWidget {
  final String greeting;
  final String subtitle;
  const HomeHeader({super.key, required this.greeting, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMd,
        AppDimens.spaceMd,
        AppDimens.spaceMd,
        AppDimens.spaceLg,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      greeting,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: t.onSurface,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const AppEmoji('👋', size: 22),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceXxs),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: t.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: t.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '?',
                style: AppTextStyles.title.copyWith(color: t.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
