import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

class CollapsibleSection extends StatelessWidget {
  final String title;
  final bool isCollapsed;
  final Color accentColor;
  final VoidCallback onToggle;

  const CollapsibleSection({
    super.key,
    required this.title,
    required this.isCollapsed,
    required this.accentColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      onTap: onToggle,
      child: Container(
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceMd,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: t.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            AnimatedRotation(
              turns: isCollapsed ? -0.25 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.expand_more_rounded,
                color: accentColor,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
