import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../domain/data/kana_data.dart';
import '../../../l10n/l10n.dart';
import '../../providers/kana_provider.dart';
import '../../providers/kanji_provider.dart' show KanjiLevelData, KanjiListEntry, kanjiListProvider;
import '../../widgets/widgets.dart';

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
            _SegmentedTabBar(
              controller: _tabController,
              labels: [l.tabHiragana, l.tabKatakana, l.tabKanji],
            ),
            Expanded(
              child: kanaData == null
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _KanaTabView(
                          rows: kanaData.hiragana,
                          known: _knownHiragana,
                          onToggle: _toggleHiragana,
                        ),
                        _KanaTabView(
                          rows: kanaData.katakana,
                          known: _knownKatakana,
                          onToggle: _toggleKatakana,
                        ),
                        const _KanjiTabView(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

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
        ? 'Kana · Kanji N5–N1  ·  $total kana'
        : 'Kana · Kanji N5–N1';

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

// ─── Segmented tab bar ────────────────────────────────────────────────────────

class _SegmentedTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> labels;

  const _SegmentedTabBar({required this.controller, required this.labels});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMd, 0, AppDimens.spaceMd, AppDimens.spaceSm,
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: t.surfaceContainer,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        child: TabBar(
          controller: controller,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: t.cardBackground,
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            boxShadow: [
              BoxShadow(
                color: t.onSurface.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          labelColor: t.primary,
          unselectedLabelColor: t.onSurfaceVariant,
          labelStyle: AppTextStyles.labelLarge,
          unselectedLabelStyle: AppTextStyles.labelLarge,
          tabs: labels.map((l) => Tab(text: l)).toList(),
        ),
      ),
    );
  }
}

// ─── Kana tab ─────────────────────────────────────────────────────────────────

class _KanaTabView extends StatelessWidget {
  final List<KanaRow> rows;
  final Set<String> known;
  final void Function(String) onToggle;

  const _KanaTabView({
    required this.rows,
    required this.known,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final allKana = rows.expand((r) => r.kana).toList();
    final knownCount = allKana.where((e) => known.contains(e.kana)).length;

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      children: [
        _ProgressRow(known: knownCount, total: allKana.length),
        for (final row in rows) ...[
          _RowLabel(row.label),
          const SizedBox(height: AppDimens.spaceXs),
          _KanaGrid(row: row, known: known, onToggle: onToggle),
          const SizedBox(height: AppDimens.spaceSm),
        ],
      ],
    );
  }
}

// ─── Progress row ─────────────────────────────────────────────────────────────

