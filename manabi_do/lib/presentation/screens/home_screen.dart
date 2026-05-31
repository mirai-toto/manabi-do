import 'package:flutter/cupertino.dart';
import 'package:manabi_do/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.appTitle),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton.filled(
                onPressed: () {},
                child: Text(l10n.sectionCharacters),
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: () {},
                child: Text(l10n.sectionGrammar),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
