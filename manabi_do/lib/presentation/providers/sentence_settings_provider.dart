import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/sentence_settings.dart';
import '../../core/providers/shared_preferences_provider.dart';

const _kKey = 'sentence_settings_v1';

final sentenceSettingsProvider =
    NotifierProvider<SentenceSettingsNotifier, SentenceSettings>(
      SentenceSettingsNotifier.new,
    );

class SentenceSettingsNotifier extends Notifier<SentenceSettings> {
  @override
  SentenceSettings build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString(_kKey);
    if (raw == null) return SentenceSettings.defaults;
    try {
      return SentenceSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return SentenceSettings.defaults;
    }
  }

  Future<void> update(SentenceSettings settings) async {
    state = settings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, jsonEncode(settings.toJson()));
  }
}
