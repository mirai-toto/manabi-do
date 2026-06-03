import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../data/database/app_database.dart';
import '../../providers/database_provider.dart';
import '../../providers/kanji_provider.dart';
import '../../widgets/widgets.dart';
import '../../../core/theme/jlpt_level.dart';

class KanjiDetailScreen extends ConsumerWidget {
  final int kanjiId;
  const KanjiDetailScreen({super.key, required this.kanjiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanji = ref.watch(kanjiDetailProvider(kanjiId)).asData?.value;
    final isKnown =
        ref.watch(knownKanjiIdsProvider).asData?.value.contains(kanjiId) ?? false;

    if (kanji == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final color = levelColor(kanji.jlptLevel);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _KanjiHero(kanji: kanji, color: color, onBack: () => Navigator.of(context).pop()),
          _KanjiBody(
            kanji: kanji,
            isKnown: isKnown,
            onToggle: () => ref
                .read(databaseProvider)
                .setKanjiKnown(kanjiId, isKnown: !isKnown),
          ),
        ],
      ),
    );
  }
}

class _KanjiHero extends StatelessWidget {
  final Kanji kanji;
  final Color color;
  final VoidCallback onBack;
  const _KanjiHero({required this.kanji, required this.color, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final darkColor = Color.lerp(color, Colors.black, 0.35)!;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [darkColor, color],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimens.spaceMd,
        topPadding + AppDimens.spaceSm,
        AppDimens.spaceMd,
        AppDimens.spaceLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                ),
                child: Center(
                  child: Text(
                    kanji.character,
                    style: AppTextStyles.jpKanji.copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kanji.meaning,
                      style: AppTextStyles.title.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppDimens.spaceXs),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        kanji.jlptLevel,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _KanjiBody extends StatelessWidget {
  final Kanji kanji;
  final bool isKnown;
  final VoidCallback onToggle;
  const _KanjiBody({
    required this.kanji,
    required this.isKnown,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final onReadings =
        kanji.onReading.split('、').where((s) => s.trim().isNotEmpty).toList();
    final kunReadings =
        kanji.kunReading.split('、').where((s) => s.trim().isNotEmpty).toList();

    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'READINGS',
            style: AppTextStyles.label.copyWith(
              color: t.onSurfaceVariant,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimens.spaceMd),
            decoration: BoxDecoration(
              color: t.cardBackground,
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              border: Border.all(color: t.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (onReadings.isNotEmpty)
                  _ReadingRow(label: 'onyomi', readings: onReadings, isKun: false),
                if (onReadings.isNotEmpty && kunReadings.isNotEmpty)
                  const SizedBox(height: AppDimens.spaceSm),
                if (kunReadings.isNotEmpty)
                  _ReadingRow(label: 'kunyomi', readings: kunReadings, isKun: true),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          _StrokeOrderSection(kanji: kanji),
          const SizedBox(height: AppDimens.spaceLg),
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              decoration: BoxDecoration(
                color: isKnown ? t.successContainer : t.cardBackground,
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                border: Border.all(
                  color: isKnown ? t.success : t.outlineVariant,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isKnown
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: isKnown ? t.success : t.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppDimens.spaceSm),
                  Text(
                    isKnown ? 'Known' : 'Mark as Known',
                    style: AppTextStyles.body.copyWith(
                      color: isKnown ? t.success : t.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingRow extends StatelessWidget {
  final String label;
  final List<String> readings;
  final bool isKun;
  const _ReadingRow({required this.label, required this.readings, required this.isKun});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final textColor = isKun ? t.kunyomi : t.onyomi;
    final bgColor = textColor.withValues(alpha: 0.12);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 56,
          child: Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: readings.map((r) {
              final Widget chipText;
              if (isKun && r.contains('.')) {
                final dotIdx = r.indexOf('.');
                chipText = RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: r.substring(0, dotIdx),
                      style: AppTextStyles.jpBody.copyWith(color: textColor),
                    ),
                    TextSpan(
                      text: r.substring(dotIdx),
                      style: AppTextStyles.jpBody.copyWith(
                        color: textColor.withValues(alpha: 0.30),
                      ),
                    ),
                  ]),
                );
              } else {
                chipText = Text(r, style: AppTextStyles.jpBody.copyWith(color: textColor));
              }
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                ),
                child: chipText,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _StrokeOrderSection extends StatelessWidget {
  final Kanji kanji;
  const _StrokeOrderSection({required this.kanji});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STROKE ORDER',
          style: AppTextStyles.label.copyWith(
            color: t.onSurfaceVariant,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          decoration: BoxDecoration(
            color: t.cardBackground,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: Border.all(color: t.outlineVariant),
          ),
          child: Center(child: StrokeOrderAnimator(kanjiId: kanji.id)),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        StrokeStepRow(kanjiId: kanji.id),
      ],
    );
  }
}
