import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../presentation/widgets/exercise/grammar_builder_body.dart';
import '../presentation/widgets/exercise/grammar_cloze_body.dart';
import '../presentation/widgets/exercise/grammar_error_detection_body.dart';
import '../presentation/providers/drawing_settings_provider.dart';
import '../presentation/providers/kanji_strokes_provider.dart';
import '../presentation/widgets/exercise/drawing_exercise.dart';
import '../presentation/widgets/exercise/flashcard.dart';
import '../presentation/widgets/exercise/mcq_card.dart';
import '../presentation/widgets/exercise/sentence_cloze_card.dart';
import '../data/database/app_database.dart';
import '../presentation/models/practice_answer.dart';
import '../presentation/widgets/exercise/session_summary.dart';
import '../presentation/widgets/exercise/view_detail_button.dart';

// ── Flashcard ─────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Hidden', type: Flashcard, path: 'Exercise')
Widget buildFlashcardHidden(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Flashcard(
      prompt: '水',
      promptSub: 'みず',
      reveal: 'Water',
      speakText: '水',
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Revealed', type: Flashcard, path: 'Exercise')
Widget buildFlashcardRevealed(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Flashcard(
      prompt: '水',
      promptSub: 'みず',
      reveal: 'Water',
      speakText: '水',
      isRevealed: true,
    ),
  );
}

@widgetbook.UseCase(name: 'Reversed (EN→JP)', type: Flashcard, path: 'Exercise')
Widget buildFlashcardReversed(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Flashcard(
      prompt: 'Water',
      reveal: '水',
      revealSub: 'みず',
      speakText: '水',
      onTap: () {},
    ),
  );
}

// ── FlashcardActions ──────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: FlashcardActions, path: 'Exercise')
Widget buildFlashcardActions(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: FlashcardActions(
      card: Card(cardId: 0, due: DateTime.now()),
      question: 'How well did you know this?',
      fourPointGrading: true,
      onRate: (_) {},
    ),
  );
}

@widgetbook.UseCase(
  name: 'Two grades',
  type: FlashcardActions,
  path: 'Exercise',
)
Widget buildFlashcardActionsTwoGrades(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: FlashcardActions(
      card: Card(cardId: 0, due: DateTime.now()),
      fourPointGrading: false,
      onRate: (_) {},
    ),
  );
}

// ── DrawingExercise ───────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: DrawingExercise, path: 'Exercise')
Widget buildDrawingExercise(BuildContext context) {
  return Consumer(
    builder: (context, ref, _) {
      final strokes =
          ref.watch(kanjiStrokesProvider(0x6c34)).asData?.value ?? [];
      final drawingSettings = ref.watch(drawingSettingsProvider);
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: DrawingExercise(
            referenceStrokes: strokes,
            kanjiId: 0x6c34,
            label: '水',
            color: Theme.of(context).colorScheme.primary,
            settings: drawingSettings,
            autoAdvance: drawingSettings.autoAdvance,
            fourPointGrading: true,
          ),
        ),
      );
    },
  );
}

// ── McqCard ───────────────────────────────────────────────────────────────────

const _options = [
  McqOption(letter: 'A', text: 'Water'),
  McqOption(letter: 'B', text: 'Fire'),
  McqOption(letter: 'C', text: 'Earth'),
  McqOption(letter: 'D', text: 'Wind'),
];

@widgetbook.UseCase(name: 'Idle', type: McqCard, path: 'Exercise')
Widget buildMcqCardIdle(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: McqCard(
      badgeLabel: 'Multiple Choice',
      question: 'What is the meaning of this kanji?',
      japanesePrompt: '水',
      options: _options,
    ),
  );
}

