part of '../app_database.dart';

/// Grammar lessons, exercises and progress flags.
extension GrammarQueries on AppDatabase {
  Future<List<GrammarLessonRow>> getGrammarLessonsForLevel(
    String level, {
    String locale = 'en',
  }) async {
    final rows =
        await (select(grammarLessons)
              ..where((g) => g.level.equals(level) & g.locale.equals(locale))
              ..orderBy([(g) => OrderingTerm.asc(g.orderIndex)]))
            .get();
    if (rows.isNotEmpty || locale == 'en') return rows;
    return (select(grammarLessons)
          ..where((g) => g.level.equals(level) & g.locale.equals('en'))
          ..orderBy([(g) => OrderingTerm.asc(g.orderIndex)]))
        .get();
  }

  Future<List<GrammarExerciseRow>> getGrammarExercisesForLesson(
    String lessonPath,
  ) =>
      (select(grammarExercises)
            ..where((e) => e.lessonPath.equals(lessonPath))
            ..orderBy([(e) => OrderingTerm.asc(e.orderIndex)]))
          .get();

  Stream<Set<String>> watchUnlockedGrammarChapters() => select(
    grammarChapterUnlocks,
  ).watch().map((rows) => rows.map((r) => r.chapterKey).toSet());

  Future<void> unlockGrammarChapter(String chapterKey) =>
      into(grammarChapterUnlocks).insertOnConflictUpdate(
        GrammarChapterUnlocksCompanion.insert(chapterKey: chapterKey),
      );

  Stream<Set<String>> watchStartedGrammarLessons() => select(
    grammarLessonStarts,
  ).watch().map((rows) => rows.map((r) => r.lessonPath).toSet());

  Future<void> markGrammarLessonStarted(String lessonPath) =>
      into(grammarLessonStarts).insertOnConflictUpdate(
        GrammarLessonStartsCompanion.insert(lessonPath: lessonPath),
      );

  Stream<Set<String>> watchReadGrammarLessons() => select(
    grammarLessonProgress,
  ).watch().map((rows) => rows.map((r) => r.lessonPath).toSet());

  Future<void> markGrammarLessonRead(String lessonPath) =>
      into(grammarLessonProgress).insertOnConflictUpdate(
        GrammarLessonProgressCompanion.insert(
          lessonPath: lessonPath,
          readAt: DateTime.now(),
        ),
      );

  Future<void> unmarkGrammarLessonRead(String lessonPath) => (delete(
    grammarLessonProgress,
  )..where((r) => r.lessonPath.equals(lessonPath))).go();

  Future<List<GrammarExerciseRow>> getGrammarExercisesForLessons(
    List<String> lessonPaths,
  ) =>
      (select(grammarExercises)
            ..where((e) => e.lessonPath.isIn(lessonPaths))
            ..orderBy([(e) => OrderingTerm.asc(e.orderIndex)]))
          .get();

  Future<Map<String, int>> getGrammarExerciseCountsForLessons(
    List<String> lessonPaths,
  ) async {
    if (lessonPaths.isEmpty) return {};
    final rows = await (select(
      grammarExercises,
    )..where((e) => e.lessonPath.isIn(lessonPaths))).get();
    final counts = <String, int>{};
    for (final row in rows) {
      counts[row.lessonPath] = (counts[row.lessonPath] ?? 0) + 1;
    }
    return counts;
  }
}
