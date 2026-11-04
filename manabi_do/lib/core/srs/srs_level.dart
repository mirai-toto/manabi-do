import 'package:fsrs/fsrs.dart';

enum SrsLevel { newCard, learning, apprentice, familiar, mastered, expert }

SrsLevel srsLevel(Card? card) {
  if (card == null) return SrsLevel.newCard;
  if (card.state != State.review) return SrsLevel.learning;
  final s = card.stability ?? 0;
  if (s < 7) return SrsLevel.apprentice;
  if (s < 21) return SrsLevel.familiar;
  if (s < 90) return SrsLevel.mastered;
  return SrsLevel.expert;
}

/// A card counts as known once it holds for at least a week (familiar+).
bool isSrsKnown(Card? card) => switch (srsLevel(card)) {
  SrsLevel.familiar || SrsLevel.mastered || SrsLevel.expert => true,
  _ => false,
};
