import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/tts_provider.dart';

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
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      visualDensity: VisualDensity.compact,
      onPressed: () => speakJapanese(ref.read(ttsProvider), text),
    );
  }
}
