import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

// flutter_tts supports Android, iOS, macOS, Windows, and web — not Linux.
final _ttsSupported = kIsWeb ||
    Platform.isAndroid ||
    Platform.isIOS ||
    Platform.isMacOS ||
    Platform.isWindows;

final ttsProvider = Provider<FlutterTts>((ref) {
  final tts = FlutterTts();
  if (_ttsSupported) {
    tts.setLanguage('ja-JP');
    tts.setSpeechRate(0.5);
    tts.setVolume(1.0);
    tts.setPitch(1.0);
    ref.onDispose(() => tts.stop());
  }
  return tts;
});

Future<void> speakJapanese(FlutterTts tts, String text) async {
  if (!_ttsSupported) return;
  await tts.speak(text);
}
