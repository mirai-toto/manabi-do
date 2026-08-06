import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/models/learning_state.dart';
import '../presentation/widgets/study/chapter_card.dart';
import '../presentation/widgets/study/lesson_row.dart';
import '../presentation/widgets/study/domain_card.dart';
import '../presentation/widgets/study/streak_card.dart';

// ── StreakCard ─────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Active streak', type: StreakCard, path: 'Study')
Widget buildStreakCardActive(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: StreakCard(days: 14, label: 'day streak', subtitle: 'Keep it up!'),
  );
}

@widgetbook.UseCase(name: 'New streak', type: StreakCard, path: 'Study')
Widget buildStreakCardNew(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: StreakCard(days: 1, label: 'day streak', subtitle: 'Great start!'),
  );
}

// ── DomainCard ───────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'No reviews due', type: DomainCard, path: 'Study')
Widget buildDomainCardDefault(BuildContext context) {
  final primary = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: DomainCard(
      title: 'Kanji',
      icon: '漢',
      gradientColors: [primary, primary.withValues(alpha: 0.6)],
      progressColor: primary,
      statLabel: '42 / 2136 known',
      progress: 0.02,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Reviews due', type: DomainCard, path: 'Study')
Widget buildDomainCardReviewsDue(BuildContext context) {
  final primary = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.all(16),
    child: DomainCard(
      title: 'Kanji',
      icon: '漢',
      gradientColors: [primary, primary.withValues(alpha: 0.6)],
      progressColor: primary,
      statLabel: '42 / 2136 known',
      progress: 0.02,
      dueCount: 12,
      onTap: () {},
      onPractice: () {},
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
