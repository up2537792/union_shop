/*
  File: lib/collection_page.dart
  Purpose: Single collection page. Shows the collection cover and a responsive product grid for products in the selected collection.
  Notes: Fetches products from `DataService` and uses `ProductCard` for navigation to product details.
*/
/*
  文件：lib/collection_page.dart
  说明：展示单个商品集合的页面（Collection Page）。
  已实现功能要点：
  - 根据集合 ID 展示集合封面与商品网格。
  - 使用自适应布局展示商品图片（Expanded + Stack），并保证卡片裁剪与圆角效果。
  - 卡片背景使用浅粉色 `Color(0xFFF9F0F5)`，并调整 `childAspectRatio` 以获得更紧凑的布局。
  备注：从 `DataService` 获取商品数据并通过 `ProductCard` 跳转到详情页。
*/
import 'package:flutter/material.dart';
import 'data_service.dart';
import 'models.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  String selectedSort = 'Popular';
  String selectedFilter = 'All';

  List productsForCollection(String? cid) {
    final all = DataService.instance.getProducts();
    if (cid == null) return all;
    // simple mapping of products to collections for demo purposes
    if (cid == 'c1') return all.where((p) => p.id == 'p5' || p.id == 'p6').toList();
    // c2 includes apparel p1-p4 plus special offers p10 and p11 (p11 moved here)
    if (cid == 'c2') return all.where((p) => ['p1', 'p2', 'p3', 'p4', 'p10', 'p11'].contains(p.id)).toList();
    // c3 includes accessories p7-p9 plus the special offer badge p12 (p12 moved here)
    if (cid == 'c3') return all.where((p) => ['p7', 'p8', 'p9', 'p12'].contains(p.id)).toList();
    return all;
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final cid = arg is String ? arg : null;
    final collectionProducts = productsForCollection(cid);

    return Scaffold(
      appBar: AppBar(
        title: Text(cid == null ? 'Collection' : 'Collection: $cid'),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedSort,
                  items: const [
                    DropdownMenuItem(value: 'Popular', child: Text('Popular')),
                    DropdownMenuItem(value: 'Price: Low to High', child: Text('Price: Low to High')),
                  ],
                  onChanged: (v) => setState(() => selectedSort = v ?? 'Popular'),
                  decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 140,
                child: DropdownButtonFormField<String>(
                  value: selectedFilter,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'On sale', child: Text('On sale')),
                  ],
                  onChanged: (v) => setState(() => selectedFilter = v ?? 'All'),
                  decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                ),
              ),
            ]),
            const SizedBox(height: 12),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.2, // make cards wider and reduce vertical pink area
                ),
                itemCount: collectionProducts.length,
                itemBuilder: (context, i) {
                  final p = collectionProducts[i];
                  final onSale = (p is ProductModel) ? (p.origPrice.isNotEmpty && p.origPrice != p.price) : false;
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/product', arguments: p.id),
                    child: Card(
                      color: const Color(0xFFF9F0F5),
                      elevation: 1,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // make the image area flexible so it scales to the grid cell
                          Expanded(
                            child: Stack(children: [
                              Positioned.fill(
                                child: _buildImageWidget(p.imageUrl),
                              ),
                              if (onSale)
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
                                Text(p.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                if (p is ProductModel && p.origPrice.isNotEmpty && p.origPrice != p.price)
                                  Row(children: [
                                    Text(p.price, style: const TextStyle(color: Color(0xFF4d2963), fontSize: 14, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Text(p.origPrice, style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough)),
                                  ])
                                else
                                  Text(p.price, style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String url) {
    // choose asset or network depending on the URL; robust for both local and remote images
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
      );
    }
    return Image.asset(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]),
    );
  }
}
