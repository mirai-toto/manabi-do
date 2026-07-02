import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/home_provider.dart';
import '../../widgets/widgets.dart';
import '../practice/practice_session_screen.dart';
import 'home_domain_cards.dart';
import 'home_header.dart';
import 'home_review_queues.dart';

const _kTabCharacters = 1;
const _kTabVocabulary = 2;
const _kTabGrammar = 3;

String _greeting(BuildContext context) {
  final hour = DateTime.now().hour;
  final l = context.l10n;
  if (hour < 12) return l.greetingMorning;
  if (hour < 18) return l.greetingAfternoon;
  return l.greetingEvening;
}

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

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.tokens;

    final totalKanji = ref.watch(totalKanjiProvider).asData?.value ?? 0;
    final totalKana = ref.watch(totalKanaProvider).asData?.value ?? 0;
    final totalVocab = ref.watch(totalVocabProvider).asData?.value ?? 0;

    final kanaDue = ref.watch(kanaDueCountProvider).asData?.value ?? 0;
    final kanaNew = ref.watch(kanaNewCountProvider).asData?.value ?? 0;
    final kanjiDue = ref.watch(kanjiDueCountProvider).asData?.value ?? 0;
    final kanjiNew = ref.watch(kanjiNewCountProvider).asData?.value ?? 0;
    final vocabDue = ref.watch(vocabDueCountProvider).asData?.value ?? 0;
    final vocabNew = ref.watch(vocabNewCountProvider).asData?.value ?? 0;

    void goTo(int tab) => ref.read(selectedTabProvider.notifier).select(tab);

    void openKanaPractice() {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => PracticeSessionScreen(
            title: l.kana,
            color: t.characters,
            loadQueue: loadKanaQueue,
          ),
        ),
      );
    }

    void openKanjiPractice() {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => PracticeSessionScreen(
            title: l.tabKanji,
            color: t.characters,
            loadQueue: loadKanjiQueue,
          ),
        ),
      );
    }

    void openVocabPractice() {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => PracticeSessionScreen(
            title: l.navVocab,
            color: t.vocabulary,
            loadQueue: loadVocabQueue,
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimens.screenMaxWidth),
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
          children: [
            HomeHeader(
              greeting: _greeting(context),
              subtitle: l.greetingSubtitle,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
              ),
              child: Column(
                children: [
                  HomeDomainCards(
                    totalKana: totalKana,
                    totalKanji: totalKanji,
                    totalVocab: totalVocab,
                    kanaDue: kanaDue,
                    kanaNew: kanaNew,
                    kanjiDue: kanjiDue,
                    kanjiNew: kanjiNew,
                    vocabDue: vocabDue,
                    vocabNew: vocabNew,
                    onKanaTap: () => goTo(_kTabCharacters),
                    onKanjiTap: () => goTo(_kTabCharacters),
                    onVocabTap: () => goTo(_kTabVocabulary),
                    onGrammarTap: () => goTo(_kTabGrammar),
                    onKanaPractice: openKanaPractice,
                    onKanjiPractice: openKanjiPractice,
                    onVocabPractice: openVocabPractice,
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  StreakCard(
                    days: ref.watch(streakDaysProvider).asData?.value ?? 0,
                    label: l.streakLabel,
                    subtitle: l.streakSubtitle,
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
