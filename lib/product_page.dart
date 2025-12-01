/*
  File: lib/product_page.dart
  Purpose: Product detail page. Displays large product images, interactive zoom, variant selection and add-to-cart functionality.
  Notes: Includes a close/back action and a post-frame redirect to a default product when no product ID is provided (avoids navigation during build).
*/
/*
  文件：lib/product_page.dart
  说明：商品详情页（Product Page）。
  已实现功能要点：
  - 展示商品大图，支持缩放（InteractiveViewer）和多角度缩略图切换。
  - 提供关闭/返回按钮，优先使用 Navigator.pop 返回上一页，否则导航到首页。
  - 支持将商品加入购物车并显示提示（SnackBar）。
  - 当未提供商品 ID 时，使用 post-frame 回调重定向到默认商品（p4），避免在构建期导航问题。
*/
import 'package:flutter/material.dart';
import 'dart:convert';
import 'models.dart';
import 'cart.dart';
// auth handled by TopActions now
import 'data_service.dart';
import 'top_actions.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String selectedSize = 'M';
  String selectedColor = ''; // empty means use product's first variant
  int quantity = 1;
  int selectedImageIndex = 0; // index within selected color's image list

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void placeholderCallbackForButtons() {}

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final pid = arg is String ? arg : null;
    final product = pid != null ? DataService.instance.getProductById(pid) : null;

    // If no product id was provided, show placeholder product details
    // Note: avoid performing navigation here during build/test to keep
    // widget tests stable and to allow this page to be previewed directly.
    if (pid == null) {
      // leave `product` as null and render placeholder UI below
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header: promo stripe + white nav row
            Column(
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFF4d2963),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Center(
                    child: Text('PLACEHOLDER HEADER TEXT', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Exit / back button
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            navigateToHome(context);
                          }
                        },
                      ),
                      GestureDetector(
                        onTap: () => navigateToHome(context),
                        child: Row(children: const [
                          Text('The ', style: TextStyle(fontSize: 20, color: Colors.black87)),
                          Text('UNION', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4d2963))),
                        ]),
                      ),
                      const Spacer(),
                      Row(children: [
                        const TopActions(),
                        IconButton(icon: const Icon(Icons.menu, size: 20, color: Colors.grey), onPressed: placeholderCallbackForButtons),
                      ])
                    ],
                  ),
                ),
              ],
            ),

            // Product details
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image (show full pattern using BoxFit.contain; support assets/data URI/network)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => Dialog(
                          insetPadding: const EdgeInsets.all(12),
                            child: InteractiveViewer(child: _buildImageWidget(_currentImageFor(product))),
                        ),
                      );
                    },
                    child: Container(
                      height: 420,
                      width: double.infinity,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[100]),
                      child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Center(child: _buildImageWidget(_currentImageFor(product)))),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Product name & price
                  Text(product?.title ?? 'Placeholder Product Name', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 12),
                  if (product != null && product.origPrice.isNotEmpty && product.origPrice != product.price)
                    Row(children: [
                      Text(product.price, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4d2963))),
                      const SizedBox(width: 12),
                      Text(product.origPrice, style: const TextStyle(fontSize: 18, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                    ])
                  else
                    Text(product?.price ?? '£15.00', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4d2963))),

                  const SizedBox(height: 24),

                  // Options: size + color
                  Row(children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedSize,
                        items: const [
                          DropdownMenuItem(value: 'S', child: Text('Small')),
                          DropdownMenuItem(value: 'M', child: Text('Medium')),
                          DropdownMenuItem(value: 'L', child: Text('Large')),
                        ],
                        onChanged: (v) => setState(() => selectedSize = v ?? 'M'),
                        decoration: const InputDecoration(labelText: 'Size', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Builder(builder: (context) {
                        final Map<String, List<String>> variants = product?.variants ?? <String, List<String>>{};
                        final hasVariants = variants.isNotEmpty;
                        // determine effective color: use selectedColor if set and valid, otherwise first variant (if any)
                        final effectiveColor = (selectedColor.isNotEmpty && variants.containsKey(selectedColor))
                            ? selectedColor
                            : (hasVariants ? variants.keys.first : 'Black');
                        final items = hasVariants
                            ? variants.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList()
                            : const [
                                DropdownMenuItem(value: 'Black', child: Text('Black')),
                                DropdownMenuItem(value: 'Red', child: Text('Red')),
                                DropdownMenuItem(value: 'Blue', child: Text('Blue')),
                              ];

                            return DropdownButtonFormField<String>(
                              value: effectiveColor,
                              items: items,
                              onChanged: (v) => setState(() {
                                selectedColor = v ?? effectiveColor;
                                selectedImageIndex = 0;
                              }),
                              decoration: const InputDecoration(labelText: 'Color', border: OutlineInputBorder()),
                            );
                      }),
                    ),
                  ]),

                  const SizedBox(height: 8),
                  // Color swatches + thumbnails for quick visual selection
                  Builder(builder: (context) {
                    final Map<String, List<String>> variants = product?.variants ?? <String, List<String>>{};
                    if (variants.isEmpty) return const SizedBox.shrink();
                    final effectiveColor = (selectedColor.isNotEmpty && variants.containsKey(selectedColor)) ? selectedColor : variants.keys.first;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: variants.keys.map((c) {
                            Color col;
                            switch (c.toLowerCase()) {
                              case 'red':
                                col = Colors.red;
                                break;
                              case 'blue':
                                col = Colors.blue;
                                break;
                              case 'black':
                                col = Colors.black;
                                break;
                              case 'white':
                                col = Colors.white;
                                break;
                              default:
                                col = Colors.grey;
                            }
                            final isSelected = (selectedColor.isNotEmpty && selectedColor == c) || (selectedColor.isEmpty && variants.keys.first == c);
                            return GestureDetector(
                              onTap: () => setState(() {
                                selectedColor = c;
                                selectedImageIndex = 0;
                              }),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(color: isSelected ? const Color(0xFF4d2963) : Colors.grey.shade300, width: isSelected ? 2 : 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: CircleAvatar(radius: 14, backgroundColor: col),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 8),
                        Builder(builder: (_) {
                          final imgs = variants[effectiveColor] ?? [];
                          if (imgs.isEmpty) return const SizedBox.shrink();
                          return SizedBox(
                            height: 64,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, idx) {
                                final img = imgs[idx];
                                final isSel = idx == selectedImageIndex;
                                return GestureDetector(
                                  onTap: () => setState(() => selectedImageIndex = idx),
                                  child: Container(
                                    width: 64,
                                    decoration: BoxDecoration(border: Border.all(color: isSel ? const Color(0xFF4d2963) : Colors.grey.shade300, width: isSel ? 2 : 1)),
                                    child: Padding(padding: const EdgeInsets.all(4), child: _buildImageWidget(img)),
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemCount: imgs.length,
                            ),
                          );
                        }),
                      ],
                    );
                  }),

                  const SizedBox(height: 16),

                  // Quantity selector
                  Row(children: [
                    const Text('Quantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                      child: Row(children: [
                        IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() { if (quantity > 1) quantity -= 1; })),
                        Text(quantity.toString(), style: const TextStyle(fontSize: 16)),
                        IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() { quantity += 1; })),
                      ]),
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // Product description
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
                  const SizedBox(height: 8),
                  Text(product != null ? 'Product ID: ${product.id}\n\nThis is a demo product detail rendered from the local DataService. Replace with real description in the full implementation.' : 'This is a placeholder description for the product. Students should replace this with real product information and implement proper data management.', style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5)),

                  const SizedBox(height: 16),
                  // Add to cart button (uses selected quantity)
                  ElevatedButton(
                    onPressed: () {
                      final p = product!;
                      Cart.instance.add(p, quantity: quantity);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added $quantity x ${p.title} to cart')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4d2963),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Add to cart', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),

            // Footer
            Container(width: double.infinity, color: Colors.grey[50], padding: const EdgeInsets.all(24), child: const Text('Placeholder Footer', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600))),
          ],
        ),
      ),
    );
  }

  // Helper to build an Image widget from different URI types
  Widget _buildImageWidget(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(imageUrl, fit: BoxFit.contain);
    }

    if (imageUrl.startsWith('data:')) {
      try {
        final base64Part = imageUrl.split(',').last;
        final bytes = base64Decode(base64Part);
        return Image.memory(bytes, fit: BoxFit.contain);
      } catch (_) {
        return Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey)));
      }
    }

    // Fallback to network
    return Image.network(
      imageUrl.isNotEmpty ? imageUrl : 'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey))),
    );
  }

  

  // Determine which image to show for current selected color (falls back to base image)
  String _currentImageFor(ProductModel? product) {
    if (product == null) return '';
    if (product.variants.isNotEmpty) {
      final colorKey = (selectedColor.isNotEmpty && product.variants.containsKey(selectedColor)) ? selectedColor : product.variants.keys.first;
      final imgs = product.variants[colorKey] ?? [];
      if (imgs.isNotEmpty) {
        final idx = (selectedImageIndex >= 0 && selectedImageIndex < imgs.length) ? selectedImageIndex : 0;
        return imgs[idx];
      }
      return product.imageUrl;
    }
    return product.imageUrl;
  }
}
