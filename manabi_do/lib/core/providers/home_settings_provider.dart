import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyShowKana = 'home_show_kana';
const _keyShowKanji = 'home_show_kanji';
const _keyShowVocab = 'home_show_vocab';

/// Which decks appear on the home screen (and in the combined session).
class HomeSettings {
  final bool showKana;
  final bool showKanji;
  final bool showVocab;

  const HomeSettings({
    this.showKana = true,
    this.showKanji = true,
    this.showVocab = true,
  });

  HomeSettings copyWith({bool? showKana, bool? showKanji, bool? showVocab}) =>
      HomeSettings(
        showKana: showKana ?? this.showKana,
        showKanji: showKanji ?? this.showKanji,
        showVocab: showVocab ?? this.showVocab,
      );
}

class HomeSettingsNotifier extends AsyncNotifier<HomeSettings> {
  @override
  Future<HomeSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return HomeSettings(
      showKana: prefs.getBool(_keyShowKana) ?? true,
      showKanji: prefs.getBool(_keyShowKanji) ?? true,
      showVocab: prefs.getBool(_keyShowVocab) ?? true,
    );
  }

  Future<void> setShowKana(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowKana, value);
    state = AsyncData(state.requireValue.copyWith(showKana: value));
  }

  Future<void> setShowKanji(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowKanji, value);
    state = AsyncData(state.requireValue.copyWith(showKanji: value));
  }

  Future<void> setShowVocab(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowVocab, value);
    state = AsyncData(state.requireValue.copyWith(showVocab: value));
  }
}

final homeSettingsProvider =
    AsyncNotifierProvider<HomeSettingsNotifier, HomeSettings>(
      HomeSettingsNotifier.new,
    );
