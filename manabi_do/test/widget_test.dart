import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:manabi_do/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ManabiDoApp()));
    await tester.pumpAndSettle();
    expect(find.byType(ManabiDoApp), findsOneWidget);
  });
}
