import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/data/kana_data.dart';

final kanaDataProvider = FutureProvider<KanaData>((ref) async {
  final raw = await rootBundle.loadString('assets/data/kana.json');
  return KanaData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
});
