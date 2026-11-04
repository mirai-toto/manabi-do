import 'app_localizations.dart';

/// A review interval as the short label under a grade button: "10m", "3d".
String intervalLabel(Duration interval, AppLocalizations l) {
  if (interval.inMinutes < 60) {
    return l.intervalMinutes(interval.inMinutes.clamp(1, 59));
  }
  if (interval.inHours < 24) return l.intervalHours(interval.inHours);
  if (interval.inDays < 30) return l.intervalDays(interval.inDays);
  return l.intervalMonths((interval.inDays / 30).round());
}
