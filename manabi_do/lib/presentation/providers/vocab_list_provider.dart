import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';

import '../../data/database/app_database.dart';
import 'database_provider.dart';

final vocabByLevelProvider = FutureProvider.family<List<VocabularyEntry>, String>(
  (ref, level) => ref.watch(databaseProvider).getVocabByLevel(level),
);

final knownVocabIdsProvider = StreamProvider<Set<int>>(
  (ref) => ref.watch(databaseProvider).watchKnownVocabIds(),
);

final vocabSrsCardsProvider = StreamProvider<Map<int, Card>>(
  (ref) => ref.watch(databaseProvider).watchAllSrsCardsForType('vocabulary'),
);
