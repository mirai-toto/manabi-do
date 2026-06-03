import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import 'database_provider.dart';

typedef KanjiVocabArgs = ({int kanjiId, String character});

final kanjiVocabProvider =
    FutureProvider.family<List<VocabularyEntry>, KanjiVocabArgs>((ref, args) {
  return ref.watch(databaseProvider).getVocabForKanji(args.kanjiId, args.character);
});
