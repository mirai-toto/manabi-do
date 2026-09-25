import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card;

import '../../../core/models/flashcard_settings.dart';
import '../../../core/models/mcq_settings.dart';
import '../../../core/models/practice_item.dart';
import '../../../core/models/practice_question.dart';
import '../../../core/models/sentence_settings.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/exercise/grammar_builder_body.dart';
import '../../widgets/exercise/grammar_cloze_body.dart';
import '../../widgets/exercise/grammar_error_detection_body.dart';
import '../../widgets/exercise/kanji_drawing_body.dart';
import '../../widgets/exercise/practice_flashcard_body.dart';
import '../../widgets/exercise/practice_mcq_body.dart';
import '../../widgets/exercise/sentence_cloze_body.dart';
import '../characters/kanji/kanji_detail_screen.dart';

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

/// Draws whatever the queue asks next.
///
/// This is the only place that knows which widget answers which kind of
/// question, so a service can describe an exercise without importing any of
/// them. It also resolves the three things a question deliberately leaves out:
/// the colour, the wording, and where the detail affordance goes.
class PracticeQuestionBody extends StatelessWidget {
  final PracticeQuestion question;
  final Card? card;
  final int index;
  final int total;
  final AnswerCallback onAnswer;
  final PracticeBodySettings settings;

  /// Used when the question does not name a level of its own.
  final Color sessionColor;

  const PracticeQuestionBody({
    super.key,
    required this.question,
    required this.card,
    required this.index,
    required this.total,
    required this.onAnswer,
    required this.settings,
    required this.sessionColor,
  });

  /// Free practice follows the switch that belongs to the exercise; a review
  /// follows the one switch that covers the whole session.
  bool get _autoAdvanceMcq =>
      question.isFreeMode ? settings.mcq.autoAdvance : settings.autoAdvance;

  bool get _autoAdvanceSentence => question.isFreeMode
      ? settings.sentence.autoAdvance
      : settings.autoAdvance;

  VoidCallback? _onDetailTap(BuildContext context) {
    final kanjiId = question.kanjiDetailId;
    if (kanjiId == null) return null;
    return () => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => KanjiDetailScreen(kanjiId: kanjiId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color color = question.level != null
        ? levelColor(question.level!)
        : sessionColor;

    return switch (question) {
      final FlashcardQuestion q => PracticeFlashcardBody(
        japanese: q.japanese,
        label: q.label,
        answer: q.answer,
        isReversed: q.isReversed,
        example: q.example,
        locale: q.locale,
        questionOverride: q.questionOverride,
        isFreeMode: q.isFreeMode,
        card: card,
        index: index,
        total: total,
        color: color,
        onAnswer: onAnswer,
        showExample: settings.flashcard.showExample,
        onDetailTap: _onDetailTap(context),
      ),
      final McqQuestion q => PracticeMcqBody(
        question: q.prompt(context.l10n),
        japanesePrompt: q.japanesePrompt,
        japaneseReading: q.japaneseReading,
        options: q.options,
        correctIndex: q.correctIndex,
        compactGrid: q.compactGrid,
        isFreeMode: q.isFreeMode,
        card: card,
        index: index,
        total: total,
        color: color,
        onAnswer: onAnswer,
        autoAdvance: _autoAdvanceMcq,
        showPromptFurigana: settings.mcq.showPromptFurigana,
        onDetailTap: _onDetailTap(context),
      ),
      final DrawingQuestion q => KanjiDrawingBody(
        kanji: q.kanji,
        meaning: q.meaning,
        isFreeMode: q.isFreeMode,
        card: card,
        index: index,
        total: total,
        color: color,
        onAnswer: onAnswer,
        // Drawing has no per-exercise switch of its own outside free mode,
        // where the body reads the drawing settings directly.
        autoAdvance: settings.autoAdvance,
        onDetailTap: _onDetailTap(context),
      ),
      final SentenceClozeQuestion q => SentenceClozeBody(
        sentence: q.sentence,
        translation: q.translation,
        targetReading: q.targetReading,
        options: q.options,
        correctIndex: q.correctIndex,
        isFreeMode: q.isFreeMode,
        card: card,
        index: index,
        total: total,
        color: color,
        onAnswer: onAnswer,
        autoAdvance: _autoAdvanceSentence,
        translationMode: settings.sentence.translationMode,
        showSentenceFurigana: settings.sentence.showSentenceFurigana,
        showChoiceFurigana: settings.sentence.showChoiceFurigana,
      ),
      final GrammarClozeQuestion q => GrammarClozeBody(
        sentence: q.sentence,
        options: q.options,
        correctIndex: q.correctIndex,
        index: index,
        total: total,
        color: color,
        autoAdvance: _autoAdvanceMcq,
        onAnswer: onAnswer,
      ),
      final GrammarBuilderQuestion q => GrammarBuilderBody(
        parts: q.parts,
        translation: q.translation,
        index: index,
        total: total,
        color: color,
        autoAdvance: _autoAdvanceMcq,
        onAnswer: onAnswer,
      ),
      final GrammarErrorQuestion q => GrammarErrorDetectionBody(
        correct: q.correct,
        wrong: q.wrong,
        explanation: q.explanation,
        index: index,
        total: total,
        color: color,
        onAnswer: onAnswer,
      ),
    };
  }
}
