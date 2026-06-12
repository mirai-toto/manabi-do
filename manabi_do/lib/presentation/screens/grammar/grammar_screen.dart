import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/level_label.dart';
import '../../providers/grammar_provider.dart';
import '../../widgets/widgets.dart';
import 'grammar_lesson_screen.dart';

const _levels = ['N5', 'N4', 'N3', 'N2', 'N1'];

class GrammarScreen extends ConsumerStatefulWidget {
  const GrammarScreen({super.key});

  @override
  ConsumerState<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends ConsumerState<GrammarScreen> {
  String? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: l.sectionGrammar,
          subtitle: l.grammarSubtitle,
          glyph: '文',
          color: t.primary,
        ),
        Expanded(
          child: _selectedLevel == null
              ? _LevelSelector(onSelect: (level) => setState(() => _selectedLevel = level))
              : _ChapterList(
                  level: _selectedLevel!,
                  onBack: () => setState(() => _selectedLevel = null),
                ),
        ),
      ],
    );
  }
}

// ── Level selector ─────────────────────────────────────────────────────────────

class _LevelSelector extends StatelessWidget {
  final void Function(String) onSelect;
  const _LevelSelector({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      children: [
        _BasicsCard(onTap: () => onSelect('basics')),
        const SizedBox(height: AppDimens.spaceSm),
        SectionLabel(l.selectLevel),
        const SizedBox(height: AppDimens.spaceSm),
        for (final level in _levels)
          JlptLevelCard(
            code: level,
            subtitle: level == 'N5' ? null : l.comingSoon,
            onTap: () {
              if (level == 'N5') {
                onSelect(level);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l.comingSoon),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
      ],
    );
  }
}

// ── Basics card ────────────────────────────────────────────────────────────────

class _BasicsCard extends StatelessWidget {
  final VoidCallback onTap;
  const _BasicsCard({required this.onTap});

  static const _color = Color(0xFF795548);

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    return TappableCard(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: _color.withValues(alpha: 0.35)),
      ),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(AppDimens.radiusSm),
              ),
              child: const Center(
                child: Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.japaneseBasics,
                    style: AppTextStyles.body.copyWith(
                      color: t.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.japaneseBasicsSubtitle,
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

// ── Chapter list ───────────────────────────────────────────────────────────────

class _ChapterList extends ConsumerWidget {
  final String level;
  final VoidCallback onBack;
  const _ChapterList({required this.level, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tokens;
    final l = context.l10n;
    final chaptersAsync = ref.watch(grammarChaptersProvider(level));

    final title = level == 'basics' ? l.japaneseBasics : levelLabel(level, context);

    return chaptersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const SizedBox.shrink(),
      data: (chapters) => ListView(
        children: [
          // Back header
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppDimens.spaceSm, AppDimens.spaceSm, AppDimens.spaceMd, 0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: t.onSurface),
                  onPressed: onBack,
                ),
                Text(
                  title,
                  style: AppTextStyles.title.copyWith(color: t.onSurface),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppDimens.spaceMd, AppDimens.spaceSm, AppDimens.spaceMd, AppDimens.spaceSm),
            child: SectionLabel(l.grammarChapters),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            child: CardContainer(
              child: Column(
                children: [
                  for (int i = 0; i < chapters.length; i++) ...[
                    if (i > 0) Divider(height: 1, color: t.outlineVariant),
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => GrammarLessonScreen(
                            title: chapters[i].title,
                            content: chapters[i].content,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceMd,
                          vertical: AppDimens.spaceMd,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                chapters[i].title,
                                style: AppTextStyles.body.copyWith(color: t.onSurface),
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, color: t.onSurfaceVariant),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
        ],
      ),
    );
  }
}
