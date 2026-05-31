import '../entities/vocabulary.dart';

abstract interface class VocabularyRepository {
  Future<List<Vocabulary>> getAll();
  Future<List<Vocabulary>> getByJlptLevel(String level);
  Future<List<Vocabulary>> getByKanji(int kanjiId);
}
