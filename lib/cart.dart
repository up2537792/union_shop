/*
  File: lib/cart.dart
  Purpose: Shopping cart core logic and UI helpers. Manages cart items, quantities and persistence using SharedPreferences.
  Notes: Exposes a ValueNotifier for UI bindings and provides add/remove/update operations for demo usage.
*/
/*
  文件：lib/cart.dart
  说明：购物车核心逻辑与 UI 展示（Cart 管理）。
  已实现功能要点：
  - 管理购物车项（增加/减少/移除）并通过 SharedPreferences 持久化存储。
  - 提供 `ValueNotifier<List<CartItem>>` 以驱动头部徽章与页面实时更新。
  - 提供常用操作：加入购物车、更新数量、移除商品、计算总价与清空购物车。
  备注：演示环境使用本地持久化；部署时可替换为后端同步逻辑。
*/
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class Cart {
  Cart._privateConstructor();
  static final Cart instance = Cart._privateConstructor();

  final ValueNotifier<List<CartItem>> items = ValueNotifier<List<CartItem>>([]);

  static const _kCartKey = 'demo_cart_v1';

  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kCartKey);
    if (raw != null) {
      try {
        final list = json.decode(raw) as List<dynamic>;
        items.value = list.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
  }

  Future<void> _save() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kCartKey, json.encode(items.value.map((e) => e.toJson()).toList()));
  }

  void add(ProductModel p, {int quantity = 1}) {
    final list = List<CartItem>.from(items.value);
    final idx = list.indexWhere((c) => c.product.id == p.id);
    if (idx >= 0) {
      list[idx].quantity += quantity;
    } else {
      list.add(CartItem(product: p, quantity: quantity));
    }
    items.value = list;
    _save();
  }

  void removeById(String productId) {
    final list = List<CartItem>.from(items.value);
    list.removeWhere((c) => c.product.id == productId);
    items.value = list;
    _save();
  }

  void updateQuantity(String productId, int quantity) {
    final list = List<CartItem>.from(items.value);
    final idx = list.indexWhere((c) => c.product.id == productId);
    if (idx >= 0) {
      if (quantity <= 0) {
        list.removeAt(idx);
      } else {
        list[idx].quantity = quantity;
      }
      items.value = list;
      _save();
    }
  }

  double get total {
    double t = 0.0;
    for (final c in items.value) {
      t += c.product.priceValue * c.quantity;
    }
    return t;
  }

  Future<void> clear() async {
    items.value = [];
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kCartKey);
  }
}
