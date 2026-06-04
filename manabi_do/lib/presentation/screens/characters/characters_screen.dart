import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../domain/data/kana_data.dart';
import '../../../l10n/l10n.dart';
import '../../providers/kana_provider.dart';
import '../../widgets/widgets.dart';
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
  final Set<String> _knownHiragana = {};
  final Set<String> _knownKatakana = {};

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

  void _toggleHiragana(String kana) => setState(
        () => _knownHiragana.contains(kana)
            ? _knownHiragana.remove(kana)
            : _knownHiragana.add(kana),
      );

  void _toggleKatakana(String kana) => setState(
        () => _knownKatakana.contains(kana)
            ? _knownKatakana.remove(kana)
            : _knownKatakana.add(kana),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final kanaAsync = ref.watch(kanaDataProvider);
    final kanaData = kanaAsync.asData?.value;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimens.screenMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CharactersHeader(tabIndex: _tabController.index, kanaData: kanaData),
            SegmentedTabBar(
              controller: _tabController,
              labels: [l.tabHiragana, l.tabKatakana, l.tabKanji],
            ),
            Expanded(
              child: _CharactersBody(
                tabController: _tabController,
                kanaData: kanaData,
                knownHiragana: _knownHiragana,
                knownKatakana: _knownKatakana,
                onToggleHiragana: _toggleHiragana,
                onToggleKatakana: _toggleKatakana,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CharactersBody extends StatelessWidget {
  final TabController tabController;
  final KanaData? kanaData;
  final Set<String> knownHiragana;
  final Set<String> knownKatakana;
  final void Function(String) onToggleHiragana;
  final void Function(String) onToggleKatakana;

  const _CharactersBody({
    required this.tabController,
    required this.kanaData,
    required this.knownHiragana,
    required this.knownKatakana,
    required this.onToggleHiragana,
    required this.onToggleKatakana,
  });

  @override
  Widget build(BuildContext context) {
    if (kanaData == null) return const Center(child: CircularProgressIndicator());
    return TabBarView(
      controller: tabController,
      children: [
        KanaTabView(rows: kanaData!.hiragana, known: knownHiragana, onToggle: onToggleHiragana),
        KanaTabView(rows: kanaData!.katakana, known: knownKatakana, onToggle: onToggleKatakana),
        const KanjiTabView(),
      ],
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
