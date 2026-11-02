import 'package:flutter/widgets.dart';
import 'l10n.dart';

/// The display name of a vocabulary vocabulary level.
///
/// Named for how far into the language the level takes you, because that is what
/// it measures: a share of running Japanese, not a share of our word list. A
/// proficiency name ("Beginner", "Advanced") would imply a taught order that no
/// part of the pipeline provides.
String vocabularyLevelLabel(int level, BuildContext context) {
  final l = context.l10n;
  return switch (level) {
    1 => l.vocabularyLevel1,
    2 => l.vocabularyLevel2,
    3 => l.vocabularyLevel3,
    4 => l.vocabularyLevel4,
    5 => l.vocabularyLevel5,
    _ => '$level',
  };
}
