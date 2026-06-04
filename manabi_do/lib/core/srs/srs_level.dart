import 'package:flutter/material.dart' hide Card, State;
import 'package:fsrs/fsrs.dart';

import '../theme/app_tokens.dart';

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
  Color accent(AppTokens t) {
    if (this == SrsLevel.newCard) return Colors.transparent;
    final step = (index - 1) / (SrsLevel.values.length - 2);
    return Color.lerp(t.error, t.primary, step)!;
  }
}
