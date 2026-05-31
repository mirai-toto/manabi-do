import 'package:flutter/material.dart';
import 'package:manabi_do/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {},
              child: Text(l10n.sectionCharacters),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {},
              child: Text(l10n.sectionGrammar),
            ),
          ],
        ),
      ),
    );
  }
}
