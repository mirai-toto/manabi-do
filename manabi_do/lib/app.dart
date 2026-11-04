import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manabi_do/l10n/app_localizations.dart';

import 'core/providers/locale_provider.dart';
import 'core/providers/onboarding_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/shell_screen.dart';

class ManabiDoApp extends ConsumerWidget {
  const ManabiDoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    // Read synchronously, so the first frame is already the right screen.
    // Onboarding sets the locale, which rebuilds this; leaving it as `home`
    // rather than a route means that rebuild swaps the screen cleanly once
    // the flag flips.
    final bool onboarded = ref.watch(onboardingSeenProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manabi Do',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: onboarded ? const ShellScreen() : const OnboardingScreen(),
    );
  }
}
