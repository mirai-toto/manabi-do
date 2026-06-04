import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';

final knownHiraganaProvider = StreamProvider<Set<int>>((ref) =>
    ref.watch(databaseProvider).watchKnownKanaIds('hiragana'));

final knownKatakanaProvider = StreamProvider<Set<int>>((ref) =>
    ref.watch(databaseProvider).watchKnownKanaIds('katakana'));
