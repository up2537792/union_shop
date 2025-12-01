import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_shop/cart.dart';
import 'package:union_shop/models.dart';

void main() {
  group('Cart', () {
    final cart = Cart.instance;

    setUp(() async {
      // Provide mock SharedPreferences and clear cart
      SharedPreferences.setMockInitialValues({});
      await cart.clear();
    });

    test('add and update quantity', () async {
      final p = ProductModel(id: 'test-p', title: 'Test', price: '£1.00', imageUrl: '');
      cart.add(p, quantity: 2);
      expect(cart.items.value.length, 1);
      expect(cart.items.value.first.quantity, 2);

      cart.add(p, quantity: 3);
      expect(cart.items.value.first.quantity, 5);
    });

    test('remove item', () async {
      final p = ProductModel(id: 'test-p2', title: 'Test2', price: '£2.00', imageUrl: '');
      cart.add(p, quantity: 1);
      expect(cart.items.value.any((i) => i.product.id == p.id), true);
      cart.removeById(p.id);
      expect(cart.items.value.any((i) => i.product.id == p.id), false);
    });
  });
}
