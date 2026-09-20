import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../domain/data/kana_data.dart';
import 'database_provider.dart';

final kanaDataProvider = FutureProvider<KanaData>((ref) async {
  return ref.watch(databaseProvider).getKanaData();
});
