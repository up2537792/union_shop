import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';
import 'dart:io';
import 'dart:async';
import 'test_asset_bundle.dart';

class _FakeHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _FakeHttpClient();
  }
}

class _FakeHttpClient implements HttpClient {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeRequest();
}

class _FakeRequest implements HttpClientRequest {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<HttpClientResponse> close() async => _FakeResponse();
}

class _FakeResponse extends Stream<List<int>> implements HttpClientResponse {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  int get statusCode => 200;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    // return empty bytes stream; ignore passed callbacks in fake
    return const Stream<List<int>>.empty().listen((_) {});
  }
}

void main() {
  group('Home Page Tests', () {
    setUpAll(() {
      HttpOverrides.global = _FakeHttpOverrides();
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.window.physicalSizeTestValue = const Size(480, 800);
      binding.window.devicePixelRatioTestValue = 1.0;
    });

    tearDownAll(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
      HttpOverrides.global = null;
    });
    testWidgets('should display home page with basic elements', (tester) async {
      final bundle = TestAssetBundle();
      await tester.pumpWidget(DefaultAssetBundle(bundle: bundle, child: const UnionShopApp()));
      await tester.pump();

      // Check that basic UI elements are present (match current app strings)
      expect(find.text('Essential Range - Over 20% OFF!'), findsOneWidget);
      expect(find.text('PARTIAL PRODUCT DISPLAY'), findsOneWidget);
      expect(find.text('BROWSE COLLECTION'), findsWidgets);
      expect(find.text('VIEW ALL PRODUCTS'), findsOneWidget);
    });

    testWidgets('should display product cards', (tester) async {
      final bundle = TestAssetBundle();
      await tester.pumpWidget(DefaultAssetBundle(bundle: bundle, child: const UnionShopApp()));
      await tester.pump();

      // Check that a few known product titles from DataService appear
      expect(find.textContaining('shirt', findRichText: false), findsWidgets);
      // Check that at least one known price from DataService appears
      expect(find.textContaining('£', findRichText: false), findsWidgets);
    });

    testWidgets('should display header icons', (tester) async {
      final bundle = TestAssetBundle();
      await tester.pumpWidget(DefaultAssetBundle(bundle: bundle, child: const UnionShopApp()));
      await tester.pump();

      // Check that header icons are present (may appear multiple times in responsive layout)
      expect(find.byIcon(Icons.search), findsWidgets);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsWidgets);
      expect(find.byIcon(Icons.menu), findsWidgets);
    });

    testWidgets('should display footer', (tester) async {
      final bundle = TestAssetBundle();
      await tester.pumpWidget(DefaultAssetBundle(bundle: bundle, child: const UnionShopApp()));
      await tester.pump();

      // Check that footer is present (look for Union Shop and the demo description)
      expect(find.text('Union Shop'), findsOneWidget);
      expect(
        find.byWidgetPredicate((w) => w is Text && (w.data ?? '').contains('Student union store demo')),
        findsOneWidget,
      );
    });
  });
}
