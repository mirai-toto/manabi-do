import 'package:flutter/material.dart';

import '../../data/database/app_database.dart';
import 'characters/kanji/kanji_detail_screen.dart';
import 'vocabulary/sentence_detail_screen.dart';
import 'vocabulary/vocabulary_detail_screen.dart';

/// Route names of detail screens share this prefix, so a chain of them can be
/// told apart from the screens around it.
const String _detailPrefix = 'detail/';

/// Opens the kanji detail for [kanjiId], or goes back to it when it is
/// already open in the chain of details on top.
Future<void> openKanjiDetail(BuildContext context, int kanjiId) => _openDetail(
  context,
  '${_detailPrefix}kanji/$kanjiId',
  (_) => KanjiDetailScreen(kanjiId: kanjiId),
);

/// Opens the word detail for [entry], or goes back to it when it is already
/// open in the chain of details on top.
Future<void> openWordDetail(BuildContext context, VocabularyEntry entry) =>
    _openDetail(
      context,
      '${_detailPrefix}word/${entry.id}',
      (_) => VocabularyDetailScreen(entry: entry),
    );

/// Opens the detail for an example [sentence], with [highlight] marked in it,
/// or goes back to it when it is already open in the chain of details on top.
Future<void> openSentenceDetail(
  BuildContext context, {
  required Sentence sentence,
  required String? translation,
  required String? translationMissingLanguage,
  required String highlight,
  required Color highlightColor,
}) => _openDetail(
  context,
  '${_detailPrefix}sentence/${sentence.id}',
  (_) => SentenceDetailScreen(
    sentence: sentence,
    translation: translation,
    translationMissingLanguage: translationMissingLanguage,
    highlight: highlight,
    highlightColor: highlightColor,
  ),
);

/// Kanji, word and sentence details link to each other, so word → kanji →
/// word would otherwise stack copies without end. Going back to the open copy
/// keeps the stack to one screen per item.
Future<void> _openDetail(
  BuildContext context,
  String name,
  WidgetBuilder builder,
) async {
  final NavigatorState navigator = Navigator.of(context);
  final DetailRouteObserver? observer = navigator.widget.observers
      .whereType<DetailRouteObserver>()
      .firstOrNull;
  if (observer != null && observer.isOpenInTopChain(name)) {
    navigator.popUntil((route) => route.settings.name == name);
    return;
  }
  await navigator.push(
    MaterialPageRoute<void>(
      settings: RouteSettings(name: name),
      builder: builder,
    ),
  );
}

/// Keeps the routes of one navigator in order, which [NavigatorState] does not
/// expose. One per tab navigator.
class DetailRouteObserver extends NavigatorObserver {
  final List<Route<dynamic>> _routes = [];

  /// Whether [name] is among the detail screens on top of the stack. The
  /// search stops at the first screen that is not a detail: going back past a
  /// practice session would end it without asking.
  bool isOpenInTopChain(String name) {
    for (final Route<dynamic> route in _routes.reversed) {
      final String? routeName = route.settings.name;
      if (routeName == null || !routeName.startsWith(_detailPrefix)) {
        return false;
      }
      if (routeName == name) return true;
    }
    return false;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _routes.add(route);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _routes.remove(route);

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _routes.remove(route);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final int index = oldRoute == null ? -1 : _routes.indexOf(oldRoute);
    if (index == -1 || newRoute == null) return;
    _routes[index] = newRoute;
  }
}
