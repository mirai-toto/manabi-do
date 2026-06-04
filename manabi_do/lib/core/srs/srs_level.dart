import 'package:flutter/material.dart' hide Card, State;
import 'package:fsrs/fsrs.dart';

enum SrsLevel { newCard, learning, familiar, mastered }

SrsLevel srsLevel(Card? card) {
  if (card == null) return SrsLevel.newCard;
  if (card.state != State.review) return SrsLevel.learning;
  if ((card.stability ?? 0) < 21) return SrsLevel.familiar;
  return SrsLevel.mastered;
}

extension SrsLevelColor on SrsLevel {
  Color accent(BuildContext context) => switch (this) {
    SrsLevel.newCard  => Colors.transparent,
    SrsLevel.learning => const Color(0xFFE87E04), // orange
    SrsLevel.familiar => const Color(0xFF4B7BF5), // blue
    SrsLevel.mastered => const Color(0xFF2E9E5B), // green
  };
}
