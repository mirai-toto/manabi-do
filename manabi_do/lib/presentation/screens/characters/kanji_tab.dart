import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../providers/kanji_provider.dart' show KanjiLevelData, KanjiListEntry, kanjiListProvider;
import '../../widgets/widgets.dart';

const _kanjiLevels = ['N5', 'N4', 'N3', 'N2', 'N1'];

class KanjiTabView extends ConsumerStatefulWidget {
  const KanjiTabView({super.key});

  @override
  ConsumerState<KanjiTabView> createState() => _KanjiTabViewState();
}

class _KanjiTabViewState extends ConsumerState<KanjiTabView> {
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

    final t = context.tokens;
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
        ProgressRow(known: knownCount, total: kanjiList.length, color: t.characters),
        _KanjiGrid(
          kanjis: kanjiList,
          knownIds: _knownIds,
          onToggle: _toggle,
        ),
      ],
    );
  }
}

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
