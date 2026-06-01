import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../common/app_button.dart';

class LessonReaderCard extends StatelessWidget {
  final String chapterLabel;
  final String title;
  final List<Widget> body;
  final VoidCallback? onPractice;

  const LessonReaderCard({
    super.key,
    required this.chapterLabel,
    required this.title,
    required this.body,
    this.onPractice,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Container(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        boxShadow: [
          BoxShadow(color: t.onSurface.withValues(alpha: 0.09), blurRadius: 12, offset: const Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ReaderHeader(chapterLabel: chapterLabel, title: title),
          Padding(
            padding: const EdgeInsets.all(AppDimens.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...body,
                const SizedBox(height: AppDimens.spaceLg),
                AppButton(
                  label: context.l10n.practice,
                  fullWidth: true,
                  onPressed: onPractice,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReaderHeader extends StatelessWidget {
  final String chapterLabel;
  final String title;
  const _ReaderHeader({required this.chapterLabel, required this.title});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceLg, AppDimens.spaceLg, AppDimens.spaceLg, AppDimens.spaceXl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [t.primary, t.primaryLight],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chapterLabel.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ReaderBodyText extends StatelessWidget {
  final String text;
  const ReaderBodyText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.body.copyWith(color: context.tokens.onSurface));
  }
}

class ReaderSectionTitle extends StatelessWidget {
  final String text;
  const ReaderSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.spaceLg, bottom: AppDimens.spaceSm),
      child: Text(
        text,
        style: AppTextStyles.title.copyWith(
          fontSize: 17,
          color: context.tokens.onSurface,
        ),
      ),
    );
  }
}

class ReaderJpExample extends StatelessWidget {
  final String japanese;
  final String translation;
  const ReaderJpExample({super.key, required this.japanese, required this.translation});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceSm + 4,
      ),
      decoration: BoxDecoration(
        color: t.primaryContainer,
        border: Border(left: BorderSide(color: t.primary, width: 3)),
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(AppDimens.radiusSm)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            japanese,
            style: AppTextStyles.jpBody.copyWith(
              fontSize: 18,
              color: t.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXxs),
          Text(
            translation,
            style: AppTextStyles.bodySmall.copyWith(color: t.onPrimaryContainer.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}
