import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/data_service.dart';
import 'package:union_shop/models.dart';

void main() {
  group('DataService', () {
    final ds = DataService.instance;

    test('getProducts returns non-empty list and contains ProductModel', () {
      final products = ds.getProducts();
      expect(products, isNotEmpty);
      expect(products.first, isA<ProductModel>());
    });

    test('getProductById returns correct product or null', () {
      final products = ds.getProducts();
      final first = products.first;
      final found = ds.getProductById(first.id);
      expect(found, isNotNull);
      expect(found?.id, equals(first.id));

      final missing = ds.getProductById('non-existent-id');
      expect(missing, isNull);
    });

    test('collections mapping contains expected collections', () {
      final cols = ds.getCollections();
      expect(cols, isNotEmpty);
      // basic shape check
      expect(cols.first.id, isNotEmpty);
      expect(cols.first.title, isNotEmpty);
    });
  });
}
