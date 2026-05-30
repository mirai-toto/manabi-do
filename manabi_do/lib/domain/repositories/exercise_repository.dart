import '../entities/exercise.dart';

abstract interface class ExerciseRepository {
  Future<List<Exercise>> getBySource(ExerciseSource source, int sourceId, String locale);
  Future<List<Exercise>> getByLesson(int lessonId, String locale);
}
