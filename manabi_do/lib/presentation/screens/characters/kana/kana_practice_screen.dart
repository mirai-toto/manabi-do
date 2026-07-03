import 'package:flutter/material.dart';

import '../../../../core/theme/jlpt_level.dart';
import '../../../../l10n/l10n.dart';
import '../../../services/review_queue_service.dart';
import '../../practice/practice_session_screen.dart';

class KanaPracticeScreen extends StatelessWidget {
  final String type; // 'hiragana' | 'katakana'
  const KanaPracticeScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PracticeSessionScreen(
      title: type == 'hiragana' ? l.tabHiragana : l.tabKatakana,
      color: levelColor('kana'),
      loadQueue: (ref) => loadKanaPracticeQueue(type, ref),
    );
  }
}
