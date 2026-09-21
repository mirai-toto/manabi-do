import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating;

import '../../../core/models/flashcard_settings.dart';
import '../../../core/models/mcq_settings.dart';
import '../../../core/models/sentence_settings.dart';

/// The settings a practice body renders against.
///
/// Passed in on every build rather than captured when the queue is built, so
/// changes made in the in-session settings sheet apply to the card on screen.
class PracticeBodySettings {
  final McqSettings mcq;
  final FlashcardSettings flashcard;
  final SentenceSettings sentence;

  /// The review session's auto-advance switch. Covers the whole queue, unlike
  /// the per-exercise switches free practice keeps in [mcq] and [sentence].
  /// False outside a review, where those per-exercise ones apply instead.
  final bool autoAdvance;

  const PracticeBodySettings({
    required this.mcq,
    required this.flashcard,
    required this.sentence,
    required this.autoAdvance,
  });
}

typedef PracticeBodyBuilder =
    Widget Function(
      int index,
      int total,
      void Function(Rating) onAnswer,
      PracticeBodySettings settings,
    );

class PracticeItem {
  final int id;
  final String srsType;
  final Card? card;
  final PracticeBodyBuilder buildBody;

  const PracticeItem({
    required this.id,
    required this.srsType,
    required this.card,
    required this.buildBody,
  });
}

typedef LoadQueue = Future<List<PracticeItem>> Function(WidgetRef ref);
