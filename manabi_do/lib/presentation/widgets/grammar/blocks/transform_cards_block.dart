import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../common/card_container.dart';
import '../../common/pill_badge.dart';

// ── Data models ──────────────────────────────────────────────────────────────

class TransformRow {
  final String base;
  final String? old;
  final String? newSuffix;
  final String result;
  final String? romaji;
  final String? english;

  const TransformRow({
    required this.base,
    this.old,
    this.newSuffix,
    required this.result,
    this.romaji,
    this.english,
  });

  factory TransformRow.fromJson(Map<String, dynamic> d) => TransformRow(
    base: d['base'] as String,
    old: d['old'] as String?,
    newSuffix: d['new'] as String?,
    result: d['result'] as String,
    romaji: d['romaji'] as String?,
    english: d['english'] as String?,
  );
}

class TransformGroup {
  final String label;
  final String? tag;
  final String? description;
  final String? rule;
  final List<TransformRow> rows;
  final String? note;

  const TransformGroup({
    required this.label,
    this.tag,
    this.description,
    this.rule,
    required this.rows,
    this.note,
  });

  factory TransformGroup.fromJson(Map<String, dynamic> d) => TransformGroup(
    label: d['label'] as String,
    tag: d['tag'] as String?,
    description: d['description'] as String?,
    rule: d['rule'] as String?,
    rows: (d['rows'] as List<dynamic>)
        .map((r) => TransformRow.fromJson(Map<String, dynamic>.from(r)))
        .toList(),
    note: d['note'] as String?,
  );
}

// ── Widgets ───────────────────────────────────────────────────────────────────

const double _kArrowWidth = 32.0;

class TransformCardsBlock extends StatelessWidget {
  final List<TransformGroup> groups;
  final Color? accentColor;

  const TransformCardsBlock({
    super.key,
    required this.groups,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? context.tokens.primary;
    final t = context.tokens;
    final items = <Widget>[];
    for (int i = 0; i < groups.length; i++) {
      if (i > 0) items.add(const SizedBox(height: AppDimens.spaceLg));
      final group = groups[i];
      if (group.description != null) {
        items.add(_GroupHeading(group: group, tokens: t));
        items.add(const SizedBox(height: AppDimens.spaceSm));
      }
      items.add(_GroupCard(group: group, accentColor: color));
      if (group.note != null) {
        items.add(
          Padding(
            padding: const EdgeInsets.only(top: AppDimens.spaceXs),
            child: _NoteChip(text: group.note!, tokens: t, accentColor: color),
          ),
        );
      }
    }
    return Column(mainAxisSize: MainAxisSize.min, children: items);
  }
}

class _GroupHeading extends StatelessWidget {
  final TransformGroup group;
  final AppTokens tokens;

  const _GroupHeading({required this.group, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final description = group.description;
    if (description == null) return const SizedBox.shrink();
    return Text(
      description,
      style: AppTextStyles.bodySmall.copyWith(color: tokens.onSurfaceVariant),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final TransformGroup group;
  final Color accentColor;

  const _GroupCard({required this.group, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return CardContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spaceMd,
              AppDimens.spaceMd,
              AppDimens.spaceMd,
              0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    PillBadge(
                      label: group.label,
                      color: Colors.white,
                      background: accentColor,
                    ),
                    if (group.tag != null) ...[
                      const SizedBox(width: AppDimens.spaceSm),
                      Text(
                        group.tag!,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: t.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
                if (group.rule != null) ...[
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    group.rule!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: t.onSurfaceVariant,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: AppDimens.spaceSm),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: t.outlineVariant),
          // Rows: horizontally padded, dividers full-width
          for (int i = 0; i < group.rows.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 0.5,
                color: t.outlineVariant.withValues(alpha: 0.4),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
              ),
              child: _TransformRowWidget(
                row: group.rows[i],
                accentColor: accentColor,
                tokens: t,
              ),
            ),
          ],
          const SizedBox(height: AppDimens.spaceSm),
        ],
      ),
    );
  }
}

class _TransformRowWidget extends StatelessWidget {
  final TransformRow row;
  final Color accentColor;
  final AppTokens tokens;

  const _TransformRowWidget({
    required this.row,
    required this.accentColor,
    required this.tokens,
  });

  List<TextSpan> _baseSpans(TextStyle normal, TextStyle struck) {
    final old = row.old;
    if (old == null || !row.base.endsWith(old)) {
      return [TextSpan(text: row.base, style: normal)];
    }
    final prefix = row.base.substring(0, row.base.length - old.length);
    return [
      if (prefix.isNotEmpty) TextSpan(text: prefix, style: normal),
      TextSpan(text: old, style: struck),
    ];
  }

  List<TextSpan> _resultSpans(TextStyle normal, TextStyle accent) {
    final suf = row.newSuffix;
    if (suf == null || !row.result.endsWith(suf)) {
      return [TextSpan(text: row.result, style: normal)];
    }
    final prefix = row.result.substring(0, row.result.length - suf.length);
    return [
      if (prefix.isNotEmpty) TextSpan(text: prefix, style: normal),
      TextSpan(text: suf, style: accent),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    final jpNormal = AppTextStyles.jpBody.copyWith(
      color: t.onSurface,
      fontSize: 17,
    );
    final jpStruck = AppTextStyles.jpBody.copyWith(
      color: t.onSurfaceVariant,
      decoration: TextDecoration.lineThrough,
      decorationColor: t.onSurfaceVariant,
      fontSize: 17,
    );
    final jpAccent = AppTextStyles.jpBody.copyWith(
      color: accentColor,
      fontWeight: FontWeight.w700,
      fontSize: 17,
    );
    final romajiStyle = AppTextStyles.bodySmall.copyWith(
      color: t.onSurfaceVariant,
      fontSize: 13,
      height: 1.3,
    );
    final englishStyle = AppTextStyles.bodySmall.copyWith(
      color: t.onSurfaceVariant.withValues(alpha: 0.75),
      fontSize: 13,
      fontStyle: FontStyle.italic,
      height: 1.3,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed-width dict form: keeps arrow close regardless of content width
          SizedBox(
            width: 88,
            child: RichText(
              text: TextSpan(children: _baseSpans(jpNormal, jpStruck)),
            ),
          ),
          // Arrow nudged 2px down to sit at the JP text baseline
          SizedBox(
            width: _kArrowWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '→',
                style: AppTextStyles.body.copyWith(color: t.onSurfaceVariant),
              ),
            ),
          ),
          // Result + gloss stacked together in the remaining space
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(children: _resultSpans(jpNormal, jpAccent)),
                ),
                if (row.romaji != null) ...[
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(row.romaji!, style: romajiStyle),
                ],
                if (row.english != null) ...[
                  const SizedBox(height: AppDimens.spaceXxs),
                  Text(row.english!, style: englishStyle),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteChip extends StatelessWidget {
  final String text;
  final AppTokens tokens;
  final Color? accentColor;

  const _NoteChip({required this.text, required this.tokens, this.accentColor});

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    final color = accentColor ?? t.primary;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.info_outline_rounded, size: 13, color: color),
          const SizedBox(width: AppDimens.spaceXs),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: t.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
