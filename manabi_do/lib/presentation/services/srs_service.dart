import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating, Scheduler;

import '../providers/database_provider.dart';

class SrsService {
  const SrsService();

  static final _scheduler = Scheduler();

  Future<Card?> getCard(WidgetRef ref, String type, int id) =>
      ref.read(databaseProvider).getSrsCard(type, id);

  Future<void> resetCard(WidgetRef ref, String type, int id) =>
      ref.read(databaseProvider).resetSrsCard(type, id);

  Future<void> resetAll(WidgetRef ref) =>
      ref.read(databaseProvider).resetAllProgress();

  Future<void> seedFakeReviews(WidgetRef ref) =>
      ref.read(databaseProvider).seedFakeReviews();

  Future<void> review(
    WidgetRef ref,
    String srsType,
    int id,
    Card? existingCard,
    Rating rating,
  ) {
    final card =
        existingCard ??
        Card(
          cardId: DateTime.now().millisecondsSinceEpoch,
          due: DateTime.now(),
        );
    final result = _scheduler.reviewCard(card, rating);
    return ref.read(databaseProvider).upsertSrsCard(srsType, id, result.card);
  }
}

const srsService = SrsService();
