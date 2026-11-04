import 'package:flutter/material.dart';

import '../common/surface/card_container.dart';

/// Grouped settings section with a title and slotted child tiles.
class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const SettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) =>
      CardContainer(child: Column(children: children));
}
