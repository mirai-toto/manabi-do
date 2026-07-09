import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_preferences_provider.dart';

const _kLocaleKey = 'app_locale';
const _kSupportedLocales = ['en', 'fr', 'de'];

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final saved = prefs.getString(_kLocaleKey);
    if (saved != null) return Locale(saved);
    final deviceCode = PlatformDispatcher.instance.locale.languageCode;
    if (_kSupportedLocales.contains(deviceCode)) return Locale(deviceCode);
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
