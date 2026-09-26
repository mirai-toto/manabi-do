import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';

import '../../core/providers/srs_settings_provider.dart';
import '../../core/srs/srs_level.dart';
import '../../data/database/app_database.dart';
import '../services/search_service.dart';
import '../services/srs_queue_service.dart';
import 'database_provider.dart';

const kVocabularyGroupSize = 30;

final vocabularyByLevelProvider =
    FutureProvider.family<List<VocabularyEntry>, String>(
      (ref, level) => ref.watch(databaseProvider).getVocabularyByLevel(level),
    );

final vocabularySearchProvider =
    FutureProvider.family<List<VocabularyEntry>, String>(
      (ref, query) => ref.read(searchServiceProvider).vocabulary(query),
    );

final vocabularySrsCardsProvider = StreamProvider<Map<int, Card>>(
  (ref) => ref.watch(databaseProvider).watchAllSrsCardsForType('vocabulary'),
);

/// Total vocabulary count across all JLPT levels; null while any level is still loading.
const _allLevels = ['N5', 'N4', 'N3', 'N2', 'N1'];

final vocabularyTotalCountProvider = Provider<int?>((ref) {
  var sum = 0;
  for (final lvl in _allLevels) {
    final data = ref.watch(vocabularyByLevelProvider(lvl)).asData?.value;
    if (data == null) return null;
    sum += data.length;
  }
  return sum;
});

/// How many vocabulary entries in the given group have been learned (past new/learning).
final vocabularyGroupLearnedCountProvider =
    Provider.family<int, ({String level, int groupIndex})>((ref, args) {
      final entries =
          ref
              .watch(vocabularyByLevelProvider(args.level))
              .asData
              ?.value
              .skip(args.groupIndex * kVocabularyGroupSize)
              .take(kVocabularyGroupSize)
              .toList() ??
          [];
      final srsCards =
          ref.watch(vocabularySrsCardsProvider).asData?.value ?? {};
      return entries.where((e) {
        final lvl = srsLevel(srsCards[e.id]);
        return lvl != SrsLevel.newCard && lvl != SrsLevel.learning;
      }).length;
    });

/// Returns (reviewCount, newCount) for the given vocabulary group.
final vocabularyGroupSrsCountProvider =
    FutureProvider.family<(int, int), ({String level, int groupIndex})>((
      ref,
      args,
    ) async {
      final all = await ref.read(vocabularyByLevelProvider(args.level).future);
      final groupIds = all
          .skip(args.groupIndex * kVocabularyGroupSize)
          .take(kVocabularyGroupSize)
          .map((e) => e.id)
          .toSet();
      final settings = await ref.read(srsSettingsProvider.future);
      final session = await ref
          .read(srsQueueServiceProvider)
          .vocabulary(args.level, newCardLimit: settings.newVocabularyPerDay);
      final group = session.where((p) => groupIds.contains(p.$1.id)).toList();
      return (
        group.where((p) => p.$2 != null).length,
        group.where((p) => p.$2 == null).length,
      );
    });
