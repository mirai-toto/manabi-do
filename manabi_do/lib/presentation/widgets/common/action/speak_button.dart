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

  const SpeakButton({
    super.key,
    required this.text,
    required this.color,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(Icons.volume_up_rounded, size: size, color: color),
      tooltip: context.l10n.speakPronunciation,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      visualDensity: VisualDensity.compact,
      onPressed: () => speakJapanese(ref.read(ttsProvider), text),
    );
  }
}
