import 'app_localizations.dart';

/// How long a session took, to the second: "3m 12s", or "45s" under a minute.
String durationLabel(Duration duration, AppLocalizations l) {
  final int minutes = duration.inMinutes;
  final int seconds = duration.inSeconds % 60;
  return minutes > 0
      ? l.durationMinutesSeconds(minutes, seconds)
      : l.durationSeconds(seconds);
}
