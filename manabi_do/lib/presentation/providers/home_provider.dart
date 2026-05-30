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

final totalKanjiProvider = FutureProvider<int>(
  (ref) => ref.read(databaseProvider).countTotalKanji(),
);

final totalVocabProvider = FutureProvider<int>(
  (ref) => ref.read(databaseProvider).countTotalVocab(),
);

final totalKanaProvider = FutureProvider<int>(
  (ref) => ref.read(databaseProvider).getKanaData().then((d) => d.total),
);

final charactersDueCountProvider = StreamProvider<int>(
  (ref) => ref.watch(databaseProvider).watchCharactersDueCount(),
);

final vocabDueCountProvider = StreamProvider<int>(
  (ref) => ref.watch(databaseProvider).watchVocabDueCount(),
);

final streakDaysProvider = StreamProvider<int>(
  (ref) => ref.watch(databaseProvider).watchStreakDays(),
);

final charactersNewCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  final limit =
      ref.watch(srsSettingsProvider).asData?.value.newCharactersPerDay ?? 10;
  return db.watchCharactersNewCount(newCardLimit: limit);
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
