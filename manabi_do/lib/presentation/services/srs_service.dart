import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating, Scheduler;

import '../../data/database/app_database.dart';
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
  final Ref _ref;

  const SrsService(this._ref);

  Future<Card?> getCard(String type, int id) =>
      _ref.read(databaseProvider).getSrsCard(type, id);

  Future<void> resetCard(String type, int id) =>
      _ref.read(databaseProvider).resetSrsCard(type, id);

  Future<void> resetAll() => _ref.read(databaseProvider).resetAllProgress();

  Future<void> seedFakeReviews() =>
      _ref.read(databaseProvider).seedFakeReviews();

  Future<void> review(
    String srsType,
    int id,
    Card? existingCard,
    Rating rating,
  ) => _ref
      .read(databaseProvider)
      .upsertSrsCard(srsType, id, applyRating(existingCard, rating));
}

final srsServiceProvider = Provider((ref) => SrsService(ref));
