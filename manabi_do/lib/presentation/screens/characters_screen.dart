import 'package:flutter/material.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../domain/data/kana_data.dart';
import '../../l10n/l10n.dart';
import '../widgets/widgets.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen>
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
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CharactersHeader(tabIndex: _tabController.index),
            _SegmentedTabBar(
              controller: _tabController,
              labels: [l.tabHiragana, l.tabKatakana, l.tabKanji],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _KanaTabView(
                    rows: KanaData.hiragana,
                    known: _knownHiragana,
                    onToggle: _toggleHiragana,
                  ),
                  _KanaTabView(
                    rows: KanaData.katakana,
                    known: _knownKatakana,
                    onToggle: _toggleKatakana,
                  ),
                  const _KanjiStub(),
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
  const _CharactersHeader({required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    final allHiragana = KanaData.hiragana.expand((r) => r.kana).length;
    final allKatakana = KanaData.katakana.expand((r) => r.kana).length;
    final total = allHiragana + allKatakana;

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
                  'Kana · Kanji N5/N4  ·  $total characters',
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
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

// ─── Kanji stub ───────────────────────────────────────────────────────────────

class _KanjiStub extends StatelessWidget {
  const _KanjiStub();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('漢', style: AppTextStyles.jpDisplay.copyWith(color: t.characters)),
          const SizedBox(height: AppDimens.spaceSm),
          Text(l.comingSoon, style: AppTextStyles.body.copyWith(color: t.onSurfaceVariant)),
        ],
      ),
    );
  }
}
