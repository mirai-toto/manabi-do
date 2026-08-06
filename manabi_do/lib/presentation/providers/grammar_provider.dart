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

class GrammarTheme {
  final String title;
  final String description;
  final List<GrammarChapter> chapters;

  const GrammarTheme({
    required this.title,
    required this.description,
    required this.chapters,
  });
}

final grammarThemesProvider = FutureProvider.family<List<GrammarTheme>, String>(
  (ref, level) async {
    final db = ref.read(databaseProvider);
    final locale = ref.read(localeProvider).languageCode;
    final rows = await db.getGrammarLessonsForLevel(level, locale: locale);
    final themes = <String, Map<String, List<GrammarLesson>>>{};
    final themeDescriptions = <String, String>{};
    for (final row in rows) {
      final blocks = (jsonDecode(row.blocksJson) as List<dynamic>)
          .map(
            (b) => GrammarBlock.fromJson(Map<String, dynamic>.from(b as Map)),
          )
          .toList();
      themes
          .putIfAbsent(row.themeName, () => {})
          .putIfAbsent(row.chapter, () => [])
          .add(
            GrammarLesson(
              id: row.path,
              title: row.title,
              blocks: blocks,
              difficulty: row.difficulty,
            ),
          );
      themeDescriptions.putIfAbsent(row.themeName, () => row.themeDescription);
    }
    return themes.entries.map((te) {
      final chapters = te.value.entries
          .map((ce) => GrammarChapter(title: ce.key, lessons: ce.value))
          .toList();
      return GrammarTheme(
        title: te.key,
        description: themeDescriptions[te.key] ?? '',
        chapters: chapters,
      );
    }).toList();
  },
);

final grammarStartedLessonsProvider = StreamProvider<Set<String>>((ref) {
  final db = ref.read(databaseProvider);
  return db.watchStartedGrammarLessons();
});

final grammarUnlockedChaptersProvider = StreamProvider<Set<String>>((ref) {
  final db = ref.read(databaseProvider);
  return db.watchUnlockedGrammarChapters();
});

final grammarReadLessonsProvider = StreamProvider<Set<String>>((ref) {
  final db = ref.read(databaseProvider);
  return db.watchReadGrammarLessons();
});

final grammarHasExercisesProvider = FutureProvider.family<bool, String>((
  ref,
  lessonPath,
) async {
  final db = ref.read(databaseProvider);
  final rows = await db.getGrammarExercisesForLesson(lessonPath);
  return rows.isNotEmpty;
});

final grammarExerciseCountsProvider =
    FutureProvider.family<Map<String, int>, String>((
      ref,
      lessonPathsKey,
    ) async {
      final db = ref.read(databaseProvider);
      final lessonPaths = lessonPathsKey.isEmpty
          ? <String>[]
          : lessonPathsKey.split('\n');
      return db.getGrammarExerciseCountsForLessons(lessonPaths);
    });

final grammarChapterHasExercisesProvider = FutureProvider.family<bool, String>((
  ref,
  lessonPathsKey,
) async {
  final db = ref.read(databaseProvider);
  final lessonPaths = lessonPathsKey.isEmpty
      ? <String>[]
      : lessonPathsKey.split('\n');
  final rows = await db.getGrammarExercisesForLessons(lessonPaths);
  return rows.isNotEmpty;
});
