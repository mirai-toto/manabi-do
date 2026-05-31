import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:manabi_do/l10n/app_localizations.dart';

import 'presentation/screens/home_screen.dart';

class ManabiDoApp extends StatelessWidget {
  const ManabiDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
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
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.systemIndigo,
      ),
      home: const HomeScreen(),
    );
  }
}
