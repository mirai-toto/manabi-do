import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';

import '../../core/providers/srs_settings_provider.dart';
import '../../core/srs/srs_level.dart';
import '../../data/database/app_database.dart';
import 'database_provider.dart';

const kVocabGroupSize = 30;

final vocabByLevelProvider =
    FutureProvider.family<List<VocabularyEntry>, String>(
      (ref, level) => ref.watch(databaseProvider).getVocabByLevel(level),
    );

final vocabSrsCardsProvider = StreamProvider<Map<int, Card>>(
  (ref) => ref.watch(databaseProvider).watchAllSrsCardsForType('vocabulary'),
);

/// Total vocab count across all JLPT levels; null while any level is still loading.
const _allLevels = ['N5', 'N4', 'N3', 'N2', 'N1'];

final vocabTotalCountProvider = Provider<int?>((ref) {
  var sum = 0;
  for (final lvl in _allLevels) {
    final data = ref.watch(vocabByLevelProvider(lvl)).asData?.value;
    if (data == null) return null;
    sum += data.length;
  }
  return sum;
});

/// How many vocab entries in the given group have been learned (past new/learning).
final vocabGroupLearnedCountProvider =
    Provider.family<int, ({String level, int groupIndex})>((ref, args) {
      final entries =
          ref
              .watch(vocabByLevelProvider(args.level))
              .asData
              ?.value
              .skip(args.groupIndex * kVocabGroupSize)
              .take(kVocabGroupSize)
              .toList() ??
          [];
      final srsCards = ref.watch(vocabSrsCardsProvider).asData?.value ?? {};
      return entries.where((e) {
        final lvl = srsLevel(srsCards[e.id]);
        return lvl != SrsLevel.newCard && lvl != SrsLevel.learning;
      }).length;
    });

/// Returns (reviewCount, newCount) for the given vocab group.
final vocabGroupSrsCountProvider =
    FutureProvider.family<(int, int), ({String level, int groupIndex})>((
      ref,
      args,
    ) async {
      final all = await ref.read(vocabByLevelProvider(args.level).future);
      final groupIds = all
          .skip(args.groupIndex * kVocabGroupSize)
          .take(kVocabGroupSize)
          .map((e) => e.id)
          .toSet();
      final settings = await ref.read(srsSettingsProvider.future);
      final session = await ref
          .read(databaseProvider)
          .getVocabSrsSession(
            args.level,
            newCardLimit: settings.newVocabPerDay,
          );
      final group = session.where((p) => groupIds.contains(p.$1.id)).toList();
      return (
        group.where((p) => p.$2 != null).length,
        group.where((p) => p.$2 == null).length,
      );
    });
