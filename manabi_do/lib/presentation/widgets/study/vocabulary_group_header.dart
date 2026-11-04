import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

/// In-page back row at the top of the vocabulary level and group views: a
/// back button, a small coloured [eyebrow], and the [title] under it.
class VocabularyGroupHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final Color color;
  final VoidCallback onBack;

  const VocabularyGroupHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.color,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceSm,
        AppDimens.spaceSm,
        AppDimens.spaceMd,
        0,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: onBack,
            color: t.onSurface,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyles.title.copyWith(color: t.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
