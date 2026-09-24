// Receives a pre-built item queue and tracks progress through it: current item,
// got-it/not-yet score, and SRS result written to DB on each answer.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Rating;

import '../../data/database/app_database.dart';
import '../screens/practice/practice_item.dart';
import '../services/srs_service.dart';
import 'database_provider.dart';

final practiceSessionProvider =
    NotifierProvider.autoDispose<PracticeSessionNotifier, PracticeSessionState>(
      PracticeSessionNotifier.new,
    );

class PracticeSessionState {
  final List<PracticeItem>? queue;
  final List<PracticeItem>? completedQueue;

  /// Everything answered so far, in the order it was answered. The session
  /// review reads this, and re-grading rewrites an entry in place.
  final List<SessionAnswer> answers;
  final int index;
  final bool done;
  final bool isRetry;
  final DateTime startedAt;

  const PracticeSessionState({
    this.queue,
    this.completedQueue,
    this.answers = const [],
    this.index = 0,
    this.done = false,
    this.isRetry = false,
    required this.startedAt,
  });

  bool get isLoading => queue == null;

  // Counted from [answers] rather than tracked alongside it, so re-grading
  // cannot leave the score disagreeing with the list it came from.
  int get gotIt => answers.where((a) => a.isCorrect).length;
  int get notYet => answers.length - gotIt;

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
    List<SessionAnswer>? answers,
    int? index,
    bool? done,
    bool? isRetry,
    DateTime? startedAt,
  }) {
    return PracticeSessionState(
      queue: queue ?? this.queue,
      completedQueue: completedQueue ?? this.completedQueue,
      answers: answers ?? this.answers,
      index: index ?? this.index,
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

  Future<void> answer(
    Rating rating, {
    required bool persistSrs,
    String? given,
    int? mistakes,
  }) async {
    final s = state;
    final item = s.currentItem;
    if (item == null) return;

    if (persistSrs && !s.isRetry) {
      await ref
          .read(databaseProvider)
          .upsertSrsCard(item.srsType, item.id, applyRating(item.card, rating));
    }

    final isLast = s.index + 1 >= s.queue!.length;
    state = s.copyWith(
      answers: [
        ...s.answers,
        item.answered(rating, given: given, mistakes: mistakes),
      ],
      completedQueue: isLast ? List.from(s.queue!) : s.completedQueue,
      done: isLast,
      index: isLast ? s.index : s.index + 1,
    );
  }

  /// Replaces the grade given to an already-answered item.
  ///
  /// The rating is re-applied to the card as it was *before* the session
  /// touched it, which [PracticeItem.card] still holds, so the result is the
  /// same as if this grade had been the first one. That makes the write an
  /// overwrite rather than a second review, and re-grading twice is harmless.
  Future<void> regrade(
    int answerIndex,
    Rating rating, {
    required bool persistSrs,
  }) async {
    final s = state;
    if (answerIndex < 0 || answerIndex >= s.answers.length) return;

    final answered = s.answers[answerIndex];
    if (answered.rating == rating) return;

    if (persistSrs && !s.isRetry) {
      await ref
          .read(databaseProvider)
          .upsertSrsCard(
            answered.srsType,
            answered.id,
            applyRating(answered.card, rating),
          );
    }

    state = s.copyWith(
      answers: [...s.answers]
        ..[answerIndex] = answered.copyWith(rating: rating),
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
