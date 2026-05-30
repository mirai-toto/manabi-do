import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card, Rating;

import '../../../data/database/app_database.dart';

class PracticeItem {
  final int id;
  final String srsType;
  final Card? card;
  final Widget Function(int index, int total, void Function(Rating) onAnswer)
  buildBody;

  const PracticeItem({
    required this.id,
    required this.srsType,
    required this.card,
    required this.buildBody,
  });
}

typedef LoadQueue =
    Future<List<PracticeItem>> Function(AppDatabase db, WidgetRef ref);
