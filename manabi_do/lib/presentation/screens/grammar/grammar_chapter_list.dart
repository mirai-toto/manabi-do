import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/grammar_provider.dart';
import '../../widgets/widgets.dart';
import 'grammar_lesson_screen.dart';

class GrammarChapterList extends ConsumerWidget {
  final String level;
  final VoidCallback onBack;

  const GrammarChapterList({super.key, required this.level, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;
    final chaptersAsync = ref.watch(grammarChaptersProvider(level));
    final title = level == 'basics' ? l.japaneseBasics : levelLabel(level, context);

    return chaptersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const SizedBox.shrink(),
      data: (chapters) => ListView(
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
            child: SectionLabel(l.grammarChapters),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            child: CardContainer(
              child: Column(
                children: [
                  for (int i = 0; i < chapters.length; i++) ...[
                    if (i > 0) Divider(height: 1, color: t.outlineVariant),
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => GrammarLessonScreen(
                            title: chapters[i].title,
                            content: chapters[i].content,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceMd,
                          vertical: AppDimens.spaceMd,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                chapters[i].title,
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
      ),
    );
  }
}
