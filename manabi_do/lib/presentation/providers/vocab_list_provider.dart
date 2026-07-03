import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';

import '../../core/providers/srs_settings_provider.dart';
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
