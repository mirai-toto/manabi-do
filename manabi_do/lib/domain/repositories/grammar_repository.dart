import '../entities/grammar_lesson.dart';

abstract interface class GrammarRepository {
  Future<List<GrammarLesson>> getLessons(String locale);
  Future<GrammarLesson?> getLessonById(int id);
  Future<List<GrammarLesson>> getLessonsByChapter(String chapter, String locale);
}
