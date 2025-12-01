/*
  File: lib/sale_collection_page.dart
  Purpose: Sale collection page. Shows discounted items with original and sale prices, and highlights items on sale.
  Notes: Uses a responsive GridView to adapt columns and aspect ratio for different screen widths.
*/
/*
  文件：lib/sale_collection_page.dart
  说明：特价集合页面（Sale Collection Page）。
  已实现功能要点：
  - 展示限时折扣商品的列表卡片，包含原价与折后价的显示。
  - 卡片支持点击进入商品详情页，并在有原价时显示显眼的 SALE 徽章。
  - 使用浅粉色卡片背景以保持与应用整体配色一致，并使用 GridView 适配不同屏幕宽度。
  备注：商品数据可通过 `DataService` 获取，本页面以演示折扣专区为主。
*/
import 'package:flutter/material.dart';
import 'dart:convert';
import 'data_service.dart';
import 'models.dart';

class SaleCollectionPage extends StatelessWidget {
  const SaleCollectionPage({super.key});

  void navigateToProduct(BuildContext context, String id) {
    Navigator.pushNamed(context, '/product', arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    final saleItems = const [
      {'id': 'p10', 'title': 'Sale T-Shirt', 'price': '£12.00', 'orig': '£20.00'},
      {'id': 'p11', 'title': 'Discounted Hoodie', 'price': '£25.00', 'orig': '£40.00'},
      {'id': 'p12', 'title': 'Clearance Badge', 'price': '£2.00', 'orig': '£5.00'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Collection'),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F0F5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'DISCOUNTED GOODS',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4d2963)),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Limited time sale — selected items discounted up to 50%!',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                int columns;
                final maxW = constraints.maxWidth;
                if (maxW >= 1000) {
                  columns = 3;
                } else if (maxW >= 600) {
                  columns = 2;
                } else {
                  columns = 1;
                }
                // account for spacing between columns
                final spacing = 12.0 * (columns - 1);
                final itemWidth = (maxW - spacing) / columns;
                const itemHeight = 180.0;
                final aspect = (itemWidth / itemHeight).clamp(1.0, 4.0);

                return GridView.count(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: aspect,
                  children: saleItems.map((item) {
                    final pid = item['id'] as String;
                    final product = DataService.instance.getProductById(pid);
                    final title = item['title'] as String;
                    final price = item['price'] as String;
                    final orig = item['orig'] as String;

                    final hasOrig = (product != null && product.origPrice.isNotEmpty && product.origPrice != product.price);
                    return GestureDetector(
                      onTap: () => navigateToProduct(context, pid),
                      child: Card(
                        color: const Color(0xFFF9F0F5),
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // image area with optional SALE badge at top-right
                            AspectRatio(
                              aspectRatio: itemWidth / 140.0,
                              child: Stack(children: [
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.all(8),
                                    child: Center(child: _buildImage(product)),
                                  ),
                                ),
                                if (hasOrig)
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(4)),
                                      child: const Text('SALE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                    ),
                                  ),
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(price, style: const TextStyle(color: Color(0xFF4d2963), fontSize: 14, fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 8),
                                      Text(orig, style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ProductModel? product) {
    final url = product?.imageUrl ?? '';
    if (url.startsWith('assets/')) {
      return Image.asset(url, fit: BoxFit.contain);
    }
    if (url.startsWith('data:')) {
      try {
        final base64Part = url.split(',').last;
        final bytes = base64Decode(base64Part);
        return Image.memory(bytes, fit: BoxFit.contain);
      } catch (_) {
        return Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey)));
      }
    }
    return Image.network(
      url.isNotEmpty ? url : 'https://shop.upsu.net/cdn/shop/files/PortsmouthCityPostcard2_1024x1024@2x.jpg?v=1752232561',
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey))),
    );
  }
}
