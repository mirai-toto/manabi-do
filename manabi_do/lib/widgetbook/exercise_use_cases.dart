import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../presentation/widgets/exercise/flash_card.dart';
import '../presentation/widgets/exercise/mcq_card.dart';
import '../presentation/widgets/exercise/session_summary.dart';

// ── FlashCard ─────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Hidden', type: FlashCard, path: 'Exercise')
Widget buildFlashCardHidden(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: FlashCard(japanese: '水', onTap: () {}),
  );
}

@widgetbook.UseCase(name: 'Revealed', type: FlashCard, path: 'Exercise')
Widget buildFlashCardRevealed(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: FlashCard(japanese: '水', answer: 'Water', isRevealed: true),
  );
}

// ── FlashCardActions ──────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: FlashCardActions, path: 'Exercise')
Widget buildFlashCardActions(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: FlashCardActions(
      card: Card(
        cardId: 0,
        due: DateTime.now(),
      ),
      question: 'How well did you know this?',
      onRate: (_) {},
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

// ── SessionSummary ────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'With results', type: SessionSummary, path: 'Exercise')
Widget buildSessionSummaryResults(BuildContext context) {
  return SessionSummary(
    gotIt: 12,
    notYet: 3,
    color: Theme.of(context).colorScheme.primary,
    onDone: () {},
  );
}

@widgetbook.UseCase(name: 'Empty session', type: SessionSummary, path: 'Exercise')
Widget buildSessionSummaryEmpty(BuildContext context) {
  return SessionSummary(
    gotIt: 0,
    notYet: 0,
    color: Theme.of(context).colorScheme.primary,
    onDone: () {},
  );
}
