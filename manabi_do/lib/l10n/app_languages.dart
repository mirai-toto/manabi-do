/// A language the app is translated into, as the language picker lists it:
/// its code, a flag, and its name written in itself.
typedef AppLanguage = ({String code, String flag, String name});

const List<AppLanguage> appLanguages = [
  (code: 'en', flag: '🇬🇧', name: 'English'),
  (code: 'fr', flag: '🇫🇷', name: 'Français'),
  (code: 'de', flag: '🇩🇪', name: 'Deutsch'),
];
