import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';

/// Picks one value from a small fixed set — the app's single segmented control.
///
/// Not to be confused with [SegmentedTabBar], which drives a `TabController` to
/// switch between panes. This one is a form input: it reports an index and the
/// caller decides what that means.
class SegmentedControl extends StatelessWidget {
  final List<String> options;

  /// Optional leading icon per option. Must match [options] in length.
  final List<IconData>? icons;
  final int selected;
  final void Function(int) onSelect;

  const SegmentedControl({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
    this.icons,
  }) : assert(
         icons == null || icons.length == options.length,
         'icons must line up with options',
       );

  @override
  Widget build(BuildContext context) {
    final AppTokens t = context.tokens;
    return Row(
      children: [
        for (int i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(width: AppDimens.spaceTight),
          Expanded(
            child: Semantics(
              label: options[i],
              button: true,
              selected: i == selected,
              excludeSemantics: true,
              child: GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.spaceSm,
                  ),
                  decoration: BoxDecoration(
                    color: i == selected ? t.primary : t.cardBackground,
                    borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                    border: Border.all(
                      color: i == selected ? t.primary : t.outlineVariant,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icons != null) ...[
                        Icon(
                          icons![i],
                          size: 18,
                          color: i == selected ? Colors.white : t.onSurface,
                        ),
                        const SizedBox(height: AppDimens.spaceXxs),
                      ],
                      Text(
                        options[i],
                        style: AppTextStyles.labelSmall.copyWith(
                          color: i == selected ? Colors.white : t.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
