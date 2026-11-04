import 'package:fsrs/fsrs.dart';

/// How far out [rating] would push [card].
///
/// Null for a card that has never been reviewed, where there is no interval to
/// preview yet.
Duration? srsIntervalPreview(Card? card, Rating rating) {
  if (card == null) return null;
  final Card preview = Scheduler().reviewCard(card, rating).card;
  return preview.due.difference(DateTime.now());
}
