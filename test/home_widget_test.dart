import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'test_asset_bundle.dart';

void _setLargeTestWindow() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  binding.window.physicalSizeTestValue = const Size(1200, 800);
  binding.window.devicePixelRatioTestValue = 1.0;
}

void main() {
  testWidgets('HomeScreen shows hero text and product cards', (WidgetTester tester) async {
    _setLargeTestWindow();
    await tester.pumpWidget(DefaultAssetBundle(bundle: TestAssetBundle(), child: const MaterialApp(home: HomeScreen())));
    await tester.pumpAndSettle();

    expect(find.textContaining('Essential Range'), findsWidgets);
    // ProductCard widgets exist (at least one)
    expect(find.byType(ProductCard), findsWidgets);
  });
}
