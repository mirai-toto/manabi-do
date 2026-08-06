import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Card;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../core/theme/jlpt_level.dart';
import '../presentation/widgets/common/app_button.dart';
import '../presentation/widgets/common/app_emoji.dart';
import '../presentation/widgets/common/app_filter_chip.dart';
import '../presentation/widgets/common/app_text_field.dart';
import '../presentation/widgets/common/card_container.dart';
import '../presentation/widgets/common/difficulty_dots.dart';
import '../presentation/widgets/common/japanese_text.dart';
import '../presentation/widgets/common/jlpt_level_card.dart';
import '../presentation/widgets/common/pill_badge.dart';
import '../presentation/widgets/common/practice_button.dart';
import '../presentation/widgets/common/progress_bar.dart';
import '../presentation/widgets/common/progress_row.dart';
import '../presentation/widgets/common/section_header.dart';
import '../presentation/widgets/common/section_label.dart';
import '../presentation/widgets/common/segmented_tab_bar.dart';
import '../presentation/widgets/common/speak_button.dart';
import '../presentation/widgets/common/review_progress_info.dart';
import '../presentation/widgets/common/tappable_surface.dart';

// ── AppEmoji ──────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: AppEmoji, path: 'Common')
Widget buildAppEmoji(BuildContext context) {
  return const AppEmoji('🎉', size: 48);
}

// ── AppFilterChip ─────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Inactive', type: AppFilterChip, path: 'Common')
Widget buildAppFilterChipInactive(BuildContext context) {
  return AppFilterChip(label: 'N5', isActive: false, onTap: () {});
}

@widgetbook.UseCase(name: 'Active', type: AppFilterChip, path: 'Common')
Widget buildAppFilterChipActive(BuildContext context) {
  return AppFilterChip(label: 'N5', isActive: true, onTap: () {});
}

@widgetbook.UseCase(name: 'Disabled', type: AppFilterChip, path: 'Common')
Widget buildAppFilterChipDisabled(BuildContext context) {
  return const AppFilterChip(label: 'N5');
}

// ── AppTextField ──────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Empty', type: AppTextField, path: 'Common')
Widget buildAppTextFieldEmpty(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: AppTextField(label: 'Search', hint: 'Type a kanji…'),
  );
}

@widgetbook.UseCase(name: 'With icons', type: AppTextField, path: 'Common')
Widget buildAppTextFieldIcons(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: AppTextField(
      label: 'Search',
      hint: 'Type a kanji…',
      prefixIcon: Icon(Icons.search),
    ),
  );
}

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

// ── TappableSurface ──────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: TappableSurface, path: 'Common')
Widget buildTappableSurface(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: TappableSurface(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: () {},
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Tappable card content'),
      ),
    ),
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

// ── JapaneseText ──────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'All kanji', type: JapaneseText, path: 'Common')
Widget buildJapaneseTextAllKanji(BuildContext context) {
  return JapaneseText(
    word: '日本語',
    reading: 'にほんご',
    style: const TextStyle(fontSize: 28),
  );
}

@widgetbook.UseCase(
  name: 'Mixed kanji/kana',
  type: JapaneseText,
  path: 'Common',
)
Widget buildJapaneseTextMixed(BuildContext context) {
  return JapaneseText(
    word: '食べる',
    reading: 'たべる',
    style: const TextStyle(fontSize: 28),
  );
}

@widgetbook.UseCase(name: 'Kana only', type: JapaneseText, path: 'Common')
Widget buildJapaneseTextKana(BuildContext context) {
  return JapaneseText(
    word: 'たべる',
    reading: 'たべる',
    style: const TextStyle(fontSize: 28),
  );
}

// ── JlptLevelCard / LevelBadge ────────────────────────────────────────────────

@widgetbook.UseCase(name: 'N5', type: JlptLevelCard, path: 'Common')
Widget buildJlptLevelCardN5(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: JlptLevelCard(code: 'N5', subtitle: '100 kanji', onTap: () {}),
  );
}

