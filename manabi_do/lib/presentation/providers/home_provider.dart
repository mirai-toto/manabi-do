import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database_provider.dart';

/// Drives tab selection across ShellScreen and HomeScreen.
final selectedTabProvider = NotifierProvider<_SelectedTabNotifier, int>(_SelectedTabNotifier.new);

class _SelectedTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int index) => state = index;
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

final dueTodayCountProvider = StreamProvider<int>(
  (ref) => ref.watch(databaseProvider).watchDueTodayCount(),
);

final charactersDueCountProvider = StreamProvider<int>(
  (ref) => ref.watch(databaseProvider).watchCharactersDueCount(),
);

final vocabDueCountProvider = StreamProvider<int>(
  (ref) => ref.watch(databaseProvider).watchVocabDueCount(),
);
