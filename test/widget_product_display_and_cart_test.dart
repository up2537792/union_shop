import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/product_page.dart';

void main() {
  testWidgets('ProductPage shows product title when opened with id', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/product',
      onGenerateRoute: (settings) {
        if (settings.name == '/product') {
          return MaterialPageRoute(
            builder: (_) => const ProductPage(),
            settings: const RouteSettings(arguments: 'p1'),
          );
        }
        return null;
      },
    ));

    await tester.pumpAndSettle();

    expect(find.text('Cartoon hooded sweatshirt'), findsOneWidget);
  });

  testWidgets('Tapping Add to cart shows a SnackBar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/product',
      onGenerateRoute: (settings) {
        if (settings.name == '/product') {
          return MaterialPageRoute(
            builder: (_) => const ProductPage(),
            settings: const RouteSettings(arguments: 'p1'),
          );
        }
        return null;
      },
    ));

    await tester.pumpAndSettle();

    final addButton = find.text('Add to cart');
    expect(addButton, findsOneWidget);

    // Ensure the button is visible (page is scrollable) before tapping
    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();

    await tester.tap(addButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(SnackBar), findsOneWidget);
  });
}
