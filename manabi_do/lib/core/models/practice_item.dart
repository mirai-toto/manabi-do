import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating;

import 'practice_answer.dart';
import 'practice_question.dart';

export 'practice_answer.dart';

/// One entry in a practice queue: what to ask, and what the SRS should do with
/// the answer.
class PracticeItem {
  final int id;
  final String srsType;
  final Card? card;

  /// What to ask, as data. `PracticeQuestionBody` turns it into a widget.
  final PracticeQuestion question;

  final PracticeSummary summary;

  const PracticeItem({
    required this.id,
    required this.srsType,
    required this.card,
    required this.question,
    required this.summary,
  });

  /// The answer record this item becomes once it has been graded.
  SessionAnswer answered(Rating rating, {String? given, int? mistakes}) =>
      SessionAnswer(
        srsType: srsType,
        id: id,
        card: card,
        summary: summary,
        rating: rating,
        given: given,
        mistakes: mistakes,
      );
}

/// Builds the queue for a session. Takes the screen's `ref` because the
/// services behind it read settings and the database through providers.
typedef LoadQueue = Future<List<PracticeItem>> Function(WidgetRef ref);
