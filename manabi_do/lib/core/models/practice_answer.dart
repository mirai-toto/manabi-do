import 'package:fsrs/fsrs.dart' show Card, Rating;

import '../../l10n/app_localizations.dart';

/// A label resolved against the active translations.
///
/// Held as a function rather than a finished string for two reasons: building a
/// queue happens in a service with no `BuildContext`, and the wording then
/// follows a locale change instead of freezing at whatever was active when the
/// session started.
typedef L10nText = String Function(AppLocalizations l);

/// Reports an answer, plus whatever the exercise knows about how it went.
///
/// [given] is what the user picked, for exercises that offer choices.
/// [mistakes] is the wrong-stroke count, for writing. Both are left out by
/// exercises that have nothing to say, which is why they are optional: a plain
/// `void Function(Rating)` is still assignable here.
typedef AnswerCallback =
    void Function(Rating rating, {String? given, int? mistakes});

/// What the session review needs to redraw an item after it has been answered.
///
/// Captured when the queue is built, because the widget that asked the question
/// is long gone by the time the review is opened. Plain strings rather than the
/// source rows: the review only ever renders them.
class PracticeSummary {
  /// The item itself, in Japanese. The review row's first line.
  final String item;

  /// Reading, when it differs from [item]. Null for kana and kana-only words.
  final String? reading;

  /// The question, worded as the exercise worded it.
  final L10nText question;

  /// The correct answer, worded as the exercise worded it.
  final String answer;

  /// What kind of exercise this was, for the row's third line.
  final L10nText kindLabel;

  /// True when the user graded themselves, which is what decides whether the
  /// review offers all four ratings or just correct and incorrect.
  final bool selfAssessed;

  /// The sentence a cloze was drawn from, with the answer left in, and its
  /// translation. Null for every other exercise.
  final String? sentence;
  final String? sentenceTranslation;

  const PracticeSummary({
    required this.item,
    required this.question,
    required this.answer,
    required this.kindLabel,
    required this.selfAssessed,
    this.reading,
    this.sentence,
    this.sentenceTranslation,
  });
}

/// One answered item, kept so the session review can show it and change it.
///
/// Holds the SRS identity rather than the queue entry it came from: the review
/// renders and re-grades, it never rebuilds the exercise.
class SessionAnswer {
  final String srsType;
  final int id;

  /// The card as it stood *before* this session touched it. Re-grading applies
  /// the new rating to this, so a second grade overwrites the first instead of
  /// stacking on top of it.
  final Card? card;

  final PracticeSummary summary;
  final Rating rating;

  /// What the user picked. Null when the exercise was self-assessed, where
  /// there is no answer to show beyond the grade.
  final String? given;

  /// Wrong strokes, for a writing item.
  final int? mistakes;

  const SessionAnswer({
    required this.srsType,
    required this.id,
    required this.card,
    required this.summary,
    required this.rating,
    this.given,
    this.mistakes,
  });

  bool get isCorrect => rating != Rating.again;

  SessionAnswer copyWith({Rating? rating}) => SessionAnswer(
    srsType: srsType,
    id: id,
    card: card,
    summary: summary,
    rating: rating ?? this.rating,
    given: given,
    mistakes: mistakes,
  );
}
