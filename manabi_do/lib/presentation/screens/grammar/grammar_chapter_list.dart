import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/grammar_provider.dart';
import '../../widgets/widgets.dart';
import 'grammar_lesson_list_screen.dart';
import 'grammar_lesson_screen.dart';

// Levels that have been migrated to JSON block format.
const _jsonLevels = {'basics'};

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
    final isJson = _jsonLevels.contains(level);
    final chaptersAsync = isJson
        ? ref.watch(grammarJsonChaptersProvider(level))
        : ref.watch(grammarChaptersProvider(level));
    final title = level == 'basics'
        ? l.japaneseBasics
        : levelLabel(level, context);

    return chaptersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const SizedBox.shrink(),
      data: (chapters) => ChapterListView(
        title: title,
        sectionLabel: l.grammarChapters,
        items: chapters.map((c) => c.title).toList(),
        onBack: onBack,
        onItemTap: (i) {
          final chapter = chapters[i];
          if (chapter.isJson) {
            final color = _levelColor(level);
            if (chapter.lessons.length == 1) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => GrammarLessonScreen(
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
          } else {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => GrammarLessonScreen(
                  title: chapter.title,
                  content: chapter.content,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Color _levelColor(String level) {
    if (level == 'basics') return const Color(0xFF795548);
    return levelColor(level);
  }
}
