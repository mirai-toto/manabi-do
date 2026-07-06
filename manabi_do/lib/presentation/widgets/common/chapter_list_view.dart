import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import 'number_badge.dart';
import 'section_label.dart';
import 'tappable_surface.dart';

class ChapterListView extends StatelessWidget {
  final String title;
  final String sectionLabel;
  final List<String> items;
  final Color accentColor;
  final VoidCallback onBack;
  final void Function(int) onItemTap;

  const ChapterListView({
    super.key,
    required this.title,
    required this.sectionLabel,
    required this.items,
    required this.accentColor,
    required this.onBack,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceSm,
            AppDimens.spaceSm,
            AppDimens.spaceMd,
            0,
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: t.onSurface),
                onPressed: onBack,
              ),
              Text(
                title,
                style: AppTextStyles.title.copyWith(color: t.onSurface),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.spaceMd,
            AppDimens.spaceSm,
            AppDimens.spaceMd,
            AppDimens.spaceSm,
          ),
          child: SectionLabel(sectionLabel),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(height: AppDimens.spaceSm),
                TappableSurface(
                  decoration: BoxDecoration(
                    color: t.cardBackground,
                    borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.35),
                    ),
                  ),
                  onTap: () => onItemTap(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceMd,
                      vertical: AppDimens.spaceLg,
                    ),
                    child: Row(
                      children: [
                        NumberBadge(number: i + 1, color: accentColor),
                        const SizedBox(width: AppDimens.spaceMd),
                        Expanded(
                          child: Text(
                            items[i],
                            style: AppTextStyles.body.copyWith(
                              color: t.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: t.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppDimens.spaceLg),
      ],
    );
  }
}
