import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import 'nav_destination.dart';

class AppNavBar extends StatelessWidget {
  final List<NavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  const AppNavBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Container(
      decoration: BoxDecoration(
        color: t.cardBackground,
        boxShadow: [
          BoxShadow(color: t.outlineVariant, offset: const Offset(0, -1), blurRadius: 0),
          BoxShadow(color: t.onSurface.withValues(alpha: 0.06), offset: const Offset(0, 2), blurRadius: 8),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceSm, vertical: AppDimens.buttonPaddingV),
      child: Row(
        children: List.generate(destinations.length, (i) {
          return _NavItem(
            destination: destinations[i],
            isActive: i == selectedIndex,
            onTap: () => onDestinationSelected?.call(i),
          );
        }),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final NavDestination destination;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.destination,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;

    return Expanded(
      child: Semantics(
        label: destination.label,
        selected: isActive,
        button: true,
        excludeSemantics: true,
        child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: isActive ? 64 : 24,
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
                    fontSize: 20,
                    color: isActive ? t.onPrimaryContainer : t.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceXs),
            Text(
              destination.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isActive ? t.onPrimaryContainer : t.onSurfaceVariant,
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
