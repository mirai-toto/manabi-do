import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import 'database_provider.dart';

// (kanjiId, character) — both needed for the query
final kanjiVocabProvider =
    FutureProvider.family<List<VocabularyEntry>, (int, String)>((ref, args) {
  final (kanjiId, character) = args;
  return ref.watch(databaseProvider).getVocabForKanji(kanjiId, character);
});
