import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/database/app_database.dart';
import '../../../widgets/widgets.dart';

class KanjiReadingsCard extends StatelessWidget {
  final Kanji kanji;
  const KanjiReadingsCard({super.key, required this.kanji});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final onReadings =
        kanji.onReading.split('、').where((s) => s.trim().isNotEmpty).toList();
    final kunReadings =
        kanji.kunReading.split('、').where((s) => s.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Readings'),
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
      ],
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
                      style: AppTextStyles.jpBody.copyWith(color: t.onSurfaceVariant),
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
