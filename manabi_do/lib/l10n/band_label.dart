import 'package:flutter/widgets.dart';
import 'l10n.dart';

/// The display name of a vocabulary coverage band.
///
/// Named for how far into the language the band takes you, because that is what
/// it measures: a share of running Japanese, not a share of our word list. A
/// proficiency name ("Beginner", "Advanced") would imply a taught order that no
/// part of the pipeline provides.
String bandLabel(int band, BuildContext context) {
  final l = context.l10n;
  return switch (band) {
    1 => l.band1,
    2 => l.band2,
    3 => l.band3,
    4 => l.band4,
    5 => l.band5,
    _ => '$band',
  };
}
