import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../common/action/app_button.dart';

/// The 練 ("practice") glyph tile's side.
const double _kGlyphTileSize = 40;

/// Says, at the top of a practice picker, that nothing here is recorded, and
/// offers the daily reviews instead. Filled with `primary` so it reads before
/// the mode cards below it; the 練 tile names the mode rather than warning
/// against it. All strings come from the caller.
class PracticeModeBanner extends StatelessWidget {
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  const PracticeModeBanner({
    super.key,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: t.primary,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: _kGlyphTileSize,
            height: _kGlyphTileSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: t.onPrimary.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            ),
            child: ExcludeSemantics(
              child: Text(
                '練',
                style: AppTextStyles.jpBody.copyWith(
                  fontSize: 22,
                  height: 1,
                  color: t.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceCozy),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      color: t.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXs),
                Text(
                  body,
                  style: AppTextStyles.bodySmall.copyWith(color: t.onPrimary),
                ),
                const SizedBox(height: AppDimens.spaceXs),
                AppButton(
                  label: actionLabel,
                  onPressed: onAction,
                  variant: AppButtonVariant.text,
                  size: AppButtonSize.small,
                  foregroundColor: t.onPrimary,
                  padding: EdgeInsets.zero,
                  textStyle: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: t.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
