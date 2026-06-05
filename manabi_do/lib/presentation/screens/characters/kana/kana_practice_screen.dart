import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/srs_settings_provider.dart';
import '../../../../core/theme/jlpt_level.dart';
import '../../../../data/database/app_database.dart';
import '../../../../l10n/l10n.dart';
import '../../../widgets/exercise/practice_session_screen.dart';

class KanaPracticeScreen extends StatelessWidget {
  final String type; // 'hiragana' | 'katakana'
  const KanaPracticeScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PracticeSessionScreen(
      title: type == 'hiragana' ? l.tabHiragana : l.tabKatakana,
      color: levelColor('kana'),
      loadQueue: _buildQueue,
    );
  }

  Future<List<PracticeItem>> _buildQueue(AppDatabase db, WidgetRef ref) async {
    final settings = await ref.read(srsSettingsProvider.future);
    final color = levelColor('kana');
    final queue = await db.getKanaSrsSession(type, newCardLimit: settings.newCardsPerSession);
    return queue.map((pair) {
      final (kana, card) = pair;
      return PracticeItem(
        id: kana.id,
        srsType: type,
        card: card,
        buildBody: (index, total, onAnswer) => PracticeFlashcardBody(
          japanese: kana.character,
          answer: kana.romaji,
          card: card,
          index: index,
          total: total,
          color: color,
          onAnswer: onAnswer,
        ),
      );
    }).toList();
  }
}
