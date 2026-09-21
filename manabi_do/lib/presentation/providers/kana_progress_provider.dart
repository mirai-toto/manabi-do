import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';
import '../../data/database/app_database.dart';
import 'database_provider.dart';

final kanaSrsCardsProvider = StreamProvider.family<Map<int, Card>, String>(
  (ref, type) => ref.watch(databaseProvider).watchAllSrsCardsForType(type),
);
