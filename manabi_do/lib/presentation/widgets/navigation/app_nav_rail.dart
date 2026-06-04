import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_tokens.dart';
import 'nav_destination.dart';
import 'nav_item.dart';

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
        children: List.generate(destinations.length, (i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXs),
          child: NavItem(
            destination: destinations[i],
            isActive: i == selectedIndex,
            onTap: () => onDestinationSelected?.call(i),
            pillWidth: 56,
            iconSize: 20,
            labelFontSize: 10,
            labelSpacing: AppDimens.spaceXxs,
            labelAlign: TextAlign.center,
          ),
        )),
      ),
    );
  }
}
