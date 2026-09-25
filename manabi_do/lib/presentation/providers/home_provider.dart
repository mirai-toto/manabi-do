import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/srs_settings_provider.dart';
import '../services/dashboard_service.dart';

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
        ref.read(vocabularySelectedLevelProvider.notifier).clear();
        ref.read(vocabularySelectedGroupProvider.notifier).clear();
      case 3:
        ref.read(grammarSelectedLevelProvider.notifier).clear();
    }
  }
}

final kanaDueCountProvider = StreamProvider<int>(
  (ref) => ref.watch(dashboardServiceProvider).kanaDueCount(),
);

final kanjiDueCountProvider = StreamProvider<int>(
  (ref) => ref.watch(dashboardServiceProvider).kanjiDueCount(),
);

final vocabularyDueCountProvider = StreamProvider<int>(
  (ref) => ref.watch(dashboardServiceProvider).vocabularyDueCount(),
);

final streakDaysProvider = StreamProvider<int>(
  (ref) => ref.watch(dashboardServiceProvider).streakDays(),
);

final kanaProgressProvider = StreamProvider<({int known, int seen})>(
  (ref) => ref.watch(dashboardServiceProvider).kanaProgress(),
);

final kanjiProgressProvider = StreamProvider<({int known, int seen})>(
  (ref) => ref.watch(dashboardServiceProvider).kanjiProgress(),
);

final vocabularyProgressProvider = StreamProvider<({int known, int seen})>(
  (ref) => ref.watch(dashboardServiceProvider).vocabularyProgress(),
);

/// Which days of the current week (Monday-first, 7 entries) had reviews.
final weekActivityProvider = StreamProvider<List<bool>>(
  (ref) => ref.watch(dashboardServiceProvider).weekActivity(),
);

final kanaNewCountProvider = StreamProvider<int>((ref) {
  final limit =
      ref.watch(srsSettingsProvider).asData?.value.newCharactersPerDay ?? 10;
  return ref.watch(dashboardServiceProvider).kanaNewCount(newCardLimit: limit);
});

final kanjiNewCountProvider = StreamProvider<int>((ref) {
  final limit =
      ref.watch(srsSettingsProvider).asData?.value.newCharactersPerDay ?? 10;
  return ref.watch(dashboardServiceProvider).kanjiNewCount(newCardLimit: limit);
});

final practiceActiveProvider = NotifierProvider<PracticeActiveNotifier, bool>(
  PracticeActiveNotifier.new,
);

class PracticeActiveNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setActive(bool value) => state = value;
}

final vocabularyNewCountProvider = StreamProvider<int>((ref) {
  final limit =
      ref.watch(srsSettingsProvider).asData?.value.newVocabularyPerDay ?? 10;
  return ref
      .watch(dashboardServiceProvider)
      .vocabularyNewCount(newCardLimit: limit);
});

final kanjiSelectedLevelProvider = NotifierProvider<_LevelNotifier, String?>(
  _LevelNotifier.new,
);
final vocabularySelectedLevelProvider =
    NotifierProvider<_LevelNotifier, String?>(_LevelNotifier.new);
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

final vocabularySelectedGroupProvider = NotifierProvider<_GroupNotifier, int?>(
  _GroupNotifier.new,
);

class _GroupNotifier extends Notifier<int?> {
  @override
  int? build() => null;
  void select(int group) => state = group;
  void clear() => state = null;
}
