import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../data/database/app_database.dart';
import '../../../../l10n/l10n.dart';
import '../../../widgets/widgets.dart';

List<String> _parseReadings(String raw) =>
    raw.split('、').where((s) => s.trim().isNotEmpty).toList();

class KanjiReadingsCard extends StatelessWidget {
  final Kanji kanji;
  const KanjiReadingsCard({super.key, required this.kanji});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final onReadings  = _parseReadings(kanji.onReading);
    final kunReadings = _parseReadings(kanji.kunReading);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(context.l10n.readings),
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
                _ReadingRow(label: context.l10n.onyomi, readings: onReadings, isKun: false),
              if (onReadings.isNotEmpty && kunReadings.isNotEmpty)
                const SizedBox(height: AppDimens.spaceSm),
              if (kunReadings.isNotEmpty)
                _ReadingRow(label: context.l10n.kunyomi, readings: kunReadings, isKun: true),
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
    final textColor = isKun ? context.tokens.kunyomi : context.tokens.onyomi;

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
            children: readings.map((r) => _ReadingChip(reading: r, isKun: isKun)).toList(),
          ),
        ),
      ],
    );
  }
}

class _ReadingChip extends StatelessWidget {
  final String reading;
  final bool isKun;
  const _ReadingChip({required this.reading, required this.isKun});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final textColor = isKun ? t.kunyomi : t.onyomi;

    final Widget content;
    if (isKun && reading.contains('.')) {
      final dotIdx = reading.indexOf('.');
      content = RichText(
        text: TextSpan(children: [
          TextSpan(text: reading.substring(0, dotIdx), style: AppTextStyles.jpBody.copyWith(color: textColor)),
          TextSpan(text: reading.substring(dotIdx),    style: AppTextStyles.jpBody.copyWith(color: t.onSurfaceVariant)),
        ]),
      );
    } else {
      content = Text(reading, style: AppTextStyles.jpBody.copyWith(color: textColor));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      ),
      child: content,
    );
  }
}
