import 'package:fsrs/fsrs.dart' show Rating;

import '../core/srs/srs_level.dart';
import 'app_localizations.dart';

/// The name of an SRS level, as shown on progress pills.
String srsLevelLabel(SrsLevel level, AppLocalizations l) => switch (level) {
  SrsLevel.newCard => l.srsStateNew,
  SrsLevel.learning => l.srsStateLearning,
  SrsLevel.apprentice => l.srsStateApprentice,
  SrsLevel.familiar => l.srsStateFamiliar,
  SrsLevel.mastered => l.srsStateMastered,
  SrsLevel.expert => l.srsStateExpert,
};

/// The name of a grade on the four-point scale.
String ratingLabel(Rating rating, AppLocalizations l) => switch (rating) {
  Rating.again => l.ratingAgain,
  Rating.hard => l.ratingHard,
  Rating.good => l.ratingGood,
  Rating.easy => l.ratingEasy,
};
