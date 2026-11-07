import 'package:flutter/material.dart';
import 'package:fsrs/fsrs.dart' show Rating;
import 'package:intl/intl.dart';

import '../../../core/srs/session_summary.dart';
import '../../../core/theme/app_brand_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../models/practice_answer.dart';
import '../common/action/app_button.dart';
import '../common/decoration/slide_in.dart';
import '../common/label/section_label.dart';
import '../common/surface/card_container.dart';

/// The end of a session: what happened, what to look at again, when the cards
/// come back, and what to do next.
///
/// Three shapes from the same inputs. A graded session reports grades, the
/// streak and the schedule; one that finished the day's reviews with nothing
/// missed leads with that; free practice ([gradesRecorded] false) says nothing
/// was recorded and offers another round instead. Everything is handed in: the
/// screen reads the providers, this only lays the answers out.
class SessionSummary extends StatelessWidget {
  final List<SessionAnswer> answers;
  final String elapsedLabel;

  /// False for free practice: no streak, no schedule, pass/fail only.
  final bool gradesRecorded;
  final bool fourPointGrading;

  final int streakDays;
  final int dueLeft;
  final int newLeft;

  /// When this session's cards come back. Null when nothing was scheduled.
  final ComingBack? comingBack;

  final VoidCallback onDone;
  final VoidCallback? onContinue;
  final VoidCallback? onPracticeMistakes;
  final VoidCallback? onPracticeAll;
  final VoidCallback? onOpenAnswers;

  const SessionSummary({
    super.key,
    required this.answers,
    required this.elapsedLabel,
    required this.gradesRecorded,
    required this.fourPointGrading,
    required this.onDone,
    this.streakDays = 0,
    this.dueLeft = 0,
    this.newLeft = 0,
    this.comingBack,
    this.onContinue,
    this.onPracticeMistakes,
    this.onPracticeAll,
    this.onOpenAnswers,
  });

