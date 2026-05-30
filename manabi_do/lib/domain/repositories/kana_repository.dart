import '../entities/kana.dart';

abstract interface class KanaRepository {
  Future<List<Kana>> getAll();
  Future<List<Kana>> getByType(KanaType type);
}
