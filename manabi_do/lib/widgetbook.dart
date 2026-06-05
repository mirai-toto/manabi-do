import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'widgetbook.directories.g.dart';

@widgetbook.App()
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: _WidgetbookShell()));
}

class _WidgetbookShell extends StatelessWidget {
  const _WidgetbookShell();

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: AppTheme.light),
            WidgetbookTheme(name: 'Dark', data: AppTheme.dark),
          ],
        ),
        LocalizationAddon(
          locales: const [Locale('en'), Locale('fr'), Locale('de')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
        TextScaleAddon(),
        AlignmentAddon(),
      ],
    );
  }
}
