import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/locale_provider.dart';
import '../../data/grammar/grammar_models.dart';
import 'database_provider.dart';

export '../../data/grammar/grammar_models.dart';

class GrammarChapter {
  final String title;
  final List<GrammarLesson> lessons;

  const GrammarChapter({required this.title, required this.lessons});
}

class GrammarGroup {
  final String title;
  final List<GrammarChapter> chapters;

  const GrammarGroup({required this.title, required this.chapters});
}

final grammarGroupsProvider = FutureProvider.family<List<GrammarGroup>, String>(
  (ref, level) async {
    final db = ref.read(databaseProvider);
    final locale = ref.watch(localeProvider).languageCode;
    final rows = await db.getGrammarLessonsForLevel(level, locale: locale);
    final groups = <String, Map<String, List<GrammarLesson>>>{};
    for (final row in rows) {
      final blocks = (jsonDecode(row.blocksJson) as List<dynamic>)
          .map(
            (b) => GrammarBlock.fromJson(Map<String, dynamic>.from(b as Map)),
          )
          .toList();
      groups
          .putIfAbsent(row.groupName, () => {})
          .putIfAbsent(row.chapter, () => [])
          .add(GrammarLesson(id: row.path, title: row.title, blocks: blocks));
    }
    return groups.entries.map((ge) {
      final chapters = ge.value.entries
          .map((ce) => GrammarChapter(title: ce.key, lessons: ce.value))
          .toList();
      return GrammarGroup(title: ge.key, chapters: chapters);
    }).toList();
  },
);

final grammarHasExercisesProvider = FutureProvider.family<bool, String>((
  ref,
  lessonPath,
) async {
  final db = ref.read(databaseProvider);
  final rows = await db.getGrammarExercisesForLesson(lessonPath);
  return rows.isNotEmpty;
});
