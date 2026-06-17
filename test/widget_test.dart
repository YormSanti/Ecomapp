import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecomapp/main.dart';

void main() {
  testWidgets('First screen renders app bar actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('First Screen'), findsOneWidget);
    expect(find.byIcon(Icons.list), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);

    await tester.tap(find.byIcon(Icons.list));
    await tester.pump();

    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pump();

    expect(find.byIcon(Icons.light_mode), findsOneWidget);
  });
}
