import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import 'nav_destination.dart';
import 'nav_item.dart';

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
        children: List.generate(destinations.length, (i) => Expanded(
          child: NavItem(
            destination: destinations[i],
            isActive: i == selectedIndex,
            onTap: () => onDestinationSelected?.call(i),
            pillWidth: 64,
            iconSize: 22,
            labelSpacing: AppDimens.spaceXs,
          ),
        )),
      ),
    );
  }
}
