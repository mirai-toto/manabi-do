import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/models/learning_state.dart';
import '../presentation/widgets/study/chapter_card.dart';
import '../presentation/widgets/study/continue_lesson_card.dart';
import '../presentation/widgets/study/deck_row.dart';
import '../presentation/widgets/study/lesson_row.dart';
import '../presentation/widgets/study/streak_pill.dart';
import '../presentation/widgets/study/todays_session_card.dart';
import '../presentation/widgets/study/week_strip.dart';

// ── StreakPill ────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Active streak', type: StreakPill, path: 'Study')
Widget buildStreakPillActive(BuildContext context) {
  return const Center(child: StreakPill(days: 14));
}

// ── TodaysSessionCard ────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Reviews due', type: TodaysSessionCard, path: 'Study')
Widget buildTodaysSessionCardDue(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: TodaysSessionCard(
      domains: const [
        (glyph: 'か', due: 12),
        (glyph: '字', due: 23),
        (glyph: '語', due: 12),
      ],
      newTotal: 10,
      onStart: () {},
    ),
  );
}

@widgetbook.UseCase(
  name: 'All caught up',
  type: TodaysSessionCard,
  path: 'Study',
)
Widget buildTodaysSessionCardCaughtUp(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: TodaysSessionCard(
      domains: const [
        (glyph: 'か', due: 0),
        (glyph: '字', due: 0),
        (glyph: '語', due: 0),
      ],
      newTotal: 0,
      onStart: () {},
    ),
  );
}

// ── DeckRow ──────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Reviews due', type: DeckRow, path: 'Study')
Widget buildDeckRowDue(BuildContext context) {
  final primary = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: DeckRow(
      title: 'Kanji',
      glyph: '字',
      color: primary,
      known: 45,
      seen: 112,
      newToday: 5,
      due: 23,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Nothing due', type: DeckRow, path: 'Study')
Widget buildDeckRowIdle(BuildContext context) {
  final primary = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: DeckRow(
      title: 'Kana',
      glyph: 'か',
      color: primary,
      known: 92,
      seen: 104,
      newToday: 0,
      due: 0,
      onTap: () {},
    ),
  );
}

// ── ContinueLessonCard ───────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: ContinueLessonCard, path: 'Study')
Widget buildContinueLessonCard(BuildContext context) {
  final primary = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ContinueLessonCard(
      title: 'Word order',
      subtitle: 'Japanese Basics · Sentence Structure',
      lessonIndex: 1,
      lessonCount: 4,
      color: primary,
      onTap: () {},
    ),
  );
}

// ── WeekStrip ────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Mid-week', type: WeekStrip, path: 'Study')
Widget buildWeekStrip(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: WeekStrip(
      reviewedDays: const [true, true, true, false, false, false, false],
      todayIndex: 3,
    ),
  );
}

// ── LessonRow ─────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Not started', type: LessonRow, path: 'Study')
Widget buildLessonRowNotStarted(BuildContext context) {
  final accent = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: LessonRow(
      title: 'Hiragana basics',
      index: 0,
      difficulty: 1,
      state: LearningState.notStarted,
      accentColor: accent,
      exerciseCount: 0,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Started', type: LessonRow, path: 'Study')
Widget buildLessonRowStarted(BuildContext context) {
  final accent = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: LessonRow(
      title: 'Verb groups',
      index: 1,
      difficulty: 2,
      state: LearningState.started,
      accentColor: accent,
      exerciseCount: 3,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Known', type: LessonRow, path: 'Study')
Widget buildLessonRowKnown(BuildContext context) {
  final accent = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: LessonRow(
      title: 'Hiragana basics',
      index: 0,
      difficulty: 1,
      state: LearningState.known,
      accentColor: accent,
      exerciseCount: 2,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Locked', type: LessonRow, path: 'Study')
Widget buildLessonRowLocked(BuildContext context) {
  final accent = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: LessonRow(
      title: 'Complex grammar patterns',
      index: 11,
      difficulty: 3,
      state: LearningState.locked,
      accentColor: accent,
      exerciseCount: 0,
      onTap: () {},
    ),
  );
}

// ── ChapterCard ───────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Not started', type: ChapterCard, path: 'Study')
Widget buildChapterCardNotStarted(BuildContext context) {
  final accent = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ChapterCard(
      chapterLabel: 'Chapter 01',
      title: 'Greetings & Introductions',
      description:
          'Learn how to introduce yourself and greet people in Japanese.',
      badge: '8 lessons',
      doneCount: 0,
      totalLessons: 8,
      progressLabel: '0 / 8 lessons',
      accentColor: accent,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'In progress', type: ChapterCard, path: 'Study')
Widget buildChapterCardInProgress(BuildContext context) {
  final accent = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ChapterCard(
      chapterLabel: 'Chapter 02',
      title: 'Numbers & Time',
      description: 'Count, tell the time, and talk about dates.',
      badge: '10 lessons',
      doneCount: 6,
      totalLessons: 10,
      progressLabel: '6 / 10 lessons',
      accentColor: accent,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Locked', type: ChapterCard, path: 'Study')
Widget buildChapterCardLocked(BuildContext context) {
  final accent = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ChapterCard(
      chapterLabel: 'Chapter 03',
      title: 'Food & Restaurants',
      description: 'Order food and navigate a Japanese restaurant.',
      badge: '7 lessons',
      doneCount: 0,
      totalLessons: 7,
      progressLabel: '0 / 7 lessons',
      accentColor: accent,
      isLocked: true,
      onTap: () {},
    ),
  );
}
