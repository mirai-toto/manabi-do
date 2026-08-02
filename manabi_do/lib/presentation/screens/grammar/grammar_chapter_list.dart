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
import 'grammar_lesson_screen.dart';

class GrammarChapterList extends ConsumerStatefulWidget {
  final String level;
  final VoidCallback onBack;

  const GrammarChapterList({
    super.key,
    required this.level,
    required this.onBack,
  });

  @override
  ConsumerState<GrammarChapterList> createState() => _GrammarChapterListState();
}

class _GrammarChapterListState extends ConsumerState<GrammarChapterList> {
  final Set<int> _expanded = {};

  void _onChapterTap(GrammarChapter chapter, Color color) {
    if (chapter.lessons.length == 1) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => GrammarLessonScreen(
            lessonId: chapter.lessons.first.id,
            title: chapter.title,
            blocks: chapter.lessons.first.blocks,
            levelColor: color,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              GrammarLessonListScreen(chapter: chapter, levelColor: color),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final themesAsync = ref.watch(grammarGroupsProvider(widget.level));
    final title = widget.level == 'basics'
        ? l.japaneseBasics
        : levelLabel(widget.level, context);
    final color = levelColor(widget.level);

    return themesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const SizedBox.shrink(),
      data: (groups) => ListView(
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
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: context.tokens.onSurface,
                  ),
                  onPressed: widget.onBack,
                ),
                Text(
                  title,
                  style: AppTextStyles.title.copyWith(
                    color: context.tokens.onSurface,
                  ),
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
          for (int ti = 0; ti < groups.length; ti++) ...[
            _GroupSection(
              group: groups[ti],
              accentColor: color,
              isCollapsed: !_expanded.contains(ti),
              onToggle: () => setState(() {
                if (_expanded.contains(ti)) {
                  _expanded.remove(ti);
                } else {
                  _expanded.add(ti);
                }
              }),
              onChapterTap: (chapter) => _onChapterTap(chapter, color),
            ),
            const SizedBox(height: AppDimens.spaceSm),
          ],
          const SizedBox(height: AppDimens.spaceLg),
        ],
      ),
    );
  }
}

class _GroupSection extends StatelessWidget {
  final GrammarGroup group;
  final Color accentColor;
  final bool isCollapsed;
  final VoidCallback onToggle;
  final void Function(GrammarChapter) onChapterTap;

  const _GroupSection({
    required this.group,
    required this.accentColor,
    required this.isCollapsed,
    required this.onToggle,
    required this.onChapterTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimens.spaceMd,
                horizontal: AppDimens.spaceXs,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      group.title,
                      style: AppTextStyles.title.copyWith(color: accentColor),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isCollapsed ? -0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more_rounded,
                      color: accentColor,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: isCollapsed
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            secondChild: const SizedBox.shrink(),
            firstChild: Column(
              children: [
                for (int i = 0; i < group.chapters.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppDimens.spaceSm),
                  TappableSurface(
                    decoration: BoxDecoration(
                      color: t.cardBackground,
                      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.35),
                      ),
                    ),
                    onTap: () => onChapterTap(group.chapters[i]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceMd,
                        vertical: AppDimens.spaceLg + 4,
                      ),
                      child: Row(
                        children: [
                          NumberBadge(number: i + 1, color: accentColor),
                          const SizedBox(width: AppDimens.spaceMd),
                          Expanded(
                            child: Text(
                              group.chapters[i].title,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: t.onSurface,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
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
                const SizedBox(height: AppDimens.spaceSm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
