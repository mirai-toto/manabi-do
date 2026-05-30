import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';

import '../../data/database/app_database.dart';
import 'database_provider.dart';

final vocabByLevelProvider =
    FutureProvider.family<List<VocabularyEntry>, String>(
      (ref, level) => ref.watch(databaseProvider).getVocabByLevel(level),
    );

final vocabSrsCardsProvider = StreamProvider<Map<int, Card>>(
  (ref) => ref.watch(databaseProvider).watchAllSrsCardsForType('vocabulary'),
);
