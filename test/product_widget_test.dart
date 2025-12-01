import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/data_service.dart';
import 'test_asset_bundle.dart';

void main() {
  testWidgets('ProductPage for p1 shows title and price and add-to-cart', (WidgetTester tester) async {
    await tester.pumpWidget(DefaultAssetBundle(
      bundle: TestAssetBundle(),
      child: MaterialApp(
        routes: {
          '/product': (context) => const ProductPage(),
        },
        home: Builder(builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamed(context, '/product', arguments: 'p1');
          });
          return const SizedBox.shrink();
        }),
      ),
    ));

    await tester.pumpAndSettle();

    // product title should appear (contains 'Cartoon')
    final titleFinder = find.byWidgetPredicate((w) => w is Text && (w.data ?? '').contains('Cartoon'));
    expect(titleFinder, findsWidgets);
    // price symbol present
    final priceFinder = find.byWidgetPredicate((w) => w is Text && (w.data ?? '').contains('£'));
    expect(priceFinder, findsWidgets);
    // Add to cart button exists
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}
