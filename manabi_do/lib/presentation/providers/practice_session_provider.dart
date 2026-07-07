// Receives a pre-built item queue and tracks progress through it: current item,
// got-it/not-yet score, and SRS result written to DB on each answer.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating, Scheduler;

import '../screens/practice/practice_item.dart';
import 'database_provider.dart';

final practiceSessionProvider =
    NotifierProvider.autoDispose<PracticeSessionNotifier, PracticeSessionState>(
      PracticeSessionNotifier.new,
    );

class PracticeSessionState {
  final List<PracticeItem>? queue;
  final List<PracticeItem>? completedQueue;
  final int index;
  final int gotIt;
  final int notYet;
  final bool done;
  final bool isRetry;
  final DateTime startedAt;

  const PracticeSessionState({
    this.queue,
    this.completedQueue,
    this.index = 0,
    this.gotIt = 0,
    this.notYet = 0,
    this.done = false,
    this.isRetry = false,
    required this.startedAt,
  });

  bool get isLoading => queue == null;

  PracticeItem? get currentItem =>
      queue != null && !done && index < queue!.length ? queue![index] : null;

  String get formattedDuration {
    final d = DateTime.now().difference(startedAt);
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return m > 0 ? '${m}m ${s}s' : '${s}s';
  }

  PracticeSessionState copyWith({
    List<PracticeItem>? queue,
    List<PracticeItem>? completedQueue,
    int? index,
    int? gotIt,
    int? notYet,
    bool? done,
    bool? isRetry,
    DateTime? startedAt,
  }) {
    return PracticeSessionState(
      queue: queue ?? this.queue,
      completedQueue: completedQueue ?? this.completedQueue,
      index: index ?? this.index,
      gotIt: gotIt ?? this.gotIt,
      notYet: notYet ?? this.notYet,
      done: done ?? this.done,
      isRetry: isRetry ?? this.isRetry,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}

class PracticeSessionNotifier extends Notifier<PracticeSessionState> {
  @override
  PracticeSessionState build() =>
      PracticeSessionState(startedAt: DateTime.now());

  void init(List<PracticeItem> items) {
    state = PracticeSessionState(
      queue: items,
      done: items.isEmpty,
      startedAt: DateTime.now(),
    );
  }

  Future<void> answer(Rating rating, {required bool persistSrs}) async {
    final s = state;
    final item = s.currentItem;
    if (item == null) return;

    if (persistSrs && !s.isRetry) {
      final card =
          item.card ??
          Card(
            cardId: DateTime.now().millisecondsSinceEpoch,
            due: DateTime.now(),
          );
      final result = Scheduler().reviewCard(card, rating);
      await ref
          .read(databaseProvider)
          .upsertSrsCard(item.srsType, item.id, result.card);
    }

    final isLast = s.index + 1 >= s.queue!.length;
    state = s.copyWith(
      gotIt: rating != Rating.again ? s.gotIt + 1 : s.gotIt,
      notYet: rating == Rating.again ? s.notYet + 1 : s.notYet,
      completedQueue: isLast ? List.from(s.queue!) : s.completedQueue,
      done: isLast,
      index: isLast ? s.index : s.index + 1,
    );
  }

  void retry() {
    final s = state;
    state = PracticeSessionState(
      queue: List.from(s.completedQueue!),
      done: false,
      isRetry: true,
      startedAt: DateTime.now(),
    );
  }
}
