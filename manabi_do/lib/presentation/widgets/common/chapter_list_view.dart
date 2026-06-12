import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import 'card_container.dart';
import 'section_label.dart';

class ChapterListView extends StatelessWidget {
  final String title;
  final String sectionLabel;
  final List<String> items;
  final VoidCallback onBack;
  final void Function(int) onItemTap;

  const ChapterListView({
    super.key,
    required this.title,
    required this.sectionLabel,
    required this.items,
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
              AppDimens.spaceSm, AppDimens.spaceSm, AppDimens.spaceMd, 0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: t.onSurface),
                onPressed: onBack,
              ),
              Text(title, style: AppTextStyles.title.copyWith(color: t.onSurface)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppDimens.spaceMd, AppDimens.spaceSm, AppDimens.spaceMd, AppDimens.spaceSm),
          child: SectionLabel(sectionLabel),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          child: CardContainer(
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: t.outlineVariant),
                  InkWell(
                    onTap: () => onItemTap(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceMd,
                        vertical: AppDimens.spaceMd,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              items[i],
                              style: AppTextStyles.body.copyWith(color: t.onSurface),
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, color: t.onSurfaceVariant),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimens.spaceLg),
      ],
    );
  }
}
