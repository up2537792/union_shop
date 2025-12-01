/*
  File: lib/main.dart
  Purpose: Application entry point and route registration. Implements the Home screen, navigation, hero section, product card listing and named routes (/product, /collections, /collection, /about, /personalise, /cart, etc.).
  Notes: This file composes top-level pages and wiring; page UI and data are provided by other modules.
*/
/*
  文件：lib/main.dart
  说明：应用主入口与路由声明。实现了主页、导航、Hero 区、产品卡展示、路由注册（/product、/collections、/collection、/about、/personalise、/cart 等）。
  已实现功能要点：
  - 首页 (HomeScreen)：响应式布局（移动优先），包含导航条、Hero 区、产品预览区与页脚。
  - 路由管理：为各页面注册了命名路由并进行简单导航处理。
  - ProductCard: 首页展示商品卡片并支持跳转到产品详情页。
  备注：本文件主要负责页面组合与全局导航，UI/数据由各页面/服务文件提供。
*/
import 'package:flutter/material.dart';
import 'dart:convert';
import 'auth_service.dart';
import 'data_service.dart';
import 'cart.dart' as app_cart;
import 'package:union_shop/product_page.dart';
import 'package:union_shop/about_page.dart';
import 'package:union_shop/collections_page.dart';
import 'package:union_shop/collection_page.dart';
import 'package:union_shop/sale_collection_page.dart';
import 'package:union_shop/auth_page.dart';
import 'package:union_shop/cart_page.dart';
import 'package:union_shop/account_page.dart';
import 'package:union_shop/search_results_page.dart';
import 'package:union_shop/personalise_page.dart';
import 'package:union_shop/top_actions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.init();
  await app_cart.Cart.instance.init();
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      home: const HomeScreen(),
      initialRoute: '/',
      routes: {
        '/product': (context) => const ProductPage(),
        '/about': (context) => const AboutPage(),
        '/collections': (context) => const CollectionsPage(),
        '/sale': (context) => const SaleCollectionPage(),
        '/collection': (context) => const CollectionPage(),
        '/auth': (context) => const AuthPage(),
        '/account': (context) => const AccountPage(),
        '/search': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final q = args is String ? args : '';
          return SearchResultsPage(query: q);
        },
        '/cart': (context) => const CartPage(),
        '/personalise': (context) => const PersonalisePage(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context, [String? pid]) {
    if (pid != null) {
      Navigator.pushNamed(context, '/product', arguments: pid);
    } else {
      Navigator.pushNamed(context, '/product');
    }
  }

  void placeholderCallbackForButtons() {
    // placeholder for non-functional buttons
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 静态导航栏（移动视图优先）
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF4d2963)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Union Shop',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    SizedBox(height: 8),
                    Text('静态导航（移动视图优先）',
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About Us'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/about');
                },
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
              ),
              ListTile(
                leading: const Icon(Icons.store),
                title: const Text('Products'),
                onTap: () {
                  Navigator.pop(context);
                  navigateToProduct(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_offer),
                title: const Text('Sale'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/sale');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Account'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/auth');
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag_outlined),
                title: const Text('Cart'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/cart');
                },
              ),
            ],
          ),
        ),
      ),
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top navigation (promo bar + nav bar)
            _TopNavigation(onSearch: (q) {
              if (q.trim().isNotEmpty) Navigator.pushNamed(context, '/search', arguments: q.trim());
            }),

            // Hero Section
            SizedBox(
              height: 360,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/Background_0.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
                          ),
                        ),
                        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.35))),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    top: 48,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Essential Range - Over 20% OFF!',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.05,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Over 20% off our Essential Range. Come and grab yours while stock lasts!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/collection', arguments: 'c2'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4d2963),
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: const Text(
                            'BROWSE COLLECTION',
                            style: TextStyle(fontSize: 14, letterSpacing: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Products Section (移动视图优先)
            Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'PARTIAL PRODUCT DISPLAY',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 2 : 1,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 20,
                        childAspectRatio: 3.5,
                      children: DataService.instance.getProducts().map((p) => ProductCard(
                          productId: p.id,
                          title: p.title,
                          price: p.price,
                          origPrice: p.origPrice,
                          imageUrl: p.imageUrl,
                        )).toList(),
                    ),
                    const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/collections'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4d2963),
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text('VIEW ALL PRODUCTS'),
                    ),
                  ],
                ),
              ),
            ),

            // Footer（带假链接）
            Container(
              width: double.infinity,
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Union Shop',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Student union store demo — static content for assignment. Replace with real links when available.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // Footer search (small)
                  TextButton.icon(
                    onPressed: () async {
                      final q = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          final ctl = TextEditingController();
                          return AlertDialog(
                            title: const Text('Search products'),
                            content: TextField(
                              controller: ctl,
                              decoration: const InputDecoration(hintText: 'Enter search terms'),
                              autofocus: true,
                              onSubmitted: (v) => Navigator.of(context).pop(v),
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                              ElevatedButton(onPressed: () => Navigator.of(context).pop(ctl.text.trim()), child: const Text('Search')),
                            ],
                          );
                        },
                      );
                      if (q != null && q.trim().isNotEmpty) Navigator.pushNamed(context, '/search', arguments: q.trim());
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Search products'),
                  ),

                  // Dummy links (mobile-first layout via Wrap)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      TextButton(
                        onPressed: () => navigateToHome(context),
                        child: const Text('Home'),
                      ),
                      TextButton(
                        onPressed: () => navigateToProduct(context),
                        child: const Text('Products'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/about'),
                        child: const Text('About Us'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Privacy'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Terms'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Contact: info@unionshop.example • Student Union House, Example University',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Responsive top navigation used on the homepage
  Widget _TopNavigation({required void Function(String) onSearch}) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      // Promo stripe
      final promo = Container(
        width: double.infinity,
        color: const Color(0xFF4d2963),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: const Center(
          child: Text(
            'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      );

      // Narrow/mobile layout: hamburger, logo center, icons on right
              if (width < 720) {
        return Column(children: [
          promo,
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer()),
              Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.network('https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854', height: 36, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                  const SizedBox(width: 8),
                  const Text('The UNION', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
              ),
                      const TopActions(),
            ]),
          ),
        ]);
      }

      // Desktop layout: logo left, centered nav, icons right
      return Column(children: [
        promo,
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              // Logo
              Row(children: [
                Image.network('https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854', height: 48, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                const SizedBox(width: 12),
                const Text('The UNION', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ]),

              // Center nav
              Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TextButton(onPressed: () => Navigator.pushNamed(context, '/'), child: const Text('Home')),
                  const SizedBox(width: 8),
                  // Shop dropdown
                  PopupMenuButton<String>(
                    child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Shop ▾')),
                    onSelected: (v) => Navigator.pushNamed(context, '/collections'),
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'collections', child: Text('Collections')),
                      const PopupMenuItem(value: 'all', child: Text('All products')), 
                    ],
                  ),
                  const SizedBox(width: 8),
                  // The Print Shack dropdown
                  PopupMenuButton<String>(
                    child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('The Print Shack ▾')),
                    onSelected: (v) {
                      if (v == 'personalise') {
                        Navigator.pushNamed(context, '/personalise');
                      } else if (v == 'about') {
                        Navigator.pushNamed(context, '/about');
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'about', child: Text('About')),
                      const PopupMenuItem(value: 'personalise', child: Text('Personalise')),
                    ],
                  ),
                  const SizedBox(width: 12),
                  TextButton(onPressed: () => Navigator.pushNamed(context, '/sale'), child: const Text('SALE!')),
                  const SizedBox(width: 12),
                  TextButton(onPressed: () => Navigator.pushNamed(context, '/about'), child: const Text('About us')),
                  const SizedBox(width: 12),
                ]),
              ),

              // Right icons
                Row(children: [
                const TopActions(),
              ])
            ],
          ),
        ),
      ]);
    });
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String origPrice;
  final String imageUrl;
  final String? productId;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    this.origPrice = '',
    required this.imageUrl,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (productId != null) {
          Navigator.pushNamed(context, '/product', arguments: productId);
        } else {
          Navigator.pushNamed(context, '/product');
        }
      },
      child: Card(
        color: const Color(0xFFF9F0F5),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: imageUrl.startsWith('assets/')
                            ? Image.asset(
                                imageUrl,
                                fit: BoxFit.contain,
                              )
                            : imageUrl.startsWith('data:')
                                ? Builder(builder: (context) {
                                    try {
                                      final base64Part = imageUrl.split(',').last;
                                      final bytes = base64Decode(base64Part);
                                      return Image.memory(bytes, fit: BoxFit.contain);
                                    } catch (_) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                                      );
                                    }
                                  })
                                : Image.network(
                                    imageUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(Icons.image_not_supported, color: Colors.grey),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ),
                  ),
                  if (origPrice.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(4)),
                        child: const Text('SALE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black),
                      maxLines: 2),
                  const SizedBox(height: 6),
                  if (origPrice.isNotEmpty)
                    Row(children: [
                      Text(price, style: const TextStyle(fontSize: 13, color: Color(0xFF4d2963), fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text(origPrice, style: const TextStyle(fontSize: 13, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                    ])
                  else
                    Text(price, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}