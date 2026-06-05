import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';

class KnownToggle extends StatelessWidget {
  final bool isKnown;
  final VoidCallback? onTap;
  final bool fullWidth;

  const KnownToggle({
    super.key,
    required this.isKnown,
    this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final label = isKnown ? l.knownCheck : l.markAsKnown;
    final disabled = onTap == null;

    return Opacity(
      opacity: disabled ? 0.38 : 1.0,
      child: Semantics(
      label: label,
      toggled: isKnown,
      button: !disabled,
      enabled: !disabled,
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: isKnown ? t.successContainer : t.surfaceContainer,
          border: Border.all(
            color: isKnown ? t.success : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLg,
                vertical: AppDimens.buttonPaddingV,
              ),
              child: Row(
                mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isKnown ? t.success : t.outlineVariant,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 12, color: Colors.white),
                  ),
                  const SizedBox(width: AppDimens.spaceSm),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        l.markAsKnown,
                        style: AppTextStyles.labelLarge.copyWith(color: Colors.transparent),
                      ),
                      Text(
                        label,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: isKnown ? t.success : t.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}