class _ProgressRow extends StatelessWidget {
  final int known;
  final int total;
  const _ProgressRow({required this.known, required this.total});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceMd, AppDimens.spaceSm, AppDimens.spaceMd, AppDimens.spaceMd,
      ),
      child: Row(
        children: [
          Text(
            '$known',
            style: AppTextStyles.labelLarge.copyWith(color: t.onSurface),
          ),
          Text(
            ' / $total known',
            style: AppTextStyles.labelLarge.copyWith(color: t.onSurfaceVariant),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(
            child: AppProgressBar(
              progress: total > 0 ? known / total : 0,
              color: t.characters,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Row label ────────────────────────────────────────────────────────────────

class _RowLabel extends StatelessWidget {
  final String label;
  const _RowLabel(this.label);

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.label.copyWith(
          color: t.onSurfaceVariant,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Kana grid ────────────────────────────────────────────────────────────────

class _KanaGrid extends StatelessWidget {
  final KanaRow row;
  final Set<String> known;
  final void Function(String) onToggle;

  const _KanaGrid({required this.row, required this.known, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    const gap = AppDimens.spaceSm;
    const cols = 5;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = (constraints.maxWidth - gap * (cols - 1)) / cols;
          final kanaSize = (cellSize * 0.24).clamp(18.0, 48.0);
          final romajiSize = (cellSize * 0.095).clamp(9.0, 18.0);
          return Row(
            children: [
              for (int i = 0; i < row.entries.length; i++) ...[
                if (i > 0) const SizedBox(width: gap),
                if (row.entries[i] == null)
                  SizedBox(width: cellSize, height: cellSize)
                else
                  KanaCell(
                    kana: row.entries[i]!.kana,
                    romaji: row.entries[i]!.romaji,
                    isKnown: known.contains(row.entries[i]!.kana),
                    onTap: () => onToggle(row.entries[i]!.kana),
                    width: cellSize,
                    height: cellSize,
                    kanaSize: kanaSize,
                    romajiSize: romajiSize,
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

// ─── Kanji level metadata ────────────────────────────────────────────────────

const _kanjiLevels = ['N5', 'N4', 'N3', 'N2', 'N1'];

// ─── Kanji tab ────────────────────────────────────────────────────────────────

class _KanjiTabView extends ConsumerStatefulWidget {
  const _KanjiTabView();

  @override
  ConsumerState<_KanjiTabView> createState() => _KanjiTabViewState();
}

class _KanjiTabViewState extends ConsumerState<_KanjiTabView> {
  String? _selectedLevel;
  final Set<int> _knownIds = {};

  void _toggle(int id) => setState(
        () => _knownIds.contains(id) ? _knownIds.remove(id) : _knownIds.add(id),
      );

  @override
  Widget build(BuildContext context) {
    if (_selectedLevel == null) {
      return _KanjiLevelSelector(
        onSelect: (level) => setState(() => _selectedLevel = level),
      );
    }

    final kanjiAsync = ref.watch(kanjiListProvider(_selectedLevel!));

    if (kanjiAsync is AsyncLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final data = kanjiAsync.asData?.value;
    final kanjiList = data?.kanji ?? [];
    final knownCount = kanjiList.where((k) => _knownIds.contains(k.id)).length;

    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      children: [
        _LevelHeader(
          level: _selectedLevel!,
          label: data?.label,
          onBack: () => setState(() => _selectedLevel = null),
        ),
        _ProgressRow(known: knownCount, total: kanjiList.length),
        _KanjiGrid(
          kanjis: kanjiList,
          knownIds: _knownIds,
          onToggle: _toggle,
        ),
      ],
    );
  }
}

// ─── Level selector ───────────────────────────────────────────────────────────

class _KanjiLevelSelector extends ConsumerWidget {
  final void Function(String) onSelect;
  const _KanjiLevelSelector({required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    return ListView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      children: [
        Text(
          'SELECT A LEVEL',
          style: AppTextStyles.label.copyWith(
            color: t.onSurfaceVariant,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        for (final code in _kanjiLevels)
          _LevelCard(
            code: code,
            data: ref.watch(kanjiListProvider(code)).asData?.value,
            onTap: () => onSelect(code),
          ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String code;
  final KanjiLevelData? data;
  final VoidCallback onTap;
  const _LevelCard({required this.code, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimens.spaceSm),
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(color: t.outlineVariant, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: t.characters,
                borderRadius: BorderRadius.circular(AppDimens.radiusSm),
              ),
              child: Center(
                child: Text(
                  code,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data?.label ?? '—',
                    style: AppTextStyles.body.copyWith(
                      color: t.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    data != null ? '${data!.total} kanji' : '— kanji',
                    style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: t.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

// ─── Level header (shown inside the grid view) ────────────────────────────────

class _LevelHeader extends StatelessWidget {
  final String level;
  final String? label;
  final VoidCallback onBack;
  const _LevelHeader({required this.level, required this.onBack, this.label});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceXs, AppDimens.spaceSm, AppDimens.spaceMd, 0,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: onBack,
            color: t.onSurface,
          ),
          Text(level, style: AppTextStyles.title.copyWith(color: t.onSurface)),
          if (label != null) ...[
            const SizedBox(width: AppDimens.spaceSm),
            Text(
              '· $label',
              style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}


class _KanjiGrid extends StatelessWidget {
  final List<KanjiListEntry> kanjis;
  final Set<int> knownIds;
  final void Function(int id) onToggle;

  const _KanjiGrid({
    required this.kanjis,
    required this.knownIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    const gap = AppDimens.spaceSm;
    const cols = 4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = (constraints.maxWidth - gap * (cols - 1)) / cols;
          final kanjiSize = (cellSize * 0.30).clamp(18.0, 48.0);
          final meaningSize = (cellSize * 0.10).clamp(9.0, 13.0);

          final rows = <Widget>[];
          for (int i = 0; i < kanjis.length; i += cols) {
            final rowItems = kanjis.sublist(i, (i + cols).clamp(0, kanjis.length));
            rows.add(Row(
              children: [
                for (int j = 0; j < rowItems.length; j++) ...[
                  if (j > 0) const SizedBox(width: gap),
                  KanjiCell(
                    character: rowItems[j].character,
                    meaning: '',
                    isKnown: knownIds.contains(rowItems[j].id),
                    onTap: () => onToggle(rowItems[j].id),
                    size: cellSize,
                    kanjiSize: kanjiSize,
                    meaningSize: meaningSize,
                  ),
                ],
                // Pad incomplete last row
                if (rowItems.length < cols) ...[
                  const SizedBox(width: gap),
                  for (int k = rowItems.length; k < cols - 1; k++) ...[
                    SizedBox(width: cellSize),
                    const SizedBox(width: gap),
                  ],
                  SizedBox(width: cellSize),
                ],
              ],
            ));
            rows.add(const SizedBox(height: gap));
          }
          return Column(children: rows);
        },
      ),
    );
  }
}
