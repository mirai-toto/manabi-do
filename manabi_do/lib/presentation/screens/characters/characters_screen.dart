import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../domain/data/kana_data.dart';
import '../../../l10n/l10n.dart';
import '../../providers/kana_progress_provider.dart';
import '../../providers/kana_provider.dart';
import '../../widgets/widgets.dart';
import 'kana_practice_screen.dart';
import 'kana_tab.dart';
import 'kanji_tab.dart';

class CharactersScreen extends ConsumerStatefulWidget {
  const CharactersScreen({super.key});

  @override
  ConsumerState<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends ConsumerState<CharactersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final kanaAsync = ref.watch(kanaDataProvider);
    final knownHiragana = ref.watch(knownHiraganaProvider).asData?.value ?? {};
    final knownKatakana = ref.watch(knownKatakanaProvider).asData?.value ?? {};

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimens.screenMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CharactersHeader(tabIndex: _tabController.index, kanaData: kanaAsync.asData?.value),
            SegmentedTabBar(
              controller: _tabController,
              labels: [l.tabHiragana, l.tabKatakana, l.tabKanji],
            ),
            Expanded(
              child: switch (kanaAsync) {
                AsyncData(:final value) => TabBarView(
                    controller: _tabController,
                    children: [
                      KanaTabView(
                        rows: value.hiragana,
                        knownIds: knownHiragana,
                        type: 'hiragana',
                        onPractice: () => _openPractice('hiragana'),
                      ),
                      KanaTabView(
                        rows: value.katakana,
                        knownIds: knownKatakana,
                        type: 'katakana',
                        onPractice: () => _openPractice('katakana'),
                      ),
                      const KanjiTabView(),
                    ],
                  ),
                AsyncError(:final error) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimens.spaceLg),
                      child: Text(
                        'Database error: $error',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openPractice(String type) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => KanaPracticeScreen(type: type)),
    );
  }
}

class _CharactersHeader extends StatelessWidget {
  final int tabIndex;
  final KanaData? kanaData;
  const _CharactersHeader({required this.tabIndex, required this.kanaData});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final total = kanaData?.total;
    final subtitle = total != null
        ? l.charactersSubtitle(total)
        : l.charactersSubtitleShort;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMd, AppDimens.spaceMd, AppDimens.spaceMd, AppDimens.spaceSm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.sectionCharacters,
                  style: AppTextStyles.headline.copyWith(color: t.onSurface),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text('字', style: AppTextStyles.jpDisplay.copyWith(color: t.characters)),
        ],
      ),
    );
  }
}
