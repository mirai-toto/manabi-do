import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/jlpt_level.dart';
import '../../../l10n/l10n.dart';
import '../../providers/database_provider.dart';
import '../../providers/grammar_provider.dart';
import '../../providers/home_provider.dart';
import '../../services/review_queue_service.dart';
import '../../widgets/widgets.dart';
import '../grammar/grammar_lesson_screen.dart';
import '../practice/practice_session_screen.dart';

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
    ref.invalidate(vocabDueCountProvider);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  static const _weekdayKanji = ['月', '火', '水', '木', '金', '土', '日'];

  String _japaneseDate(DateTime now) =>
      '${now.month}月${now.day}日 (${_weekdayKanji[now.weekday - 1]}曜日)';

  void _startReviews() {
    final l = context.l10n;
    final t = context.tokens;
    _openPractice(
      title: l.todaysSession,
      color: t.primary,
      loadQueue: loadAllDueQueue,
    );
  }

  void _openPractice({
    required String title,
    required Color color,
    required LoadQueue loadQueue,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => PracticeSessionScreen(
          title: title,
          color: color,
          loadQueue: loadQueue,
        ),
      ),
    );
  }

  void _continueLesson(GrammarContinueTarget target) {
    ref.read(databaseProvider).markGrammarLessonStarted(target.lesson.id);
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => GrammarLessonScreen(
          lessonId: target.lesson.id,
          title: target.lesson.title,
          blocks: target.lesson.blocks,
          levelColor: levelColor(target.level),
        ),
      ),
    );
  }

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
    final vocabProgress =
        ref.watch(vocabProgressProvider).asData?.value ?? noProgress;

    final kanaDue = ref.watch(kanaDueCountProvider).asData?.value ?? 0;
    final kanaNew = ref.watch(kanaNewCountProvider).asData?.value ?? 0;
    final kanjiDue = ref.watch(kanjiDueCountProvider).asData?.value ?? 0;
    final kanjiNew = ref.watch(kanjiNewCountProvider).asData?.value ?? 0;
    final vocabDue = ref.watch(vocabDueCountProvider).asData?.value ?? 0;
    final vocabNew = ref.watch(vocabNewCountProvider).asData?.value ?? 0;

    final streakDays = ref.watch(streakDaysProvider).asData?.value ?? 0;
    final weekActivity =
        ref.watch(weekActivityProvider).asData?.value ?? List.filled(7, false);
    final continueTarget = ref.watch(grammarContinueProvider).asData?.value;

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
                  TodaysSessionCard(
                    kanaDue: kanaDue,
                    kanjiDue: kanjiDue,
                    vocabDue: vocabDue,
                    newTotal: kanaNew + kanjiNew + vocabNew,
                    onStart: _startReviews,
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  SectionLabel(l.yourDecks),
                  const SizedBox(height: AppDimens.spaceSm),
                  DeckRow(
                    title: l.kana,
                    glyph: 'か',
                    color: t.characters,
                    known: kanaProgress.known,
                    seen: kanaProgress.seen,
                    newToday: kanaNew,
                    due: kanaDue,
                    onTap: () => _openPractice(
                      title: l.kana,
                      color: t.characters,
                      loadQueue: loadKanaQueue,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceSm),
                  DeckRow(
                    title: l.tabKanji,
                    glyph: '字',
                    color: t.characters,
                    known: kanjiProgress.known,
                    seen: kanjiProgress.seen,
                    newToday: kanjiNew,
                    due: kanjiDue,
                    onTap: () => _openPractice(
                      title: l.tabKanji,
                      color: t.characters,
                      loadQueue: loadKanjiQueue,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceSm),
                  DeckRow(
                    title: l.sectionVocabulary,
                    glyph: '語',
                    color: t.vocabulary,
                    known: vocabProgress.known,
                    seen: vocabProgress.seen,
                    newToday: vocabNew,
                    due: vocabDue,
                    onTap: () => _openPractice(
                      title: l.sectionVocabulary,
                      color: t.vocabulary,
                      loadQueue: loadVocabQueue,
                    ),
                  ),
                  if (continueTarget != null) ...[
                    const SizedBox(height: AppDimens.spaceLg),
                    SectionLabel(l.keepLearning),
                    const SizedBox(height: AppDimens.spaceSm),
                    ContinueLessonCard(
                      title: continueTarget.lesson.title,
                      subtitle:
                          '${continueTarget.themeTitle} · '
                          '${continueTarget.chapterTitle}',
                      lessonIndex: continueTarget.lessonIndex,
                      lessonCount: continueTarget.chapterLessonCount,
                      color: t.primary,
                      onTap: () => _continueLesson(continueTarget),
                    ),
                  ],
                  const SizedBox(height: AppDimens.spaceLg),
                  WeekStrip(
                    reviewedDays: weekActivity,
                    todayIndex: DateTime.now().weekday - 1,
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
