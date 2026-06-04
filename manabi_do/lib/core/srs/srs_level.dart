import 'package:flutter/material.dart' hide Card, State;
import 'package:fsrs/fsrs.dart';

enum SrsLevel { newCard, learning, apprentice, familiar, mastered, expert }

SrsLevel srsLevel(Card? card) {
  if (card == null) return SrsLevel.newCard;
  if (card.state != State.review) return SrsLevel.learning;
  final s = card.stability ?? 0;
  if (s < 7)  return SrsLevel.apprentice;
  if (s < 21) return SrsLevel.familiar;
  if (s < 90) return SrsLevel.mastered;
  return SrsLevel.expert;
}

extension SrsLevelColor on SrsLevel {
  Color get accent => switch (this) {
    SrsLevel.newCard    => Colors.transparent,
    SrsLevel.learning   => const Color(0xFFE87E04), // orange
    SrsLevel.apprentice => const Color(0xFF9B59D0), // purple
    SrsLevel.familiar   => const Color(0xFF4B7BF5), // blue
    SrsLevel.mastered   => const Color(0xFF0097A7), // teal
    SrsLevel.expert     => const Color(0xFF2E9E5B), // green
  };
}
