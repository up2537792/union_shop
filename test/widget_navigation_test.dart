import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/collections_page.dart';

void main() {
  testWidgets('Home -> VIEW ALL PRODUCTS navigates to Collections', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: const HomeScreen(), routes: {'/collections': (c) => const CollectionsPage()}));
    await tester.pumpAndSettle();

    final viewAll = find.text('VIEW ALL PRODUCTS');
    expect(viewAll, findsOneWidget);

    await tester.tap(viewAll);
    await tester.pumpAndSettle();

    // CollectionsPage should be shown (AppBar title 'Collections')
    expect(find.text('Collections'), findsOneWidget);
  });
}
