import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'core/providers/shared_preferences_provider.dart';
import 'core/theme/app_palette.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'widgetbook.directories.g.dart';

@widgetbook.App()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const _WidgetbookShell(),
    ),
  );
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
            for (final AppPalette palette in AppPalette.values) ...[
              WidgetbookTheme(
                name: '${palette.romaji} light',
                data: AppTheme.light(palette),
              ),
              WidgetbookTheme(
                name: '${palette.romaji} dark',
                data: AppTheme.dark(palette),
              ),
            ],
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
