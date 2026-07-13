import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/grammar_provider.dart';
import '../../widgets/widgets.dart';
import 'grammar_lesson_list_screen.dart';
import 'grammar_lesson_screen.dart';

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
    final chaptersAsync = ref.watch(grammarChaptersProvider(level));
    final title = level == 'basics'
        ? l.japaneseBasics
        : levelLabel(level, context);
    final color = levelColor(level);

    return chaptersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const SizedBox.shrink(),
      data: (chapters) => ChapterListView(
        title: title,
        sectionLabel: l.grammarChapters,
        items: chapters.map((c) => c.title).toList(),
        accentColor: color,
        onBack: onBack,
        onItemTap: (i) {
          final chapter = chapters[i];
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
                builder: (_) => GrammarLessonListScreen(
                  chapter: chapter,
                  levelColor: color,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
