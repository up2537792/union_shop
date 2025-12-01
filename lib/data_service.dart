/*
  File: lib/data_service.dart
  Purpose: Data service layer (example/hardcoded data). Provides sample products, collections and simple search utilities used by the demo UI.
  Notes: Currently returns in-memory hardcoded data for offline demonstration; replaceable with API or cloud storage.
*/
/*
  文件：lib/data_service.dart
  说明：应用的数据服务层（示例/硬编码数据）。
  已实现功能要点：
  - 提供静态产品列表（getProducts），包含 id、标题、价格、图片路径与 variants。
  - 提供按 id 获取产品的工具方法（getProductById）和简单搜索（searchProducts）。
  - 提供集合（Collection）数据（getCollections）。
  备注：当前使用硬编码数据以便离线演示；可替换为外部 API 或云端存储。
*/
import 'models.dart';

class DataService {
  // Singleton for simple access
  DataService._privateConstructor();
  static final DataService instance = DataService._privateConstructor();

  // Hardcoded sample products
  List<ProductModel> getProducts() {
    return [
        // Use embedded small PNG data URIs as placeholders so the app shows images
        // even if `assets/images/` is not populated. You can replace these with
        // real asset paths (e.g. 'assets/images/shirt1.jpg') later.
        ProductModel(
          id: 'p1',
          title: 'Cartoon hooded sweatshirt',
          price: '£28.00',
          imageUrl: 'assets/images/shirt1.png',
          variants: {
            'Red': ['assets/images/shirt1_red.png'],
            'Blue': ['assets/images/shirt1_blue.png'],
            'Black': ['assets/images/shirt1_black.png'],
          },
        ),
        ProductModel(
          id: 'p2',
          title: 'T-shirt',
          price: '£15.00',
          imageUrl: 'assets/images/shirt2.png',
          variants: {
            'Blue': ['assets/images/shirt2_blue.png'],
            'Black': ['assets/images/shirt2_black.png'],
            'Red': ['assets/images/shirt2_red.png'],
          },
        ),
        ProductModel(
          id: 'p3',
          title: 'turtleneck sweater',
          price: '£20.00',
          imageUrl: 'assets/images/shirt3.png',
          variants: {
            'Black': ['assets/images/shirt3_black.png'],
            'Blue': ['assets/images/shirt3_blue.png'],
            'Red': ['assets/images/shirt3_red.png'],
          },
        ),
        ProductModel(
          id: 'p4',
          title: 'plaid shirt',
          price: '£25.00',
          imageUrl: 'assets/images/shirt4.png',
          variants: {
            'Black': ['assets/images/shirt4_black.png'],
          },
        ),
        ProductModel(
          id: 'p5',
          title: 'Pen',
          price: '£2.50',
          imageUrl: 'assets/images/Stationery_1.png',
          variants: {
            'Default': ['assets/images/Stationery_1.png'],
          },
        ),
        ProductModel(
          id: 'p6',
          title: 'Notebook',
          price: '£6.00',
          imageUrl: 'assets/images/Stationery_2.png',
          variants: {
            'Default': ['assets/images/Stationery_2.png'],
          },
        ),
        ProductModel(
          id: 'p7',
          title: 'Necklace',
          price: '£4.00',
          imageUrl: 'assets/images/Accessories_1.png',
          variants: {
            'Default': ['assets/images/Accessories_1.png'],
          },
        ),
        ProductModel(
          id: 'p8',
          title: 'Ring',
          price: '£5.00',
          imageUrl: 'assets/images/Accessories_2.png',
          variants: {
            'Default': ['assets/images/Accessories_2.png'],
          },
        ),
        ProductModel(
          id: 'p9',
          title: 'Hat',
          price: '£3.50',
          imageUrl: 'assets/images/Accessories_3.png',
          variants: {
            'Default': ['assets/images/Accessories_3.png'],
          },
        ),
        ProductModel(
          id: 'p10',
          title: 'Special Offer T-shirt',
          price: '£12.00',
          origPrice: '£20.00',
          imageUrl: 'assets/images/Special_Offer_T-shirt_1.png',
          variants: {
            'Default': ['assets/images/Special_Offer_T-shirt_1.png'],
          },
        ),
        ProductModel(
          id: 'p11',
          title: 'Special Offer Hoodie',
          price: '£25.00',
          origPrice: '£40.00',
          imageUrl: 'assets/images/Special_Offer_Hooded_Sweatshirt_1.png',
          variants: {
            'Default': ['assets/images/Special_Offer_Hooded_Sweatshirt_1.png'],
          },
        ),
        ProductModel(
          id: 'p12',
          title: 'Special Offer Badge',
          price: '£2.00',
          origPrice: '£5.00',
          imageUrl: 'assets/images/Special_Offer_Badge_1.png',
          variants: {
            'Default': ['assets/images/Special_Offer_Badge_1.png'],
          },
        ),
    ];
  }

  List<ProductModel> searchProducts(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return getProducts().where((p) {
      return p.title.toLowerCase().contains(q) || p.id.toLowerCase() == q;
    }).toList();
  }

  ProductModel? getProductById(String id) {
    for (final p in getProducts()) {
      if (p.id == id) return p;
    }
    return null;
  }

  List<CollectionModel> getCollections() {
    return const [
      CollectionModel(id: 'c1', title: 'Stationery', description: 'Notebooks, pens and more'),
      CollectionModel(id: 'c2', title: 'Apparel', description: 'T-shirts, hoodies'),
      CollectionModel(id: 'c3', title: 'Accessories', description: 'Bags and badges'),
    ];
  }
}
