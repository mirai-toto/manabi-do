import 'package:fsrs/fsrs.dart' show Rating;

/// Maps the outcome of a finished drawing attempt onto an SRS rating.
///
/// Leaning on a hint, or getting any stroke wrong, counts as a failed recall.
Rating drawingRating({required bool hintsUsed, required int mistakes}) {
  if (hintsUsed) return Rating.again;
  return mistakes == 0 ? Rating.good : Rating.again;
}
