import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import 'database_provider.dart';

final n5KanjiProvider = StreamProvider<List<Kanji>>((ref) {
  return ref.watch(databaseProvider).watchKanjiByLevel('N5');
});

final knownKanjiIdsProvider = StreamProvider<Set<int>>((ref) {
  return ref.watch(databaseProvider).watchKnownKanjiIds();
});
