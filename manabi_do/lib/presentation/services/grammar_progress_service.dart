import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';

/// Unlock keys. A theme, a group of lessons and a single lesson all record
/// "the learner chose to skip ahead" in one table, told apart by prefix, so the
/// format has to be built the same way wherever it is written or read.
String grammarThemeKey(String level, int themeIndex) => '$level:$themeIndex';

String grammarGroupKey(String themeTitle, int chapterIndex) =>
    'group:$themeTitle:$chapterIndex';

String grammarLessonKey(String lessonId) => 'lesson:$lessonId';

/// Records what the learner has done with a grammar lesson.
///
/// Screens call this instead of the database: opening a lesson, ticking it as
/// read and unlocking ahead are progress decisions, not navigation.
class GrammarProgressService {
  final AppDatabase _db;

  const GrammarProgressService(this._db);

  /// Opening a lesson counts as starting it, which is what the home screen
  /// resumes to.
  Future<void> markLessonStarted(String lessonId) =>
      _db.markGrammarLessonStarted(lessonId);

  Future<void> setLessonRead(String lessonId, {required bool isRead}) => isRead
      ? _db.markGrammarLessonRead(lessonId)
      : _db.unmarkGrammarLessonRead(lessonId);

  Future<void> unlockTheme(String level, int themeIndex) =>
      _db.unlockGrammarChapter(grammarThemeKey(level, themeIndex));

  Future<void> unlockGroup(String themeTitle, int chapterIndex) =>
      _db.unlockGrammarChapter(grammarGroupKey(themeTitle, chapterIndex));

  Future<void> unlockLesson(String lessonId) =>
      _db.unlockGrammarChapter(grammarLessonKey(lessonId));
}

final grammarProgressServiceProvider = Provider(
  (ref) => GrammarProgressService(ref.read(databaseProvider)),
);
