/*
  文件：lib/models.dart
  说明：域模型定义与辅助扩展。
  已实现功能要点：
  - 定义 ProductModel、CollectionModel、CartItem 等模型结构。
  - 提供价格解析等便捷扩展（例如 priceValue）。
  备注：模型为应用中数据传递与持久化提供基础结构。
*/
import 'package:flutter/material.dart';
class ProductModel {
  final String id;
  final String title;
  final String price; // keep as string for simplicity, e.g. '£12.00'
  final String origPrice; // optional original price to display struck-through
  final String imageUrl;
  final Map<String, List<String>> variants; // color -> list of imageUrls mapping

  const ProductModel({required this.id, required this.title, required this.price, required this.imageUrl, this.variants = const <String, List<String>>{}, this.origPrice = ''});
}

class CollectionModel {
  final String id;
  final String title;
  final String description;

  const CollectionModel({required this.id, required this.title, required this.description});
}

// Simple user model for local/demo authentication
class User {
  final String id;
  final String email;
  final String displayName;

  User({required this.id, required this.email, required this.displayName});

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
      };

  static User fromJson(Map<String, dynamic> j) => User(
        id: j['id'] ?? '',
        email: j['email'] ?? '',
        displayName: j['displayName'] ?? '',
      );
}

// CartItem to hold product + quantity for cart management
class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toJson() => {
        'product': {
          'id': product.id,
          'title': product.title,
          'price': product.price,
          'origPrice': product.origPrice,
          'imageUrl': product.imageUrl,
          'variants': product.variants,
        },
        'quantity': quantity,
      };

  static CartItem fromJson(Map<String, dynamic> j) {
    final p = j['product'] as Map<String, dynamic>;
    final rawVariants = p['variants'] ?? {};
    final variants = <String, List<String>>{};
    try {
      (rawVariants as Map).forEach((k, v) {
        if (v is String) {
          variants[k.toString()] = [v];
        } else if (v is List) {
          variants[k.toString()] = v.map((e) => e.toString()).toList();
        } else {
          variants[k.toString()] = [v.toString()];
        }
      });
    } catch (_) {}

    final prod = ProductModel(
      id: p['id'] ?? '',
      title: p['title'] ?? '',
      price: p['price'] ?? '0',
      origPrice: p['origPrice'] ?? '',
      imageUrl: p['imageUrl'] ?? '',
      variants: variants,
    );
    return CartItem(product: prod, quantity: (j['quantity'] ?? 1) as int);
  }
}

extension ProductPriceParsing on ProductModel {
  // Parse price string like '£12.00' or '12.00' into a double
  double get priceValue {
    final cleaned = price.replaceAll(RegExp(r'[^0-9\.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }
}
