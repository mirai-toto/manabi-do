import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import 'nav_destination.dart';

class AppNavRail extends StatelessWidget {
  final List<NavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  const AppNavRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: t.surfaceContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusXl),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(destinations.length, (i) {
          return _RailItem(
            destination: destinations[i],
            isActive: i == selectedIndex,
            onTap: () => onDestinationSelected?.call(i),
          );
        }),
      ),
    );
  }
}

class _RailItem extends StatelessWidget {
  final NavDestination destination;
  final bool isActive;
  final VoidCallback onTap;

  const _RailItem({
    required this.destination,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Semantics(
      label: destination.label,
      selected: isActive,
      button: true,
      excludeSemantics: true,
      child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXs),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 56,
              height: 32,
              decoration: isActive
                  ? BoxDecoration(
                      color: t.primaryContainer,
                      borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                    )
                  : null,
              child: Center(
                child: Text(
                  destination.icon,
                  style: AppTextStyles.jpBody.copyWith(
                    fontSize: 18,
                    color: isActive ? t.onPrimaryContainer : t.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceXxs),
            Text(
              destination.label,
              style: AppTextStyles.labelSmall.copyWith(
                fontSize: 10,
                color: isActive ? t.onPrimaryContainer : t.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      ),
    );
  }
}
