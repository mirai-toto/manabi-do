import 'package:flutter/material.dart';

/// Wraps a scrollable built with [builder] and shows a bottom gradient when
/// there is content below the visible area, hiding it when the user reaches
/// the end.
class ScrollFade extends StatefulWidget {
  final Widget Function(ScrollController controller) builder;
  final double fadeHeight;

  const ScrollFade({super.key, required this.builder, this.fadeHeight = 64});

  @override
  State<ScrollFade> createState() => _ScrollFadeState();
}

class _ScrollFadeState extends State<ScrollFade> {
  final _controller = ScrollController();
  bool _showFade = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_update);
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _update() {
    if (!_controller.hasClients) return;
    final hasMore = _controller.position.extentAfter > 0;
    if (hasMore != _showFade) setState(() => _showFade = hasMore);
  }

  @override
  Widget build(BuildContext context) {
    final fadeColor = Theme.of(context).scaffoldBackgroundColor;
    return Stack(
      children: [
        widget.builder(_controller),
        if (_showFade)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: widget.fadeHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [fadeColor.withValues(alpha: 0), fadeColor],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