@widgetbook.UseCase(name: 'Selected', type: McqCard, path: 'Exercise')
Widget buildMcqCardSelected(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: McqCard(
      badgeLabel: 'Multiple Choice',
      question: 'What is the meaning of this kanji?',
      japanesePrompt: '水',
      options: [
        _options[0].copyWith(state: McqOptionState.selected),
        ..._options.skip(1),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Correct', type: McqCard, path: 'Exercise')
Widget buildMcqCardCorrect(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: McqCard(
      badgeLabel: 'Multiple Choice',
      question: 'What is the meaning of this kanji?',
      japanesePrompt: '水',
      options: [
        _options[0].copyWith(state: McqOptionState.correct),
        ..._options.skip(1),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Wrong', type: McqCard, path: 'Exercise')
Widget buildMcqCardWrong(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: McqCard(
      badgeLabel: 'Multiple Choice',
      question: 'What is the meaning of this kanji?',
      japanesePrompt: '水',
      options: [
        _options[0].copyWith(state: McqOptionState.wrong),
        _options[1].copyWith(state: McqOptionState.correct),
        ..._options.skip(2),
      ],
    ),
  );
}

// ── SessionSummary ────────────────────────────────────────────────────────────

SessionAnswer _summaryAnswer(
  String item,
  String answer,
  Rating rating, {
  String? given,
}) => SessionAnswer(
  srsType: 'hiragana',
  id: item.hashCode,
  card: null,
  rating: rating,
  given: given,
  summary: PracticeSummary(
    item: item,
    question: (l) => l.summaryLookAgain,
    answer: answer,
    kindLabel: (l) => l.summaryLookAgain,
  ),
);

final List<SessionAnswer> _summaryMixed = [
  _summaryAnswer('ぬ', 'nu', Rating.again, given: 'me'),
  _summaryAnswer('ほ', 'ho', Rating.again, given: 'ha'),
  _summaryAnswer('る', 'ru', Rating.hard, given: 'ru'),
  for (final k in ['か', 'き', 'く', 'け', 'こ', 'さ', 'し', 'す'])
    _summaryAnswer(k, k, Rating.good, given: k),
  _summaryAnswer('そ', 'so', Rating.easy, given: 'so'),
];

@widgetbook.UseCase(
  name: 'Review with mistakes',
  type: SessionSummary,
  path: 'Exercise',
)
Widget buildSessionSummaryMixed(BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: SessionSummary(
      answers: _summaryMixed,
      elapsedLabel: '4 min 12 s',
      gradesRecorded: true,
      fourPointGrading: true,
      streakDays: 5,
      dueLeft: 4,
      comingBack: (laterToday: 2, tomorrow: 7, later: 3, next: null),
      onDone: () {},
      onContinue: () {},
      onPracticeMistakes: () {},
      onPracticeAll: () {},
      onOpenAnswers: () {},
    ),
  );
}

@widgetbook.UseCase(
  name: 'Day finished',
  type: SessionSummary,
  path: 'Exercise',
)
Widget buildSessionSummaryDone(BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: SessionSummary(
      answers: [
        for (final a in _summaryMixed)
          _summaryAnswer(a.summary.item, a.summary.answer, Rating.good),
      ],
      elapsedLabel: '9 min 40 s',
      gradesRecorded: true,
      fourPointGrading: true,
      streakDays: 6,
      newLeft: 8,
      comingBack: (laterToday: 0, tomorrow: 11, later: 1, next: null),
      onDone: () {},
      onContinue: () {},
      onPracticeAll: () {},
      onOpenAnswers: () {},
    ),
  );
}

@widgetbook.UseCase(
  name: 'Free practice',
  type: SessionSummary,
  path: 'Exercise',
)
Widget buildSessionSummaryPractice(BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: SessionSummary(
      answers: _summaryMixed,
      elapsedLabel: '2 min 58 s',
      gradesRecorded: false,
      fourPointGrading: false,
      onDone: () {},
      onPracticeMistakes: () {},
      onPracticeAll: () {},
      onOpenAnswers: () {},
    ),
  );
}

// ── GrammarBuilderBody ────────────────────────────────────────────────────────

@widgetbook.UseCase(
  name: 'Default',
  type: GrammarBuilderBody,
  path: 'Exercise/Grammar',
)
Widget buildGrammarBuilderBody(BuildContext context) {
  return GrammarBuilderBody(
    parts: const ['テレビを', '見ながら', '夕ごはんを', '食べます'],
    translation: 'I eat dinner while watching TV.',
    index: 0,
    total: 10,
    color: const Color(0xFF5C6BC0),
    fourPointGrading: true,
    onAnswer: (_, {given, mistakes}) {},
  );
}

// ── GrammarErrorDetectionBody ─────────────────────────────────────────────────

@widgetbook.UseCase(
  name: 'Default',
  type: GrammarErrorDetectionBody,
  path: 'Exercise/Grammar',
)
Widget buildGrammarErrorDetectionBody(BuildContext context) {
  return GrammarErrorDetectionBody(
    correct: '歩きながら電話で話しました。',
    wrong: '歩いてながら電話で話しました。',
    explanation: 'ながら attaches to the verb stem (歩き), not the て-form (歩いて).',
    index: 1,
    total: 10,
    color: const Color(0xFF5C6BC0),
    onAnswer: (_, {given, mistakes}) {},
  );
}

// ── GrammarClozeBody ──────────────────────────────────────────────────────────

const _clozeOptions = [
  McqOption(letter: 'A', text: 'てから', useJpFont: true),
  McqOption(letter: 'B', text: 'ながら', useJpFont: true),
  McqOption(letter: 'C', text: '前に', useJpFont: true),
  McqOption(letter: 'D', text: '後で', useJpFont: true),
];

@widgetbook.UseCase(
  name: 'Default',
  type: GrammarClozeBody,
  path: 'Exercise/Grammar',
)
Widget buildGrammarClozeBody(BuildContext context) {
  return GrammarClozeBody(
    sentence: '音楽を聴き___勉強します。',
    options: _clozeOptions,
    correctIndex: 1,
    index: 2,
    total: 10,
    color: const Color(0xFF5C6BC0),
    fourPointGrading: true,
    onAnswer: (_, {given, mistakes}) {},
  );
}

// ── SentenceClozeCard ─────────────────────────────────────────────────────────

const _clozeSentence = Sentence(
  id: 1,
  japanese: '毎朝、新しいシャツを着て学校に行きます。',
  targetWord: '新しい',
  vocabularyId: 1,
);

Widget _cloze(BuildContext context, {required bool showTranslation}) {
  final color = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      child: SentenceClozeCard(
        sentence: _clozeSentence,
        translation: 'Every morning I put on a new shirt and go to school.',
        showTranslation: showTranslation,
        onToggleTranslation: () {},
        showSentenceFurigana: false,
        showChoiceFurigana: false,
        answered: false,
        color: color,
        onOptionTap: (_) {},
        options: const [
          McqOption(letter: 'A', text: '新しい', useJpFont: true),
          McqOption(letter: 'B', text: '古い', useJpFont: true),
          McqOption(letter: 'C', text: '大きい', useJpFont: true),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Translation hidden',
  type: SentenceClozeCard,
  path: 'Exercise',
)
Widget buildSentenceClozeCardHidden(BuildContext context) =>
    _cloze(context, showTranslation: false);

@widgetbook.UseCase(
  name: 'Translation showing',
  type: SentenceClozeCard,
  path: 'Exercise',
)
Widget buildSentenceClozeCardShowing(BuildContext context) =>
    _cloze(context, showTranslation: true);

// ── ViewDetailButton ─────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: ViewDetailButton, path: 'Exercise')
Widget buildViewDetailButton(BuildContext context) {
  return Center(
    child: ViewDetailButton(label: 'View detail', onPressed: () {}),
  );
}
