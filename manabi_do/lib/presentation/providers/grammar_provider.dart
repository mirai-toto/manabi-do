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

final grammarChaptersProvider =
    FutureProvider.family<List<GrammarChapter>, String>((ref, level) async {
      final db = ref.read(databaseProvider);
      final locale = ref.watch(localeProvider).languageCode;
      final rows = await db.getGrammarLessonsForLevel(level, locale: locale);
      final chapters = <String, List<GrammarLesson>>{};
      for (final row in rows) {
        final blocks = (jsonDecode(row.blocksJson) as List<dynamic>)
            .map(
              (b) => GrammarBlock.fromJson(Map<String, dynamic>.from(b as Map)),
            )
            .toList();
        chapters
            .putIfAbsent(row.chapter, () => [])
            .add(GrammarLesson(id: row.path, title: row.title, blocks: blocks));
      }
      return chapters.entries
          .map((e) => GrammarChapter(title: e.key, lessons: e.value))
          .toList();
    });

final grammarHasExercisesProvider = FutureProvider.family<bool, String>((
  ref,
  lessonPath,
) async {
  final db = ref.read(databaseProvider);
  final rows = await db.getGrammarExercisesForLesson(lessonPath);
  return rows.isNotEmpty;
});
