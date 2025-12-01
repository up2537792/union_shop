/*
  File: lib/collections_page.dart
  Purpose: Collections listing page. Displays collection thumbnails, titles and descriptions, and navigates to a single collection view.
  Notes: Uses local assets where available; intended as a simple data-driven collections overview for the demo.
*/
/*
  文件：lib/collections_page.dart
  说明：展示所有商品集合的列表页面（Collections Page）。
  已实现功能要点：
  - 列表展示每个集合的缩略图、名称与描述。
  - 点击集合项可进入对应的 `CollectionPage`。
  - 处理资源路径以确保在各平台上加载本地图片（使用正斜杠）。
*/
import 'package:flutter/material.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  void navigateToCollection(BuildContext context) {
    Navigator.pushNamed(context, '/collection');
  }

  @override
  Widget build(BuildContext context) {
    final collections = const [
      {'id': 'c1', 'title': 'Stationery', 'subtitle': 'Notebooks, pens and more', 'image': 'assets/images/Stationery_0.png'},
      {'id': 'c2', 'title': 'Apparel', 'subtitle': 'T-shirts, hoodies', 'image': 'assets/images/shirt4_black.png'},
      {'id': 'c3', 'title': 'Accessories', 'subtitle': 'Necklace, ring, hat', 'image': 'assets/images/Accessories_0.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: collections.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final c = collections[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/collection', arguments: collections[index]['id']);
            },
            child: Card(
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 80,
                    child: Builder(builder: (ctx) {
                      final img = c['image']!;
                      if (img.startsWith('assets/')) {
                        return Image.asset(img, fit: BoxFit.cover);
                      }
                      return Image.network(img, fit: BoxFit.cover, errorBuilder: (cxt, err, st) => Container(color: Colors.grey[200]));
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c['title']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text(c['subtitle']!, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
