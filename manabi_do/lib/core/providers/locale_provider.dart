import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'shared_preferences_provider.dart';

const _kLocaleKey = 'app_locale';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final saved = prefs.getString(_kLocaleKey);
    if (saved != null) return Locale(saved);
    final deviceCode = PlatformDispatcher.instance.locale.languageCode;
    final bool supported = AppLocalizations.supportedLocales.any(
      (l) => l.languageCode == deviceCode,
    );
    if (supported) return Locale(deviceCode);
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_kLocaleKey, locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
