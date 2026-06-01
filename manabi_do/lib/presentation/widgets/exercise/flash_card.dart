import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';

class FlashCard extends StatelessWidget {
  final String japanese;
  final String? label;
  final bool isRevealed;
  final String? answer;
  final VoidCallback? onTap;

  const FlashCard({
    super.key,
    required this.japanese,
    this.label,
    this.isRevealed = false,
    this.answer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final promptLabel = label ?? l.flashcardDefaultPrompt;

    return Semantics(
      label: isRevealed
          ? '$japanese: ${answer ?? ""}'
          : '$promptLabel $japanese',
      button: true,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [t.primary, t.primaryLight],
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusXl),
            boxShadow: [
              BoxShadow(
                color: t.primary.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isRevealed) ...[
                      Text(
                        japanese,
                        style: AppTextStyles.jpFlash.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: AppDimens.spaceSm),
                      Text(
                        promptLabel,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ] else ...[
                      Text(
                        answer ?? '',
                        style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimens.spaceXs),
                      Text(
                        japanese,
                        style: AppTextStyles.jpBody.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isRevealed)
                Positioned(
                  bottom: AppDimens.spaceMd,
                  left: 0,
                  right: 0,
                  child: Text(
                    l.tapToReveal,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlashCardActions extends StatelessWidget {
  final String notYetLabel;
  final String gotItLabel;
  final VoidCallback? onNotYet;
  final VoidCallback? onGotIt;

  const FlashCardActions({
    super.key,
    required this.notYetLabel,
    required this.gotItLabel,
    this.onNotYet,
    this.onGotIt,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Row(
      children: [
        Expanded(
          child: _FlashButton(
            label: notYetLabel,
            bgColor: t.errorContainer,
            fgColor: t.error,
            onTap: onNotYet,
          ),
        ),
        const SizedBox(width: AppDimens.spaceSm),
        Expanded(
          child: _FlashButton(
            label: gotItLabel,
            bgColor: t.successContainer,
            fgColor: t.success,
            onTap: onGotIt,
          ),
        ),
      ],
    );
  }
}

class _FlashButton extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color fgColor;
  final VoidCallback? onTap;

  const _FlashButton({
    required this.label,
    required this.bgColor,
    required this.fgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelLarge.copyWith(color: fgColor),
          ),
        ),
      ),
    );
  }
}
