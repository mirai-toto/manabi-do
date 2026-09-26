import 'mcq_option.dart';
import 'practice_answer.dart';
import '../../data/database/app_database.dart';
import '../../data/grammar/grammar_models.dart';

/// What a practice item asks, as data.
///
/// A session service decides *what* to ask; `PracticeQuestionBody` decides how
/// it looks. Keeping the two apart is what lets a queue be built — and checked
/// — without a widget tree, and it is why nothing in this file imports Flutter.
///
/// Anything that changes while the card is on screen is deliberately absent:
/// the position in the queue, the answer callback and the settings all arrive
/// at build time instead.
sealed class PracticeQuestion {
  /// The JLPT level whose colour this question is drawn in. Null means the
  /// session's own colour, which is what grammar and writing use.
  final String? level;

  /// Free practice: nothing is written back to the SRS, and the per-exercise
  /// auto-advance switches apply instead of the session-wide one.
  final bool isFreeMode;

  /// The kanji whose detail screen the "more" affordance opens, when there is
  /// one to open.
  final int? kanjiDetailId;

  const PracticeQuestion({
    this.level,
    this.isFreeMode = false,
    this.kanjiDetailId,
  });
}

/// Show a prompt, reveal the answer, let the learner grade themselves.
final class FlashcardQuestion extends PracticeQuestion {
  final String japanese;

  /// Reading, when it differs from [japanese].
  final String? label;
  final String answer;

  /// Ask for the Japanese given the meaning, rather than the other way round.
  final bool isReversed;

  /// Grammar flashcards carry a worked example and their own wording.
  final GrammarExample? example;
  final String locale;
  final String? questionOverride;

  const FlashcardQuestion({
    required this.japanese,
    required this.answer,
    this.label,
    this.isReversed = false,
    this.example,
    this.locale = 'en',
    this.questionOverride,
    super.level,
    super.isFreeMode,
    super.kanjiDetailId,
  });
}

/// Pick the right answer from a short list.
final class McqQuestion extends PracticeQuestion {
  final L10nText prompt;
  final String? japanesePrompt;
  final String? japaneseReading;
  final List<McqOption> options;
  final int correctIndex;

  /// Two columns of short Japanese choices rather than one column of prose.
  final bool compactGrid;

  const McqQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    this.japanesePrompt,
    this.japaneseReading,
    this.compactGrid = false,
    super.level,
    super.isFreeMode,
    super.kanjiDetailId,
  });
}

/// Write the kanji from its meaning.
final class DrawingQuestion extends PracticeQuestion {
  final Kanji kanji;
  final String meaning;

  const DrawingQuestion({
    required this.kanji,
    required this.meaning,
    super.level,
    super.isFreeMode,
    super.kanjiDetailId,
  });
}

/// Choose the word that fills the gap in a sentence.
final class SentenceClozeQuestion extends PracticeQuestion {
  final Sentence sentence;
  final String? translation;
  final String? targetReading;
  final List<McqOption> options;
  final int correctIndex;

  const SentenceClozeQuestion({
    required this.sentence,
    required this.options,
    required this.correctIndex,
    this.translation,
    this.targetReading,
    super.level,
    super.isFreeMode,
  });
}

/// The grammar version of a cloze: the sentence is plain text, not a row.
final class GrammarClozeQuestion extends PracticeQuestion {
  final String sentence;
  final List<McqOption> options;
  final int correctIndex;

  const GrammarClozeQuestion({
    required this.sentence,
    required this.options,
    required this.correctIndex,
    super.level,
    super.isFreeMode,
  });
}

/// Put the scrambled parts of a sentence back in order.
final class GrammarBuilderQuestion extends PracticeQuestion {
  final List<String> parts;
  final String translation;

  const GrammarBuilderQuestion({
    required this.parts,
    required this.translation,
    super.level,
    super.isFreeMode,
  });
}

/// Tell the correct sentence from the incorrect one.
final class GrammarErrorQuestion extends PracticeQuestion {
  final String correct;
  final String wrong;
  final String explanation;

  const GrammarErrorQuestion({
    required this.correct,
    required this.wrong,
    required this.explanation,
    super.level,
    super.isFreeMode,
  });
}
