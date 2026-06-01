import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/known_toggle.dart';

class KanjiExample {
  final String kanji;
  final String reading;
  final String meaning;

  const KanjiExample({
    required this.kanji,
    required this.reading,
    required this.meaning,
  });
}

class KanjiDetailCard extends StatelessWidget {
  final String kanji;
  final String meaning;
  final String jlptLevel;
  final List<String> readings;
  final List<KanjiExample> examples;
  final bool isKnown;
  final VoidCallback? onKnownToggle;
  final Widget? strokeOrderWidget;

  const KanjiDetailCard({
    super.key,
    required this.kanji,
    required this.meaning,
    required this.jlptLevel,
    required this.readings,
    required this.examples,
    this.isKnown = false,
    this.onKnownToggle,
    this.strokeOrderWidget,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        boxShadow: [
          BoxShadow(color: t.onSurface.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _KanjiHeader(
            kanji: kanji,
            meaning: meaning,
            jlptLevel: jlptLevel,
            readings: readings,
            readingsLabel: l.readings,
          ),
          const SizedBox(height: AppDimens.spaceLg),
          _StrokeOrderBox(child: strokeOrderWidget),
          _Divider(),
          _SectionLabel(l.exampleWords),
          const SizedBox(height: AppDimens.spaceSm),
          ...List.generate(examples.length, (i) => _ExampleWord(
            example: examples[i],
            showTopBorder: i > 0,
          )),
          _Divider(),
          KnownToggle(isKnown: isKnown, onTap: onKnownToggle, fullWidth: true),
        ],
      ),
    );
  }
}

class _KanjiHeader extends StatelessWidget {
  final String kanji;
  final String meaning;
  final String jlptLevel;
  final List<String> readings;
  final String readingsLabel;

  const _KanjiHeader({
    required this.kanji,
    required this.meaning,
    required this.jlptLevel,
    required this.readings,
    required this.readingsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: t.primaryContainer,
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          ),
          child: Center(
            child: Text(
              kanji,
              style: AppTextStyles.jpKanji.copyWith(color: t.primary),
            ),
          ),
        ),
        const SizedBox(width: AppDimens.spaceLg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(meaning, style: AppTextStyles.title.copyWith(fontSize: 20)),
              const SizedBox(height: AppDimens.spaceXs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.badgePaddingH,
                  vertical: AppDimens.badgePaddingV,
                ),
                decoration: BoxDecoration(
                  color: t.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                ),
                child: Text(
                  jlptLevel,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: t.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spaceSm),
              Text(
                readingsLabel,
                style: AppTextStyles.labelSmall.copyWith(
                  color: t.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: AppDimens.spaceXs),
              Wrap(
                spacing: AppDimens.spaceXs,
                runSpacing: AppDimens.spaceXs,
                children: readings.map((r) => _ReadingChip(reading: r)).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReadingChip extends StatelessWidget {
  final String reading;
  const _ReadingChip({required this.reading});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.badgePaddingH,
        vertical: AppDimens.badgePaddingV,
      ),
      decoration: BoxDecoration(
        color: t.surfaceContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      ),
      child: Text(
        reading,
        style: AppTextStyles.jpBody.copyWith(fontSize: 13, color: t.onSurface),
      ),
    );
  }
}

class _StrokeOrderBox extends StatelessWidget {
  final Widget? child;
  const _StrokeOrderBox({this.child});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: t.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: child ?? Center(
        child: Text(
          context.l10n.strokeOrderPlaceholder,
          style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
      child: Divider(height: 1, color: context.tokens.outlineVariant),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.labelSmall.copyWith(
        color: context.tokens.onSurfaceVariant,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _ExampleWord extends StatelessWidget {
  final KanjiExample example;
  final bool showTopBorder;

  const _ExampleWord({required this.example, required this.showTopBorder});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
      decoration: showTopBorder
          ? BoxDecoration(border: Border(top: BorderSide(color: t.outlineVariant)))
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            example.kanji,
            style: AppTextStyles.jpBody.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: AppDimens.spaceSm),
          Text(
            example.reading,
            style: AppTextStyles.jpBody.copyWith(fontSize: 13, color: t.onSurfaceVariant),
          ),
          const Spacer(),
          Text(
            example.meaning,
            style: AppTextStyles.bodySmall.copyWith(color: t.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
