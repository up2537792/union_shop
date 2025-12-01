/*
  文件：lib/search_results_page.dart
  说明：搜索结果页面（Search Results Page）。
  已实现功能要点：
  - 根据用户查询调用 `DataService.searchProducts` 获取匹配商品。
  - 列表展示商品缩略图、标题与价格，并支持点击进入商品详情页。
  - 在无结果时显示友好提示文本。
*/
import 'package:flutter/material.dart';
import 'data_service.dart';

class SearchResultsPage extends StatelessWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final products = DataService.instance.searchProducts(query);
    return Scaffold(
      appBar: AppBar(title: Text('Search: "$query"'), backgroundColor: const Color(0xFF4d2963)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: products.isEmpty
            ? const Center(child: Text('No products found'))
            : ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final p = products[i];
                  return ListTile(
                    leading: SizedBox(width: 56, child: Image.network(p.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported))),
                    title: Text(p.title),
                    subtitle: Text(p.price),
                    onTap: () => Navigator.pushNamed(context, '/product', arguments: p.id),
                  );
                },
              ),
      ),
    );
  }
}
