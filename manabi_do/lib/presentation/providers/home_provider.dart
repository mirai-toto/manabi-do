import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/srs_settings_provider.dart';
import 'database_provider.dart';

/// Drives tab selection across ShellScreen and HomeScreen.
final selectedTabProvider = NotifierProvider<_SelectedTabNotifier, int>(
  _SelectedTabNotifier.new,
);

class _SelectedTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int index) {
    if (state != index) _clearTab(index);
    state = index;
  }

  void _clearTab(int index) {
    switch (index) {
      case 1:
        ref.read(kanjiSelectedLevelProvider.notifier).clear();
        ref.read(kanjiSelectedGroupProvider.notifier).clear();
      case 2:
        ref.read(vocabSelectedLevelProvider.notifier).clear();
        ref.read(vocabSelectedGroupProvider.notifier).clear();
      case 3:
        ref.read(grammarSelectedLevelProvider.notifier).clear();
    }
  }
}

final kanaDueCountProvider = StreamProvider<int>(
  (ref) => ref.watch(databaseProvider).watchKanaDueCount(),
);

final kanjiDueCountProvider = StreamProvider<int>(
  (ref) => ref.watch(databaseProvider).watchKanjiDueCount(),
);

final vocabDueCountProvider = StreamProvider<int>(
  (ref) => ref.watch(databaseProvider).watchVocabDueCount(),
);

final streakDaysProvider = StreamProvider<int>(
  (ref) => ref.watch(databaseProvider).watchStreakDays(),
);

final kanaProgressProvider = StreamProvider<({int known, int seen})>(
  (ref) => ref.watch(databaseProvider).watchKanaProgress(),
);

final kanjiProgressProvider = StreamProvider<({int known, int seen})>(
  (ref) => ref.watch(databaseProvider).watchKanjiProgress(),
);

final vocabProgressProvider = StreamProvider<({int known, int seen})>(
  (ref) => ref.watch(databaseProvider).watchVocabProgress(),
);

/// Which days of the current week (Monday-first, 7 entries) had reviews.
final weekActivityProvider = StreamProvider<List<bool>>(
  (ref) => ref.watch(databaseProvider).watchReviewDates().map((dates) {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    return List.generate(
      7,
      (i) =>
          dates.contains(DateTime(monday.year, monday.month, monday.day + i)),
    );
  }),
);

final kanaNewCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  final limit =
      ref.watch(srsSettingsProvider).asData?.value.newCharactersPerDay ?? 10;
  return db.watchKanaNewCount(newCardLimit: limit);
});

final kanjiNewCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  final limit =
      ref.watch(srsSettingsProvider).asData?.value.newCharactersPerDay ?? 10;
  return db.watchKanjiNewCount(newCardLimit: limit);
});

final practiceActiveProvider = NotifierProvider<PracticeActiveNotifier, bool>(
  PracticeActiveNotifier.new,
);

class PracticeActiveNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setActive(bool value) => state = value;
}

final vocabNewCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  final limit =
      ref.watch(srsSettingsProvider).asData?.value.newVocabPerDay ?? 10;
  return db.watchVocabNewCount(newCardLimit: limit);
});

final kanjiSelectedLevelProvider = NotifierProvider<_LevelNotifier, String?>(
  _LevelNotifier.new,
);
final vocabSelectedLevelProvider = NotifierProvider<_LevelNotifier, String?>(
  _LevelNotifier.new,
);
final grammarSelectedLevelProvider = NotifierProvider<_LevelNotifier, String?>(
  _LevelNotifier.new,
);

class _LevelNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void select(String level) => state = level;
  void clear() => state = null;
}

final kanjiSelectedGroupProvider = NotifierProvider<_GroupNotifier, int?>(
  _GroupNotifier.new,
);

final vocabSelectedGroupProvider = NotifierProvider<_GroupNotifier, int?>(
  _GroupNotifier.new,
);

class _GroupNotifier extends Notifier<int?> {
  @override
  int? build() => null;
  void select(int group) => state = group;
  void clear() => state = null;
}
