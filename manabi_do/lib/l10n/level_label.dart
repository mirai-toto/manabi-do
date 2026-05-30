import 'package:flutter/widgets.dart';
import 'l10n.dart';

String levelLabel(String code, BuildContext context) {
  final l = context.l10n;
  return switch (code) {
    'N5' => l.levelN5,
    'N4' => l.levelN4,
    'N3' => l.levelN3,
    'N2' => l.levelN2,
    'N1' => l.levelN1,
    _ => code,
  };
}
