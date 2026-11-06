import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/home_settings_provider.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../providers/grammar_provider.dart';
import '../../providers/home_provider.dart';
import '../../services/review_queue_service.dart';
import '../../widgets/widgets.dart';
import '../grammar/grammar_navigation.dart';
import '../practice/practice_launcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _refresh(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _refresh() {
    ref.invalidate(kanaDueCountProvider);
    ref.invalidate(kanjiDueCountProvider);
    ref.invalidate(vocabularyDueCountProvider);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  static const _weekdayKanji = ['月', '火', '水', '木', '金', '土', '日'];

  String _japaneseDate(DateTime now) =>
      '${now.month}月${now.day}日 (${_weekdayKanji[now.weekday - 1]}曜日)';

  void _continueLesson(GrammarContinueTarget target) =>
      openGrammarLesson(context, ref, target.lesson, levelColor(target.level));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.tokens;
    final locale = Localizations.localeOf(context).toString();

    const noProgress = (known: 0, seen: 0);
    final kanaProgress =
        ref.watch(kanaProgressProvider).asData?.value ?? noProgress;
    final kanjiProgress =
        ref.watch(kanjiProgressProvider).asData?.value ?? noProgress;
    final vocabularyProgress =
        ref.watch(vocabularyProgressProvider).asData?.value ?? noProgress;

    final kanaDue = ref.watch(kanaDueCountProvider).asData?.value ?? 0;
    final kanaNew = ref.watch(kanaNewCountProvider).asData?.value ?? 0;
    final kanjiDue = ref.watch(kanjiDueCountProvider).asData?.value ?? 0;
    final kanjiNew = ref.watch(kanjiNewCountProvider).asData?.value ?? 0;
    final vocabularyDue =
        ref.watch(vocabularyDueCountProvider).asData?.value ?? 0;
    final vocabularyNew =
        ref.watch(vocabularyNewCountProvider).asData?.value ?? 0;

    final streakDays = ref.watch(streakDaysProvider).asData?.value ?? 0;
    final weekActivity =
        ref.watch(weekActivityProvider).asData?.value ?? List.filled(7, false);
    final continueTarget = ref.watch(grammarContinueProvider).asData?.value;

    final show = ref.watch(homeSettingsProvider);
    final domains = [
      if (show.showKana) (glyph: 'か', due: kanaDue),
      if (show.showKanji) (glyph: '字', due: kanjiDue),
      if (show.showVocabulary) (glyph: '語', due: vocabularyDue),
    ];
    final newTotal =
        (show.showKana ? kanaNew : 0) +
        (show.showKanji ? kanjiNew : 0) +
        (show.showVocabulary ? vocabularyNew : 0);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimens.screenMaxWidth),
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
          children: [
            HomeHeader(
              title: _japaneseDate(DateTime.now()),
              subtitle: DateFormat.MMMMEEEEd(locale).format(DateTime.now()),
              trailing: StreakPill(days: streakDays),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeSlideIn(
                    order: 0,
                    child: TodaysSessionCard(
                      domains: domains,
                      newTotal: newTotal,
                      onStart: () => openTodaysSession(context),
                    ),
                  ),
                  if (domains.isNotEmpty) ...[
                    const SizedBox(height: AppDimens.spaceLg),
                    SectionLabel(l.yourDecks),
                    if (show.showKana) ...[
                      const SizedBox(height: AppDimens.spaceSm),
                      FadeSlideIn(
                        order: 1,
                        child: DeckRow(
                          title: l.kana,
                          glyph: 'か',
                          color: t.primary,
                          known: kanaProgress.known,
                          seen: kanaProgress.seen,
                          newToday: kanaNew,
                          due: kanaDue,
                          onTap: () => openPracticeSession(
                            context,
                            title: l.kana,
                            color: t.primary,
                            loadQueue: (ref) =>
                                ref.read(reviewQueueServiceProvider).kana(),
                          ),
                        ),
                      ),
                    ],
                    if (show.showKanji) ...[
                      const SizedBox(height: AppDimens.spaceSm),
                      FadeSlideIn(
                        order: 2,
                        child: DeckRow(
                          title: l.tabKanji,
                          glyph: '字',
                          color: t.primary,
                          known: kanjiProgress.known,
                          seen: kanjiProgress.seen,
                          newToday: kanjiNew,
                          due: kanjiDue,
                          onTap: () => openPracticeSession(
                            context,
                            title: l.tabKanji,
                            color: t.primary,
                            loadQueue: (ref) =>
                                ref.read(reviewQueueServiceProvider).kanji(),
                          ),
                        ),
                      ),
                    ],
                    if (show.showVocabulary) ...[
                      const SizedBox(height: AppDimens.spaceSm),
                      FadeSlideIn(
                        order: 3,
                        child: DeckRow(
                          title: l.sectionVocabulary,
                          glyph: '語',
                          color: t.primary,
                          known: vocabularyProgress.known,
                          seen: vocabularyProgress.seen,
                          newToday: vocabularyNew,
                          due: vocabularyDue,
                          onTap: () => openPracticeSession(
                            context,
                            title: l.sectionVocabulary,
                            color: t.primary,
                            loadQueue: (ref) => ref
                                .read(reviewQueueServiceProvider)
                                .vocabulary(),
                          ),
                        ),
                      ),
                    ],
                  ],
                  if (continueTarget != null) ...[
                    const SizedBox(height: AppDimens.spaceLg),
                    SectionLabel(l.keepLearning),
                    const SizedBox(height: AppDimens.spaceSm),
                    FadeSlideIn(
                      order: 4,
                      child: ContinueLessonCard(
                        title: continueTarget.lesson.title,
                        subtitle:
                            '${continueTarget.themeTitle} · '
                            '${continueTarget.chapterTitle}',
                        lessonIndex: continueTarget.lessonIndex,
                        lessonCount: continueTarget.chapterLessonCount,
                        color: t.primary,
                        onTap: () => _continueLesson(continueTarget),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppDimens.spaceLg),
                  FadeSlideIn(
                    order: 5,
                    child: WeekStrip(
                      reviewedDays: weekActivity,
                      todayIndex: DateTime.now().weekday - 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
