import '../entities/kanji.dart';

abstract interface class KanjiRepository {
  Future<List<Kanji>> getAll();
  Future<Kanji?> getById(int id);
  Future<List<Kanji>> getByJlptLevel(String level);
}
