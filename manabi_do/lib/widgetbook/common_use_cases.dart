import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../presentation/widgets/common/app_button.dart';
import '../presentation/widgets/common/card_container.dart';
import '../presentation/widgets/common/difficulty_dots.dart';
import '../presentation/widgets/common/known_toggle.dart';
import '../presentation/widgets/common/pill_badge.dart';
import '../presentation/widgets/common/practice_button.dart';
import '../presentation/widgets/common/progress_bar.dart';
import '../presentation/widgets/common/section_label.dart';
import '../presentation/widgets/common/segmented_tab_bar.dart';

// ── CardContainer ─────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: CardContainer, path: 'Common')
Widget buildCardContainerDefault(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: CardContainer(
      padding: const EdgeInsets.all(16),
      child: const Text('Card content goes here'),
    ),
  );
}

// ── PillBadge ─────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Primary', type: PillBadge, path: 'Common')
Widget buildPillBadgePrimary(BuildContext context) {
  return PillBadge(
    label: 'N5',
    color: Theme.of(context).colorScheme.primary,
    background: Theme.of(context).colorScheme.primaryContainer,
  );
}

@widgetbook.UseCase(name: 'Success', type: PillBadge, path: 'Common')
Widget buildPillBadgeSuccess(BuildContext context) {
  return const PillBadge(
    label: 'KNOWN',
    color: Color(0xFF2E7D32),
    background: Color(0xFFE8F5E9),
  );
}

@widgetbook.UseCase(name: 'Error', type: PillBadge, path: 'Common')
Widget buildPillBadgeError(BuildContext context) {
  return const PillBadge(
    label: 'DUE',
    color: Color(0xFFC62828),
    background: Color(0xFFFFEBEE),
  );
}

// ── DifficultyDots ────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Empty', type: DifficultyDots, path: 'Common')
Widget buildDifficultyDotsEmpty(BuildContext context) {
  return DifficultyDots(
    total: 5,
    filled: 0,
    color: Theme.of(context).colorScheme.primary,
  );
}

@widgetbook.UseCase(name: 'Half', type: DifficultyDots, path: 'Common')
Widget buildDifficultyDotsHalf(BuildContext context) {
  return DifficultyDots(
    total: 5,
    filled: 3,
    color: Theme.of(context).colorScheme.primary,
  );
}

@widgetbook.UseCase(name: 'Full', type: DifficultyDots, path: 'Common')
Widget buildDifficultyDotsFull(BuildContext context) {
  return DifficultyDots(
    total: 5,
    filled: 5,
    color: Theme.of(context).colorScheme.primary,
  );
}

// ── SectionLabel ──────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: SectionLabel, path: 'Common')
Widget buildSectionLabel(BuildContext context) {
  return const SectionLabel('Stroke order');
}

// ── AppButton ─────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Filled', type: AppButton, path: 'Common')
Widget buildAppButtonFilled(BuildContext context) {
  return AppButton(label: 'Start practice', onPressed: () {});
}

@widgetbook.UseCase(name: 'Tonal', type: AppButton, path: 'Common')
Widget buildAppButtonTonal(BuildContext context) {
  return AppButton(label: 'Learn more', variant: AppButtonVariant.tonal, onPressed: () {});
}

@widgetbook.UseCase(name: 'Outlined', type: AppButton, path: 'Common')
Widget buildAppButtonOutlined(BuildContext context) {
  return AppButton(label: 'Skip', variant: AppButtonVariant.outlined, onPressed: () {});
}

@widgetbook.UseCase(name: 'Text', type: AppButton, path: 'Common')
Widget buildAppButtonText(BuildContext context) {
  return AppButton(label: 'Cancel', variant: AppButtonVariant.text, onPressed: () {});
}

@widgetbook.UseCase(name: 'Danger', type: AppButton, path: 'Common')
Widget buildAppButtonDanger(BuildContext context) {
  return AppButton(label: 'Reset progress', variant: AppButtonVariant.danger, onPressed: () {});
}

@widgetbook.UseCase(name: 'Small', type: AppButton, path: 'Common')
Widget buildAppButtonSmall(BuildContext context) {
  return AppButton(label: 'Filter', size: AppButtonSize.small, onPressed: () {});
}

@widgetbook.UseCase(name: 'Disabled', type: AppButton, path: 'Common')
Widget buildAppButtonDisabled(BuildContext context) {
  return const AppButton(label: 'Unavailable');
}

// ── AppProgressBar ────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: '0%', type: AppProgressBar, path: 'Common')
Widget buildProgressBarEmpty(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: AppProgressBar(progress: 0),
  );
}

@widgetbook.UseCase(name: '60%', type: AppProgressBar, path: 'Common')
Widget buildProgressBarHalf(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: AppProgressBar(progress: 0.6),
  );
}

@widgetbook.UseCase(name: '100%', type: AppProgressBar, path: 'Common')
Widget buildProgressBarFull(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: AppProgressBar(progress: 1),
  );
}

// ── KnownToggle ───────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Unknown', type: KnownToggle, path: 'Common')
Widget buildKnownToggleUnknown(BuildContext context) {
  return KnownToggle(isKnown: false, onTap: () {});
}

@widgetbook.UseCase(name: 'Known', type: KnownToggle, path: 'Common')
Widget buildKnownToggleKnown(BuildContext context) {
  return KnownToggle(isKnown: true, onTap: () {});
}

// ── PracticeButton ────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: PracticeButton, path: 'Common')
Widget buildPracticeButton(BuildContext context) {
  return PracticeButton(
    color: Theme.of(context).colorScheme.primary,
    onTap: () {},
  );
}

// ── SegmentedTabBar ───────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: SegmentedTabBar, path: 'Common')
Widget buildSegmentedTabBar(BuildContext context) {
  return DefaultTabController(
    length: 3,
    child: Builder(
      builder: (ctx) => SegmentedTabBar(
        controller: DefaultTabController.of(ctx),
        labels: const ['Hiragana', 'Katakana', 'Kanji'],
      ),
    ),
  );
}
