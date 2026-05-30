import 'package:flutter/material.dart';

import '../common/card_container.dart';

class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const SettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) =>
      CardContainer(child: Column(children: children));
}
