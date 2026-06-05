import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../providers/kanji_provider.dart';
import '../../../widgets/common/jlpt_level_card.dart';

class KanjiLevelCard extends StatelessWidget {
  final String code;
  final KanjiLevelData? data;
  final VoidCallback onTap;

  const KanjiLevelCard({super.key, required this.code, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final subtitle = data != null ? context.l10n.nKanji(data!.total) : '—';
    return JlptLevelCard(code: code, subtitle: subtitle, onTap: onTap);
  }
}