@widgetbook.UseCase(name: 'N1', type: JlptLevelCard, path: 'Common')
Widget buildJlptLevelCardN1(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: JlptLevelCard(code: 'N1', subtitle: '2000+ kanji', onTap: () {}),
  );
}

@widgetbook.UseCase(name: 'Default', type: LevelBadge, path: 'Common')
Widget buildLevelBadge(BuildContext context) {
  return LevelBadge(code: 'N3', color: levelColor('N3'));
}

// ── SectionLabel ──────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: SectionLabel, path: 'Common')
Widget buildSectionLabel(BuildContext context) {
  return const SectionLabel('Stroke order');
}

// ── SectionHeader ─────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: SectionHeader, path: 'Common')
Widget buildSectionHeader(BuildContext context) {
  return SectionHeader(
    title: 'Kanji',
    subtitle: 'N5–N1 characters with stroke order',
    glyph: '漢',
    color: Theme.of(context).colorScheme.primary,
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

// ── AppButton ─────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Filled', type: AppButton, path: 'Common')
Widget buildAppButtonFilled(BuildContext context) {
  return AppButton(label: 'Start practice', onPressed: () {});
}

@widgetbook.UseCase(name: 'Tonal', type: AppButton, path: 'Common')
Widget buildAppButtonTonal(BuildContext context) {
  return AppButton(
    label: 'Learn more',
    variant: AppButtonVariant.tonal,
    onPressed: () {},
  );
}

@widgetbook.UseCase(name: 'Outlined', type: AppButton, path: 'Common')
Widget buildAppButtonOutlined(BuildContext context) {
  return AppButton(
    label: 'Skip',
    variant: AppButtonVariant.outlined,
    onPressed: () {},
  );
}

@widgetbook.UseCase(name: 'Text', type: AppButton, path: 'Common')
Widget buildAppButtonText(BuildContext context) {
  return AppButton(
    label: 'Cancel',
    variant: AppButtonVariant.text,
    onPressed: () {},
  );
}

@widgetbook.UseCase(name: 'Danger', type: AppButton, path: 'Common')
Widget buildAppButtonDanger(BuildContext context) {
  return AppButton(
    label: 'Reset progress',
    variant: AppButtonVariant.danger,
    onPressed: () {},
  );
}

@widgetbook.UseCase(name: 'Small', type: AppButton, path: 'Common')
Widget buildAppButtonSmall(BuildContext context) {
  return AppButton(
    label: 'Filter',
    size: AppButtonSize.small,
    onPressed: () {},
  );
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

// ── ProgressRow ───────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Partial', type: ProgressRow, path: 'Common')
Widget buildProgressRowPartial(BuildContext context) {
  return const ProgressRow(known: 42, total: 100);
}

@widgetbook.UseCase(name: 'Complete', type: ProgressRow, path: 'Common')
Widget buildProgressRowComplete(BuildContext context) {
  return const ProgressRow(known: 100, total: 100);
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

// ── SpeakButton ───────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: SpeakButton, path: 'Common')
Widget buildSpeakButton(BuildContext context) {
  return SpeakButton(
    text: '日本語',
    color: Theme.of(context).colorScheme.primary,
    size: 28,
  );
}

// ── ReviewProgressInfo ───────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'New card', type: ReviewProgressInfo, path: 'Common')
Widget buildReviewProgressInfoNew(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: ReviewProgressInfo(srsCard: null),
  );
}

@widgetbook.UseCase(
  name: 'Has SRS data',
  type: ReviewProgressInfo,
  path: 'Common',
)
Widget buildReviewProgressInfoWithCard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ReviewProgressInfo(
      srsCard: Card(
        cardId: 1,
        due: DateTime.now().add(const Duration(days: 3)),
      ),
    ),
  );
}
