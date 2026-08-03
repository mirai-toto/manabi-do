import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/grammar_provider.dart';
import '../../widgets/widgets.dart';
import 'grammar_lesson_list_screen.dart';

class GrammarChapterList extends ConsumerWidget {
  final String level;
  final VoidCallback onBack;

  const GrammarChapterList({
    super.key,
    required this.level,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final t = context.tokens;
    final themesAsync = ref.watch(grammarThemesProvider(level));
    final title = level == 'basics'
        ? l.japaneseBasics
        : levelLabel(level, context);
    final color = levelColor(level);

    return themesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const SizedBox.shrink(),
      data: (themes) => ListView(
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
            child: SectionLabel(l.grammarChapters),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
            child: Column(
              children: [
                for (int i = 0; i < themes.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppDimens.spaceSm),
                  _ThemeRow(theme: themes[i], accentColor: color),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
        ],
      ),
    );
  }
}

class _ThemeRow extends StatelessWidget {
  final GrammarTheme theme;
  final Color accentColor;

  const _ThemeRow({required this.theme, required this.accentColor});

  int get _lessonCount =>
      theme.chapters.fold(0, (sum, c) => sum + c.lessons.length);

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return TappableSurface(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: accentColor.withValues(alpha: 0.35)),
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              GrammarLessonListScreen(theme: theme, levelColor: accentColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceLg,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                theme.title,
                style: AppTextStyles.body.copyWith(
                  color: t.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceSm,
                vertical: AppDimens.spaceXs,
              ),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              ),
              child: Text(
                '$_lessonCount',
                style: AppTextStyles.labelLarge.copyWith(color: accentColor),
              ),
            ),
            const SizedBox(width: AppDimens.spaceSm),
            Icon(Icons.chevron_right_rounded, color: t.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
