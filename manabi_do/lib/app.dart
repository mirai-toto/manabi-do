import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:manabi_do/l10n/app_localizations.dart';

import 'presentation/screens/home_screen.dart';

class ManabiDoApp extends StatelessWidget {
  const ManabiDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manabi Do',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4EFF)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
