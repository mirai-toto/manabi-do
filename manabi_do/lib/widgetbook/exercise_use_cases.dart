import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../presentation/screens/practice/grammar_builder_body.dart';
import '../presentation/screens/practice/grammar_cloze_body.dart';
import '../presentation/screens/practice/grammar_error_detection_body.dart';
import '../presentation/providers/drawing_settings_provider.dart';
import '../presentation/widgets/characters/kanji_strokes_provider.dart';
import '../presentation/widgets/exercise/drawing_exercise.dart';
import '../presentation/widgets/exercise/flash_card.dart';
import '../presentation/widgets/exercise/lesson_reader_card.dart';
import '../presentation/widgets/exercise/mcq_card.dart';
import '../presentation/widgets/exercise/summary_card.dart';

// ── FlashCard ─────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Hidden', type: FlashCard, path: 'Exercise')
Widget buildFlashCardHidden(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: FlashCard(
      prompt: '水',
      promptSub: 'みず',
      reveal: 'Water',
      speakText: '水',
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Revealed', type: FlashCard, path: 'Exercise')
Widget buildFlashCardRevealed(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: FlashCard(
      prompt: '水',
      promptSub: 'みず',
      reveal: 'Water',
      speakText: '水',
      isRevealed: true,
    ),
  );
}

@widgetbook.UseCase(name: 'Reversed (EN→JP)', type: FlashCard, path: 'Exercise')
Widget buildFlashCardReversed(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: FlashCard(
      prompt: 'Water',
      reveal: '水',
      revealSub: 'みず',
      speakText: '水',
      onTap: () {},
    ),
  );
}

// ── FlashCardActions ──────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: FlashCardActions, path: 'Exercise')
Widget buildFlashCardActions(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: FlashCardActions(
      card: Card(cardId: 0, due: DateTime.now()),
      question: 'How well did you know this?',
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
          ),
        ),
      );
    },
  );
}

// ── LessonReaderCard ──────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: LessonReaderCard, path: 'Exercise')
Widget buildLessonReaderCard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: LessonReaderCard(
      chapterLabel: 'Chapter 1',
      title: 'Greetings in Japanese',
      body: const [
        ReaderBodyText(
          'Japanese greetings vary by time of day and level of formality.',
        ),
        ReaderSectionTitle('Morning greeting'),
        ReaderJpExample(
          japanese: 'おはようございます',
          translation: 'Good morning (formal)',
        ),
        ReaderBodyText('Use おはよう with close friends and family.'),
      ],
      onPractice: () {},
    ),
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

// ── SummaryCard ───────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: SummaryCard, path: 'Exercise')
Widget buildSummaryCard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SummaryCard(
      score: 8,
      total: 10,
      title: 'Session complete!',
      subtitle: 'N5 Kanji · 10 cards',
      correct: 8,
      missed: 2,
      timeSpent: '4m 32s',
      onRetry: () {},
      onNext: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Perfect score', type: SummaryCard, path: 'Exercise')
Widget buildSummaryCardPerfect(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: SummaryCard(
      score: 10,
      total: 10,
      title: 'Perfect!',
      subtitle: 'N5 Kanji · 10 cards',
      correct: 10,
      missed: 0,
      timeSpent: '2m 10s',
      onRetry: () {},
      onNext: () {},
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
    onAnswer: (_) {},
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
    onAnswer: (_) {},
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
    onAnswer: (_) {},
  );
}
