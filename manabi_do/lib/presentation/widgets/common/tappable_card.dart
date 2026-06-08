import 'package:flutter/material.dart';

/// Wraps a child in the standard tappable-card shell:
/// ClipRRect → Material → InkWell → Ink(decoration).
///
/// Use [decoration] for color, border, borderRadius, boxShadow, etc.
/// The borderRadius is automatically applied to the clip.
class TappableCard extends StatelessWidget {
  final BoxDecoration decoration;
  final VoidCallback? onTap;
  final Widget child;

  const TappableCard({
    super.key,
    required this.decoration,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = decoration.borderRadius;
    return ClipRRect(
      borderRadius: radius is BorderRadius ? radius : BorderRadius.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            decoration: decoration,
            child: child,
          ),
        ),
      ),
    );
  }
}