  List<SessionAnswer> get _lookAgain => [
    for (final a in answers)
      if (needsAnotherLook(a.rating, fourPointGrading: fourPointGrading)) a,
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final AppTokens t = context.tokens;
    final List<SessionAnswer> lookAgain = _lookAgain;
    final int remembered = answers.where((a) => a.isCorrect).length;
    final bool allDone =
        gradesRecorded &&
        lookAgain.isEmpty &&
        dueLeft == 0 &&
        answers.isNotEmpty;

    final String headline = !gradesRecorded
        ? l.summaryPracticeTitle(remembered, answers.length)
        : allDone
        ? l.summaryAllDoneTitle
        : l.summaryReviewedTitle(answers.length);
    final String meta = lookAgain.isEmpty
        ? l.summaryMetaPerfect(elapsedLabel)
        : l.summaryMetaMixed(
            elapsedLabel,
            answers.length - lookAgain.length,
            lookAgain.length,
          );

    var order = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!gradesRecorded) ...[
          SlideIn(order: order++, child: const _FreePracticeNote()),
          const SizedBox(height: AppDimens.spaceMd),
        ],
        SlideIn(
          order: order++,
          child: allDone
              ? _DoneHero(headline: headline, meta: meta)
              : _Header(
                  label: gradesRecorded
                      ? l.summarySessionComplete
                      : l.summaryPracticeComplete,
                  headline: headline,
                  meta: meta,
                ),
        ),
        if (gradesRecorded && streakDays > 0) ...[
          const SizedBox(height: AppDimens.spaceMd),
          SlideIn(
            order: order++,
            child: _StreakRow(days: streakDays),
          ),
        ],
        const SizedBox(height: AppDimens.spaceMd),
        SlideIn(
          order: order++,
          child: _HowItWent(
            ratings: [for (final a in answers) a.rating],
            fourPointGrading: fourPointGrading && gradesRecorded,
          ),
        ),
        if (lookAgain.isNotEmpty) ...[
          const SizedBox(height: AppDimens.spaceMd),
          SlideIn(
            order: order++,
            child: _LookAgain(
              answers: lookAgain,
              total: answers.length,
              title: gradesRecorded ? l.summaryLookAgain : l.summaryNotYet,
              onOpenAnswers: onOpenAnswers,
            ),
          ),
        ],
        if (gradesRecorded && comingBack != null) ...[
          const SizedBox(height: AppDimens.spaceMd),
          SlideIn(
            order: order++,
            child: _ComingBack(
              comingBack: comingBack!,
              total: answers.length,
              onOpenAnswers: lookAgain.isEmpty ? onOpenAnswers : null,
            ),
          ),
        ],
        const SizedBox(height: AppDimens.spaceLg),
        SlideIn(
          order: order++,
          child: _Actions(
            gradesRecorded: gradesRecorded,
            allDone: allDone,
            mistakes: lookAgain.length,
            total: answers.length,
            dueLeft: dueLeft,
            newLeft: newLeft,
            onDone: onDone,
            onContinue: onContinue,
            onPracticeMistakes: onPracticeMistakes,
            onPracticeAll: onPracticeAll,
            hintColor: t.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _FreePracticeNote extends StatelessWidget {
  const _FreePracticeNote();

  @override
  Widget build(BuildContext context) {
    final AppTokens t = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceCozy,
        vertical: AppDimens.spaceCozy,
      ),
      decoration: BoxDecoration(
        color: t.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: t.onPrimaryContainer,
          ),
          const SizedBox(width: AppDimens.spaceSnug),
          Expanded(
            child: Text(
              context.l10n.summaryFreePracticeNote,
              style: AppTextStyles.bodySmall.copyWith(
                color: t.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String label;
  final String headline;
  final String meta;

  const _Header({
    required this.label,
    required this.headline,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {
    final AppTokens t = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(label),
          const SizedBox(height: AppDimens.spaceTight),
          Text(
            headline,
            style: AppTextStyles.headlineLarge.copyWith(
              color: t.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppDimens.spaceTight),
          Text(
            meta,
            style: AppTextStyles.body.copyWith(color: t.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// The day's reviews are finished with nothing missed: a check that pops in
/// over a ring, then the headline.
class _DoneHero extends StatefulWidget {
  final String headline;
  final String meta;

  const _DoneHero({required this.headline, required this.meta});

  static const double _size = 120;

  @override
  State<_DoneHero> createState() => _DoneHeroState();
}

class _DoneHeroState extends State<_DoneHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: AppMotion.long,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pop.status != AnimationStatus.dismissed) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _pop.value = 1;
    } else {
      _pop.forward();
    }
  }

  @override
  void dispose() {
    _pop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppTokens t = context.tokens;
    const double size = _DoneHero._size;
    return Column(
      children: [
        const SizedBox(height: AppDimens.spaceMd),
        ScaleTransition(
          scale: Tween(
            begin: 0.6,
            end: 1.0,
          ).animate(CurvedAnimation(parent: _pop, curve: AppMotion.pop)),
          child: Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(AppDimens.spaceCozy),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: t.primaryContainer, width: 2),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: t.primaryContainer,
              ),
              child: Icon(
                Icons.check_rounded,
                size: 52,
                color: t.onPrimaryContainer,
                semanticLabel: widget.headline,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        Text(
          widget.headline,
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineLarge.copyWith(
            color: t.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppDimens.spaceTight),
        Text(
          widget.meta,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(color: t.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _StreakRow extends StatelessWidget {
  final int days;

  const _StreakRow({required this.days});

  static const double _badge = 44;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final AppTokens t = context.tokens;
    return CardContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceCozy,
        vertical: AppDimens.spaceCozy,
      ),
      child: Row(
        children: [
          Container(
            width: _badge,
            height: _badge,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppBrandColors.streakStart, AppBrandColors.streakEnd],
              ),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppDimens.spaceCozy),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.summaryStreak(days),
                  style: AppTextStyles.body.copyWith(
                    color: t.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  l.summaryStreakToday(days + 1),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: t.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A bar split by grade, and the count under each.
class _HowItWent extends StatelessWidget {
  final List<Rating> ratings;
  final bool fourPointGrading;

  const _HowItWent({required this.ratings, required this.fourPointGrading});

  static const double _barHeight = 12;
  static const double _barGap = 3;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final AppTokens t = context.tokens;
    final Map<Rating, int> counts = gradeCounts(ratings);

    // Each grade's bar colour and the colour its count is written in: the
    // same, except for "not yet", whose pale bar would not read as text.
    final List<({String label, int count, Color bar, Color text})> parts =
        fourPointGrading
        ? [
            (
              label: l.ratingAgain,
              count: counts[Rating.again]!,
              bar: t.error,
              text: t.error,
            ),
            (
              label: l.ratingHard,
              count: counts[Rating.hard]!,
              bar: t.warning,
              text: t.warning,
            ),
            (
              label: l.ratingGood,
              count: counts[Rating.good]!,
              bar: t.success,
              text: t.success,
            ),
            (
              label: l.ratingEasy,
              count: counts[Rating.easy]!,
              bar: t.success.withValues(alpha: 0.6),
              text: t.success,
            ),
          ]
        : [
            (
              label: l.summaryGotIt,
              count: ratings.length - counts[Rating.again]!,
              bar: t.primary,
              text: t.primary,
            ),
            (
              label: l.summaryNotYet,
              count: counts[Rating.again]!,
              bar: t.outlineVariant,
              text: t.onSurfaceVariant,
            ),
          ];
    final shown = parts.where((p) => p.count > 0).toList();

    return CardContainer(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionLabel(l.summaryHowItWent),
          const SizedBox(height: AppDimens.spaceCozy),
          Semantics(
            label: [for (final p in shown) '${p.count} ${p.label}'].join(', '),
            excludeSemantics: true,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_barHeight / 2),
              child: SizedBox(
                height: _barHeight,
                child: Row(
                  // Stretched, or the segments, which have no content of
                  // their own, are zero pixels tall.
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < shown.length; i++) ...[
                      if (i > 0) const SizedBox(width: _barGap),
                      Expanded(
                        flex: shown[i].count,
                        child: ColoredBox(color: shown[i].bar),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceCozy),
          Row(
            children: [
              for (final p in parts)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${p.count}',
                        style: AppTextStyles.title.copyWith(
                          fontWeight: FontWeight.w700,
                          color: p.count == 0 ? t.outline : p.text,
                        ),
                      ),
                      Text(
                        p.label,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: t.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LookAgain extends StatelessWidget {
  final List<SessionAnswer> answers;
  final int total;
  final String title;
  final VoidCallback? onOpenAnswers;

  const _LookAgain({
    required this.answers,
    required this.total,
    required this.title,
    this.onOpenAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final AppTokens t = context.tokens;
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spaceMd,
              AppDimens.spaceSm,
              AppDimens.spaceXs,
              AppDimens.spaceXs,
            ),
            child: Row(
              children: [
                Expanded(child: SectionLabel(title)),
                if (onOpenAnswers != null)
                  AppButton(
                    label: l.summaryAllAnswers(total),
                    variant: AppButtonVariant.text,
                    size: AppButtonSize.small,
                    onPressed: onOpenAnswers,
                  ),
              ],
            ),
          ),
          for (final a in answers) ...[
            Divider(height: 1, thickness: 1, color: t.outlineVariant),
            _LookAgainRow(answer: a, onTap: onOpenAnswers),
          ],
        ],
      ),
    );
  }
}

class _LookAgainRow extends StatelessWidget {
  final SessionAnswer answer;
  final VoidCallback? onTap;

  const _LookAgainRow({required this.answer, this.onTap});

  static const double _glyphMinWidth = 44;
  static const double _glyphMaxWidth = 96;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final AppTokens t = context.tokens;
    final bool missed = answer.rating == Rating.again;
    final String? given = answer.given;
    final bool wrongPick =
        missed && given != null && given != answer.summary.answer;

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceSnug,
          ),
          child: Row(
            children: [
              // One kana fills the narrow box; a word widens it, and a long
              // word shrinks to fit rather than being cut to an ellipsis.
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: _glyphMinWidth,
                  maxWidth: _glyphMaxWidth,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    answer.summary.item,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: AppTextStyles.jpLarge.copyWith(color: t.onSurface),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.iconTextGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      answer.summary.answer,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: t.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (wrongPick)
                      Text.rich(
                        TextSpan(
                          text: '${l.summaryYouChose} ',
                          children: [
                            TextSpan(
                              text: given,
                              style: TextStyle(
                                color: t.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: t.onSurfaceVariant,
                        ),
                      )
                    else if (!missed)
                      Text(
                        l.summaryHardNote,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: t.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimens.spaceSm),
              _GradeChip(rating: answer.rating),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradeChip extends StatelessWidget {
  final Rating rating;

  const _GradeChip({required this.rating});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final AppTokens t = context.tokens;
    final bool again = rating == Rating.again;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSnug,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: again ? t.errorContainer : t.warningContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      ),
      child: Text(
        again ? l.ratingAgain : l.ratingHard,
        style: AppTextStyles.labelSmall.copyWith(
          color: again ? t.error : t.warning,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ComingBack extends StatelessWidget {
  final ComingBack comingBack;
  final int total;
  final VoidCallback? onOpenAnswers;

  const _ComingBack({
    required this.comingBack,
    required this.total,
    this.onOpenAnswers,
  });

  String? _nextLabel(BuildContext context) {
    final DateTime? next = comingBack.next;
    if (next == null) return null;
    final l = context.l10n;
    final String time = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(next),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final int days = DateTime(
      next.year,
      next.month,
      next.day,
    ).difference(today).inDays;
    if (days <= 0) return l.summaryNextAt(time);
    if (days == 1) return l.summaryNextTomorrow(time);
    final String locale = Localizations.localeOf(context).toString();
    return l.summaryNextOn(DateFormat.MMMd(locale).format(next));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final AppTokens t = context.tokens;
    final String? next = _nextLabel(context);
    final spans = [
      (count: comingBack.laterToday, label: l.summaryLaterToday),
      (count: comingBack.tomorrow, label: l.summaryTomorrow),
      (count: comingBack.later, label: l.summaryLater),
    ].where((s) => s.count > 0).toList();

    return CardContainer(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(child: SectionLabel(l.summaryComingBack)),
              if (next != null)
                Text(
                  next,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: t.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceCozy),
          Row(
            children: [
              for (var i = 0; i < spans.length; i++) ...[
                if (i > 0) const SizedBox(width: AppDimens.spaceSm),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceCozy,
                      vertical: AppDimens.spaceSnug,
                    ),
                    decoration: BoxDecoration(
                      color: t.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${spans[i].count}',
                          style: AppTextStyles.title.copyWith(
                            color: t.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          spans[i].label,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: t.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (onOpenAnswers != null) ...[
            const SizedBox(height: AppDimens.spaceSm),
            Align(
              alignment: Alignment.centerLeft,
              child: AppButton(
                label: l.summaryAllAnswers(total),
                variant: AppButtonVariant.text,
                size: AppButtonSize.small,
                onPressed: onOpenAnswers,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// What to do next. The main button is the most useful next step: more
/// reviews when some are still due, another round in free practice, else done.
class _Actions extends StatelessWidget {
  final bool gradesRecorded;
  final bool allDone;
  final int mistakes;
  final int total;
  final int dueLeft;
  final int newLeft;
  final VoidCallback onDone;
  final VoidCallback? onContinue;
  final VoidCallback? onPracticeMistakes;
  final VoidCallback? onPracticeAll;
  final Color hintColor;

  const _Actions({
    required this.gradesRecorded,
    required this.allDone,
    required this.mistakes,
    required this.total,
    required this.dueLeft,
    required this.newLeft,
    required this.onDone,
    required this.hintColor,
    this.onContinue,
    this.onPracticeMistakes,
    this.onPracticeAll,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final VoidCallback? practiceMistakes = mistakes > 0
        ? onPracticeMistakes
        : null;
    // Everything again is the same round as the misses again when every
    // answer was a miss, so it is only offered when it adds something.
    final VoidCallback? practiceAll =
        practiceMistakes != null && mistakes >= total ? null : onPracticeAll;

    final String? hint;
    final AppButton primary;
    final List<AppButton> secondary;
    // Its own row under the others, when the secondary row is already full.
    AppButton? closing;

    if (!gradesRecorded) {
      hint = null;
      primary = practiceMistakes != null
          ? AppButton(
              label: l.summaryPracticeMistakes(mistakes),
              fullWidth: true,
              onPressed: practiceMistakes,
            )
          : AppButton(
              label: l.summaryPracticeAll(total),
              fullWidth: true,
              onPressed: onPracticeAll,
            );
      secondary = [
        if (practiceMistakes != null && practiceAll != null)
          AppButton(
            label: l.summaryPracticeAll(total),
            variant: AppButtonVariant.outlined,
            fullWidth: true,
            onPressed: practiceAll,
          ),
        AppButton(
          label: l.summaryDone,
          variant: AppButtonVariant.tonal,
          fullWidth: true,
          onPressed: onDone,
        ),
      ];
    } else if (dueLeft > 0 && onContinue != null) {
      hint = l.summaryStillDue(dueLeft);
      primary = AppButton(
        label: l.summaryContinue,
        fullWidth: true,
        onPressed: onContinue,
      );
      secondary = [
        if (practiceMistakes != null)
          AppButton(
            label: l.summaryPracticeMistakes(mistakes),
            variant: AppButtonVariant.outlined,
            fullWidth: true,
            onPressed: practiceMistakes,
          ),
        if (practiceAll != null)
          AppButton(
            label: l.summaryPracticeAll(total),
            variant: AppButtonVariant.outlined,
            fullWidth: true,
            onPressed: practiceAll,
          ),
      ];
      closing = AppButton(
        label: l.summaryDone,
        variant: AppButtonVariant.tonal,
        fullWidth: true,
        onPressed: onDone,
      );
    } else {
      final bool offerNew = allDone && newLeft > 0 && onContinue != null;
      hint = offerNew ? l.summaryRoomForMore(newLeft) : null;
      primary = AppButton(
        label: allDone ? l.summaryDoneForToday : l.summaryDone,
        fullWidth: true,
        onPressed: onDone,
      );
      secondary = [
        if (practiceMistakes != null)
          AppButton(
            label: l.summaryPracticeMistakes(mistakes),
            variant: AppButtonVariant.outlined,
            fullWidth: true,
            onPressed: practiceMistakes,
          ),
        if (offerNew)
          AppButton(
            label: l.summaryLearnNew(newLeft),
            variant: AppButtonVariant.outlined,
            fullWidth: true,
            onPressed: onContinue,
          ),
        // A finished day offers new items or the misses, never both (it has
        // none), so this is always the second of at most two.
        if (practiceAll != null)
          AppButton(
            label: l.summaryPracticeAll(total),
            variant: AppButtonVariant.outlined,
            fullWidth: true,
            onPressed: practiceAll,
          ),
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hint != null) ...[
          Text(
            hint,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(color: hintColor),
          ),
          const SizedBox(height: AppDimens.spaceSnug),
        ],
        primary,
        if (secondary.isNotEmpty) ...[
          const SizedBox(height: AppDimens.spaceSnug),
          Row(
            children: [
              for (var i = 0; i < secondary.length; i++) ...[
                if (i > 0) const SizedBox(width: AppDimens.spaceSnug),
                Expanded(child: secondary[i]),
              ],
            ],
          ),
        ],
        if (closing != null) ...[
          const SizedBox(height: AppDimens.spaceSnug),
          closing,
        ],
      ],
    );
  }
}
