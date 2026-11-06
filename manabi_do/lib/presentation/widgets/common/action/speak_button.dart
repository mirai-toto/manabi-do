import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/tts_provider.dart';
import '../../../../l10n/l10n.dart';

/// Icon button that triggers Japanese TTS for a given text string. Reads
/// `ttsProvider` internally — the only widget allowed to do so because TTS is a
/// service action, not a display setting.
class SpeakButton extends ConsumerWidget {
  final String text;
  final Color color;
  final double size;

  /// Draws the button as a round tonal button of this colour, a full touch
  /// target. Left out, it is a bare icon, for tight spots inside a card.
  final Color? background;

  /// The tonal button's diameter.
  static const double _tonalSize = 44;

  const SpeakButton({
    super.key,
    required this.text,
    required this.color,
    this.size = 20,
    this.background,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void speak() => speakJapanese(ref.read(ttsProvider), text);
    final Icon icon = Icon(Icons.volume_up_rounded, size: size, color: color);
    final Color? fill = background;
    if (fill != null) {
      return IconButton(
        icon: icon,
        tooltip: context.l10n.speakPronunciation,
        style: IconButton.styleFrom(
          backgroundColor: fill,
          fixedSize: const Size.square(_tonalSize),
        ),
        onPressed: speak,
      );
    }
    return IconButton(
      icon: icon,
      tooltip: context.l10n.speakPronunciation,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      visualDensity: VisualDensity.compact,
      onPressed: speak,
    );
  }
}
