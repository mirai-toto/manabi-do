import 'package:flutter/material.dart';

import '../../../core/theme/app_motion.dart';

/// An [IndexedStack] that fades the newly shown child in.
///
/// Every child stays mounted, as with a plain [IndexedStack], so each tab
/// keeps its scroll position and its own navigation stack. Only the arrival is
/// animated; the outgoing child is simply hidden, which keeps a quick double
/// tap from ever showing two tabs at once.
class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
  });

  @override
  State<FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: AppMotion.short,
    value: 1,
  );

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index == widget.index) return;
    _fade.duration = context.motion(AppMotion.short);
    _fade.forward(from: 0);
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _fade, curve: AppMotion.enter),
      child: IndexedStack(index: widget.index, children: widget.children),
    );
  }
}
