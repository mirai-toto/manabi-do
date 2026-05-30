import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/flashcard_settings.dart';
import '../../core/providers/shared_preferences_provider.dart';

const _kKey = 'flashcard_settings_v1';

final flashcardSettingsProvider =
    NotifierProvider<FlashcardSettingsNotifier, FlashcardSettings>(
      FlashcardSettingsNotifier.new,
    );

class FlashcardSettingsNotifier extends Notifier<FlashcardSettings> {
  @override
  FlashcardSettings build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString(_kKey);
    if (raw == null) return FlashcardSettings.defaults;
    try {
      return FlashcardSettings.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return FlashcardSettings.defaults;
    }
  }

  Future<void> update(FlashcardSettings settings) async {
    state = settings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, jsonEncode(settings.toJson()));
  }
}
