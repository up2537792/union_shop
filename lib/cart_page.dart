import 'package:flutter/material.dart';
import 'cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    Cart.instance.items.addListener(_onChange);
  }

  @override
  void dispose() {
    Cart.instance.items.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final items = Cart.instance.items.value;
    return Scaffold(
      appBar: AppBar(title: const Text('Cart'), backgroundColor: const Color(0xFF4d2963)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: items.isEmpty
            ? const Center(child: Text('Your cart is empty'))
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final ci = items[index];
                        final p = ci.product;
                        return ListTile(
                          leading: SizedBox(width: 56, child: Image.network(p.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]))),
                          title: Text(p.title),
                          subtitle: Text(p.price),
                          trailing: SizedBox(
                            width: 140,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => Cart.instance.updateQuantity(p.id, ci.quantity - 1),
                                ),
                                Text('${ci.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => Cart.instance.updateQuantity(p.id, ci.quantity + 1),
                                ),
                                IconButton(icon: const Icon(Icons.delete), onPressed: () => Cart.instance.removeById(p.id)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total: £${Cart.instance.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ElevatedButton(
                          onPressed: () {
                            // placeholder checkout
                            showDialog(context: context, builder: (c) => AlertDialog(title: const Text('Order placed (demo)'), actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))]));
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                          child: const Text('Place Order (demo)'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
