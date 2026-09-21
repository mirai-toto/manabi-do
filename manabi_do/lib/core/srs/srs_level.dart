import 'package:flutter/material.dart' hide Card, State;
import 'package:fsrs/fsrs.dart';

import '../theme/jlpt_level.dart';

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

extension SrsLevelColor on SrsLevel {
  /// Mastery reuses the JLPT ramp, read backwards: an item you are still
  /// learning is as red as N1, one you have mastered is as green as N5. Sharing
  /// the ramp keeps the two scales consistent and leaves one palette to
  /// maintain rather than two.
  Color get accent => switch (this) {
    SrsLevel.newCard => Colors.transparent,
    SrsLevel.learning => levelColor('N1'),
    SrsLevel.apprentice => levelColor('N2'),
    SrsLevel.familiar => levelColor('N3'),
    SrsLevel.mastered => levelColor('N4'),
    SrsLevel.expert => levelColor('N5'),
  };
}
