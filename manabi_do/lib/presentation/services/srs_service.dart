import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating, Scheduler;

import '../providers/database_provider.dart';

// Pure scheduling: applies a rating to an existing card (or creates a new one)
// and returns the updated card. No DB access, safe to call from anywhere.
Card applyRating(Card? existing, Rating rating) {
  final card =
      existing ??
      Card(cardId: DateTime.now().millisecondsSinceEpoch, due: DateTime.now());
  return Scheduler().reviewCard(card, rating).card;
}

class SrsService {
  const SrsService();

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
  ) => ref
      .read(databaseProvider)
      .upsertSrsCard(srsType, id, applyRating(existingCard, rating));
}

const srsService = SrsService();
