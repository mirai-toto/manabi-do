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
  final limit = ref.watch(srsSettingsProvider).newCharactersPerDay;
  return ref.watch(dashboardServiceProvider).kanaNewCount(newCardLimit: limit);
});

final kanjiNewCountProvider = StreamProvider<int>((ref) {
  final limit = ref.watch(srsSettingsProvider).newCharactersPerDay;
  return ref.watch(dashboardServiceProvider).kanjiNewCount(newCardLimit: limit);
});

final practiceActiveProvider = NotifierProvider<PracticeActiveNotifier, bool>(
  PracticeActiveNotifier.new,
);

/// Whether a practice session is on screen, which hides the navigation bar.
///
/// Counted rather than set, because one session can replace another (the
/// summary's "Continue" opens today's session in its place): the outgoing
/// screen leaves after the incoming one has entered, and a plain flag would be
/// switched off under the new session.
class PracticeActiveNotifier extends Notifier<bool> {
  int _screens = 0;

  @override
  bool build() => false;

  void enter() => state = ++_screens > 0;

  void leave() => state = --_screens > 0;
}

final vocabularyNewCountProvider = StreamProvider<int>((ref) {
  final limit = ref.watch(srsSettingsProvider).newVocabularyPerDay;
  return ref
      .watch(dashboardServiceProvider)
      .vocabularyNewCount(newCardLimit: limit);
});

final kanjiSelectedLevelProvider =
    NotifierProvider<_SelectionNotifier<String>, String?>(
      _SelectionNotifier.new,
    );

/// The vocabulary level being browsed. A number, not a level code: vocabulary has
/// no JLPT level.
final vocabularySelectedLevelProvider =
    NotifierProvider<_SelectionNotifier<int>, int?>(_SelectionNotifier.new);
final grammarSelectedLevelProvider =
    NotifierProvider<_SelectionNotifier<String>, String?>(
      _SelectionNotifier.new,
    );

/// Which level or group a section has drilled into, or null for none.
///
/// Within-screen back navigation lives in a provider rather than a `PopScope`,
/// so the system back button and the in-app arrow run the same code.
class _SelectionNotifier<T> extends Notifier<T?> {
  @override
  T? build() => null;
  void select(T value) => state = value;
  void clear() => state = null;
}

final kanjiSelectedGroupProvider =
    NotifierProvider<_SelectionNotifier<int>, int?>(_SelectionNotifier.new);

final vocabularySelectedGroupProvider =
    NotifierProvider<_SelectionNotifier<int>, int?>(_SelectionNotifier.new);
