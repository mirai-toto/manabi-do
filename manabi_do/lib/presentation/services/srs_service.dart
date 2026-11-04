import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating, Scheduler;

import '../../core/providers/review_log_provider.dart';
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

  Future<void> resetCard(String type, int id) =>
      _ref.read(databaseProvider).resetSrsCard(type, id);

  Future<void> resetAll() async {
    await _ref.read(databaseProvider).resetAllProgress();
    await _ref.read(reviewLogProvider.notifier).clear();
  }
}

final srsServiceProvider = Provider<SrsService>((ref) => SrsService(ref));
