import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared_preferences_provider.dart';

const _keyShowKana = 'home_show_kana';
const _keyShowKanji = 'home_show_kanji';
const _keyShowVocabulary = 'home_show_vocab';

/// Which decks appear on the home screen (and in the combined session).
class HomeSettings {
  final bool showKana;
  final bool showKanji;
  final bool showVocabulary;

  const HomeSettings({
    this.showKana = true,
    this.showKanji = true,
    this.showVocabulary = true,
  });

  HomeSettings copyWith({
    bool? showKana,
    bool? showKanji,
    bool? showVocabulary,
  }) => HomeSettings(
    showKana: showKana ?? this.showKana,
    showKanji: showKanji ?? this.showKanji,
    showVocabulary: showVocabulary ?? this.showVocabulary,
  );
}

class HomeSettingsNotifier extends Notifier<HomeSettings> {
  @override
  HomeSettings build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return HomeSettings(
      showKana: prefs.getBool(_keyShowKana) ?? true,
      showKanji: prefs.getBool(_keyShowKanji) ?? true,
      showVocabulary: prefs.getBool(_keyShowVocabulary) ?? true,
    );
  }

  Future<void> setShowKana(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyShowKana, value);
    state = state.copyWith(showKana: value);
  }

  Future<void> setShowKanji(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyShowKanji, value);
    state = state.copyWith(showKanji: value);
  }

  Future<void> setShowVocabulary(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_keyShowVocabulary, value);
    state = state.copyWith(showVocabulary: value);
  }
}

final homeSettingsProvider =
    NotifierProvider<HomeSettingsNotifier, HomeSettings>(
      HomeSettingsNotifier.new,
    );
