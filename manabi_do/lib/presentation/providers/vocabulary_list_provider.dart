import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';

import '../../core/providers/srs_settings_provider.dart';
import '../../core/srs/srs_level.dart';
import '../../core/theme/vocabulary_level.dart';
import '../../data/database/app_database.dart';
import '../services/search_service.dart';
import '../services/srs_queue_service.dart';
import 'database_provider.dart';

const kVocabularyGroupSize = 30;

final vocabularyByLevelProvider =
    FutureProvider.family<List<VocabularyEntry>, int>(
      (ref, level) => ref.watch(databaseProvider).getVocabularyByLevel(level),
    );

final vocabularySearchProvider =
    FutureProvider.family<List<VocabularyEntry>, SearchQuery<int>>(
      (ref, q) =>
          ref.read(searchServiceProvider).vocabulary(q.text, levels: q.filters),
    );

/// What each study group buys, as a share of running Japanese.
final coverageGroupsProvider = FutureProvider<List<CoverageGroup>>(
  (ref) => ref.watch(databaseProvider).getCoverageGroups(),
);

/// Level → the share of running Japanese that level adds. Null when unknown.
///
/// Null covers both "still loading" and "the table is empty", and they are
/// deliberately the same answer. A database migrated forward without its new
/// asset has no group rows, and reporting 0% there would be a claim that the
/// learner can read nothing rather than an admission that we do not know.
final vocabularyLevelShareProvider = Provider<Map<int, double>?>((ref) {
  final groups = ref.watch(coverageGroupsProvider).asData?.value;
  if (groups == null || groups.isEmpty) return null;
  final byLevel = <int, double>{};
  for (final group in groups) {
    byLevel[group.vocabularyLevel] =
        (byLevel[group.vocabularyLevel] ?? 0) + group.corpusShare;
  }
  return byLevel;
});

/// Level → the share of running Japanese a learner can read once that level and
/// every level before it is finished. Null while loading.
final vocabularyLevelReachedProvider = Provider<Map<int, double>?>((ref) {
  final shares = ref.watch(vocabularyLevelShareProvider);
  if (shares == null) return null;
  final reached = <int, double>{};
  var running = 0.0;
  for (final level in kAllVocabularyLevels) {
    running += shares[level] ?? 0;
    reached[level] = running;
  }
  return reached;
});

/// (level, group) → the share of running Japanese that one group of thirty
/// words adds. Null while loading.
///
/// A group is the finest grain any corpus figure is published at: BCCWJ is free
/// for research and education and handled case by case otherwise, so no
/// per-word count or rank ships, and a share of thirty words together cannot be
/// turned back into one.
final groupShareProvider = Provider<Map<(int, int), double>?>((ref) {
  final groups = ref.watch(coverageGroupsProvider).asData?.value;
  if (groups == null || groups.isEmpty) return null;
  return {
    for (final group in groups)
      (group.vocabularyLevel, group.groupIndex): group.corpusShare,
  };
});

/// What a learner can read right now: every group's share, scaled by how much
/// of that group they have learned. Null while loading.
///
/// Scaled by the finished fraction of a group because a share is only published
/// per group. Inside a group the words are treated as equal, which is close
/// enough: a group is thirty adjacent words on the frequency curve.
final coverageReachedProvider = Provider<double?>((ref) {
  final shares = ref.watch(groupShareProvider);
  if (shares == null) return null;
  final srsCards = ref.watch(vocabularySrsCardsProvider).asData?.value;
  if (srsCards == null) return null;

  var reached = 0.0;
  for (final level in kAllVocabularyLevels) {
    final entries = ref.watch(vocabularyByLevelProvider(level)).asData?.value;
    if (entries == null) return null;
    final learnedPerGroup = <int, int>{};
    final sizePerGroup = <int, int>{};
    for (final entry in entries) {
      sizePerGroup[entry.groupIndex] =
          (sizePerGroup[entry.groupIndex] ?? 0) + 1;
      final level = srsLevel(srsCards[entry.id]);
      if (level != SrsLevel.newCard && level != SrsLevel.learning) {
        learnedPerGroup[entry.groupIndex] =
            (learnedPerGroup[entry.groupIndex] ?? 0) + 1;
      }
    }
    for (final group in sizePerGroup.keys) {
      final share = shares[(level, group)] ?? 0;
      final size = sizePerGroup[group]!;
      reached += share * (learnedPerGroup[group] ?? 0) / size;
    }
  }
  return reached;
});

final vocabularySrsCardsProvider = StreamProvider<Map<int, Card>>(
  (ref) => ref.watch(databaseProvider).watchAllSrsCardsForType('vocabulary'),
);

/// Total vocabulary count across every vocabulary level; null while any level is
/// still loading.
final vocabularyTotalCountProvider = Provider<int?>((ref) {
  var sum = 0;
  for (final level in kAllVocabularyLevels) {
    final data = ref.watch(vocabularyByLevelProvider(level)).asData?.value;
    if (data == null) return null;
    sum += data.length;
  }
  return sum;
});

/// How many vocabulary entries in the given group have been learned (past new/learning).
final vocabularyGroupLearnedCountProvider =
    Provider.family<int, ({int level, int groupIndex})>((ref, args) {
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
    FutureProvider.family<(int, int), ({int level, int groupIndex})>((
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
