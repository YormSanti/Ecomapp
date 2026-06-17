import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecomapp/detail_screen.dart';
import 'package:ecomapp/main.dart';
import 'package:ecomapp/product_model.dart';

void main() {
  testWidgets('First screen renders app bar actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('First Screen'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.list), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);

    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pump();

    expect(find.byIcon(Icons.light_mode), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text('Search'), findsWidgets);
    expect(find.byIcon(Icons.search), findsWidgets);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Switched to Dark Mode'), findsOneWidget);
    expect(find.text('Switched to Grid Style'), findsOneWidget);

    await tester.tap(find.text('Switched to Grid Style'));
    await tester.pumpAndSettle();

    expect(find.text('Switched to List Style'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();

    expect(find.text('First Screen'), findsOneWidget);
    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pump();

    expect(find.byIcon(Icons.list), findsOneWidget);
  });

  testWidgets('Detail screen renders product information', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(420, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final item = ProductModel(
      id: 1,
      title: 'Elegant Purple Leather Loafers',
      slug: 'elegant-purple-leather-loafers',
      price: 17,
      description: 'Step into sophistication with elegant purple loafers.',
      category: Category(
        id: 1,
        name: 'Shoes',
        slug: 'shoes',
        image: 'https://example.com/category.png',
        creationAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
      images: const ['https://example.com/shoe.png'],
      creationAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

    await tester.pumpWidget(MaterialApp(home: DetailScreen(item: item)));

    expect(find.text('Detail Screen'), findsOneWidget);
    expect(find.text('Elegant Purple Leather Loafers'), findsOneWidget);
    expect(find.byIcon(Icons.open_in_new), findsOneWidget);
    expect(find.byIcon(Icons.call), findsOneWidget);
    expect(find.text('17.00'), findsOneWidget);
    expect(find.byIcon(Icons.pin_drop), findsOneWidget);
    expect(find.text('Shoes'), findsOneWidget);
    expect(find.text('Add To Cart'), findsOneWidget);
  });
}
