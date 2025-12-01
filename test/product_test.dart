import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/product_page.dart';
import 'test_asset_bundle.dart';
import 'dart:io';
import 'dart:async';

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
    return const Stream<List<int>>.empty().listen((_) {});
  }
}

void main() {
  group('Product Page Tests', () {
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
    Widget createTestWidget() {
      return DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: const MaterialApp(home: ProductPage()),
      );
    }

    testWidgets('should display product page with basic elements', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that basic UI elements are present
      expect(find.text('PLACEHOLDER HEADER TEXT'), findsOneWidget);
      expect(find.text('Placeholder Product Name'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('should display student instruction text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that student instruction guidance exists in the placeholder description
      expect(
        find.byWidgetPredicate((w) => w is Text && (w.data ?? '').contains('Students should replace')),
        findsOneWidget,
      );
    });

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that header icons are present
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that footer is present
      expect(find.text('Placeholder Footer'), findsOneWidget);
    });
  });
}
