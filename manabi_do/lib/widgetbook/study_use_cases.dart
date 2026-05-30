import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../domain/entities/lesson_status.dart';
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
      subtitle: 'N5 — N1 kanji',
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
      subtitle: 'N5 — N1 kanji',
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
  return Padding(
    padding: const EdgeInsets.all(16),
    child: LessonRow(
      title: 'Hiragana basics',
      difficulty: 1,
      lessonNumber: 1,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Done', type: LessonRow, path: 'Study')
Widget buildLessonRowDone(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: LessonRow(
      title: 'Hiragana basics',
      difficulty: 1,
      status: LessonStatus.done,
      lessonNumber: 1,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'High difficulty', type: LessonRow, path: 'Study')
Widget buildLessonRowHardDifficulty(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: LessonRow(
      title: 'Complex grammar patterns',
      difficulty: 3,
      lessonNumber: 12,
      onTap: () {},
    ),
  );
}

// ── ChapterCard ───────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Not started', type: ChapterCard, path: 'Study')
Widget buildChapterCardNotStarted(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ChapterCard(
      chapterNumber: 1,
      title: 'Greetings & Introductions',
      description:
          'Learn how to introduce yourself and greet people in Japanese.',
      totalLessons: 8,
      completedLessons: 0,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'In progress', type: ChapterCard, path: 'Study')
Widget buildChapterCardInProgress(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ChapterCard(
      chapterNumber: 2,
      title: 'Numbers & Time',
      description: 'Count, tell the time, and talk about dates.',
      totalLessons: 10,
      completedLessons: 6,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Complete', type: ChapterCard, path: 'Study')
Widget buildChapterCardComplete(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ChapterCard(
      chapterNumber: 3,
      title: 'Food & Restaurants',
      description: 'Order food and navigate a Japanese restaurant.',
      totalLessons: 7,
      completedLessons: 7,
      onTap: () {},
    ),
  );
}
