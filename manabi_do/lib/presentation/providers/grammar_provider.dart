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
    final locale = ref.watch(localeProvider).languageCode;
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

class GrammarContinueTarget {
  final GrammarLesson lesson;
  final String themeTitle;
  final String chapterTitle;
  final int lessonIndex;
  final int chapterLessonCount;
  final String level;

  const GrammarContinueTarget({
    required this.lesson,
    required this.themeTitle,
    required this.chapterTitle,
    required this.lessonIndex,
    required this.chapterLessonCount,
    required this.level,
  });
}

const _continueLevels = ['basics', 'N5'];

/// The next grammar lesson to resume: the first started-but-unread lesson,
/// falling back to the first unread one, scanning basics then N5 in order.
/// Null when every available lesson has been read.
final grammarContinueProvider = FutureProvider<GrammarContinueTarget?>((
  ref,
) async {
  final read = await ref.watch(grammarReadLessonsProvider.future);
  final started = await ref.watch(grammarStartedLessonsProvider.future);

  GrammarContinueTarget? firstUnread;
  for (final level in _continueLevels) {
    final themes = await ref.watch(grammarThemesProvider(level).future);
    for (final theme in themes) {
      for (final chapter in theme.chapters) {
        for (var i = 0; i < chapter.lessons.length; i++) {
          final lesson = chapter.lessons[i];
          if (read.contains(lesson.id)) continue;
          final target = GrammarContinueTarget(
            lesson: lesson,
            themeTitle: theme.title,
            chapterTitle: chapter.title,
            lessonIndex: i,
            chapterLessonCount: chapter.lessons.length,
            level: level,
          );
          if (started.contains(lesson.id)) return target;
          firstUnread ??= target;
        }
      }
    }
  }
  return firstUnread;
});

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
