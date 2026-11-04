import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';

/// A stepper row with − value + controls.
///
/// Both buttons repeat while held. A single tap still moves exactly one, which
/// is the reason to have a stepper at all, but the range runs 0–50 and tapping
/// fifty times to cross it is not a control anyone would choose. Holding starts
/// after a short pause and speeds up, so either precision or distance is one
/// gesture away.
class SettingsStepper extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const SettingsStepper({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onDecrement,
    this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceSm,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: t.onSurfaceVariant),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(color: t.onSurface),
            ),
          ),
          _RepeatButton(
            tooltip: context.l10n.decreaseSetting(label),
            icon: Icons.remove_rounded,
            onPressed: onDecrement,
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: t.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _RepeatButton(
            tooltip: context.l10n.increaseSetting(label),
            icon: Icons.add_rounded,
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}

/// One stepper button: fires once on tap, then repeats while held.
class _RepeatButton extends StatefulWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  const _RepeatButton({
    required this.tooltip,
    required this.icon,
    this.onPressed,
  });

  @override
  State<_RepeatButton> createState() => _RepeatButtonState();
}

class _RepeatButtonState extends State<_RepeatButton> {
  /// How long a press has to be held before it starts repeating. Short enough
  /// not to feel stuck, long enough that an ordinary tap never repeats.
  static const Duration _delay = Duration(milliseconds: 350);

  /// The first repeat interval, and the floor it accelerates to. Capped at
  /// 80ms rather than going faster: each step is written to disk, and twelve
  /// writes a second already crosses the whole 0–50 range in about four
  /// seconds.
  static const Duration _firstInterval = Duration(milliseconds: 220);
  static const Duration _fastestInterval = Duration(milliseconds: 80);

  Timer? _timer;
  Duration _interval = _firstInterval;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _interval = _firstInterval;
    _timer = Timer(_delay, _tick);
  }

  void _tick() {
    final fire = widget.onPressed;
    // Null once the value reaches its bound, which is also how the repeat
    // stops without needing to know the range.
    if (fire == null) {
      _stop();
      return;
    }
    fire();
    _interval = Duration(
      milliseconds: (_interval.inMilliseconds * 0.75).round().clamp(
        _fastestInterval.inMilliseconds,
        _firstInterval.inMilliseconds,
      ),
    );
    _timer = Timer(_interval, _tick);
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final enabled = widget.onPressed != null;
    return Listener(
      onPointerDown: enabled ? (_) => _start() : null,
      onPointerUp: (_) => _stop(),
      onPointerCancel: (_) => _stop(),
      child: IconButton(
        tooltip: widget.tooltip,
        onPressed: widget.onPressed,
        icon: Icon(
          widget.icon,
          size: 18,
          color: enabled ? t.onSurface : t.outlineVariant,
        ),
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      ),
    );
  }
}
