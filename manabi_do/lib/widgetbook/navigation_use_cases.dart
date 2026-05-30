import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../presentation/widgets/navigation/app_nav_bar.dart';
import '../presentation/widgets/navigation/app_nav_rail.dart';
import '../presentation/widgets/navigation/nav_destination.dart';
import '../presentation/widgets/navigation/nav_item.dart';

const _destinations = [
  NavDestination(label: 'Home', icon: '🏠'),
  NavDestination(label: 'Characters', icon: '字'),
  NavDestination(label: 'Vocabulary', icon: '📚'),
  NavDestination(label: 'Grammar', icon: '文'),
  NavDestination(label: 'More', icon: '⚙️'),
];

// ── NavItem ───────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Active', type: NavItem, path: 'Navigation')
Widget buildNavItemActive(BuildContext context) {
  return NavItem(
    destination: _destinations[0],
    isActive: true,
    onTap: () {},
    pillWidth: 64,
    iconSize: 22,
    labelSpacing: 4,
  );
}

@widgetbook.UseCase(name: 'Inactive', type: NavItem, path: 'Navigation')
Widget buildNavItemInactive(BuildContext context) {
  return NavItem(
    destination: _destinations[1],
    isActive: false,
    onTap: () {},
    pillWidth: 64,
    iconSize: 22,
    labelSpacing: 4,
  );
}

// ── AppNavBar ─────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: AppNavBar, path: 'Navigation')
Widget buildAppNavBar(BuildContext context) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: AppNavBar(
      destinations: _destinations,
      selectedIndex: 0,
      onDestinationSelected: (_) {},
    ),
  );
}

// ── AppNavRail ────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Default', type: AppNavRail, path: 'Navigation')
Widget buildAppNavRail(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Align(
      alignment: Alignment.centerLeft,
      child: AppNavRail(
        destinations: _destinations,
        selectedIndex: 1,
        onDestinationSelected: (_) {},
      ),
    ),
  );
}
