class NavDestination {
  final String label;
  final String? icon;
  final String? iconAsset;

  const NavDestination({
    required this.label,
    this.icon,
    this.iconAsset,
  }) : assert(icon != null || iconAsset != null, 'Provide either icon or iconAsset');
}
