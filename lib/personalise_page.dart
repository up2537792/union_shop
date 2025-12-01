/*
  File: lib/personalise_page.dart
  Purpose: Print Shack personalisation demo page. Allows users to preview and configure personalised text on a product and add the personalised item to cart.
  Notes: Demo-only; does not perform server-side rendering. For production, integrate with a print rendering service and order workflow.
*/
/*
  文件：lib/personalise_page.dart
  说明：Print Shack 个性化定制页面（Personalise Page）。
  已实现功能要点：
  - 允许用户选择定制选项并预览效果（示例界面，适合课程演示）。
  - 提供返回与提交交互（无外部后端，仅演示本地交互）。
*/
import 'package:flutter/material.dart';
import 'dart:convert';
import 'data_service.dart';
import 'models.dart';
import 'cart.dart' as app_cart;

class PersonalisePage extends StatefulWidget {
  const PersonalisePage({Key? key}) : super(key: key);

  @override
  State<PersonalisePage> createState() => _PersonalisePageState();
}

class _PersonalisePageState extends State<PersonalisePage> {
  late List<ProductModel> _products;
  late ProductModel _selected;
  String _text = 'Your Text';
  String _colorKey = 'Black';
  double _fontSize = 28.0;
  String _position = 'Center';

  @override
  void initState() {
    super.initState();
    _products = DataService.instance.getProducts();
    _selected = _products.isNotEmpty ? _products.first : ProductModel(id: 'p0', title: 'No product', price: '0', imageUrl: '', variants: const <String, List<String>>{});
  }

  Widget _buildImageWidget(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(imageUrl, fit: BoxFit.contain);
    } else if (imageUrl.startsWith('data:')) {
      try {
        final base64Part = imageUrl.split(',').last;
        final bytes = base64Decode(base64Part);
        return Image.memory(bytes, fit: BoxFit.contain);
      } catch (_) {
        return Container(color: Colors.grey[200]);
      }
    } else if (imageUrl.isEmpty) {
      return Container(color: Colors.grey[200]);
    } else {
      return Image.network(imageUrl, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]));
    }
  }

  Alignment _alignmentForPosition(String pos) {
    switch (pos) {
      case 'Top':
        return Alignment.topCenter;
      case 'Bottom':
        return Alignment.bottomCenter;
      default:
        return Alignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = <String, Color>{'Black': Colors.black, 'White': Colors.white, 'Red': Colors.red, 'Blue': Colors.blue};

    return Scaffold(
      appBar: AppBar(title: const Text('Personalise — The Print Shack'), backgroundColor: const Color(0xFF4d2963)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preview
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 2,
                      child: Container(
                        height: 420,
                        color: Colors.grey[100],
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: _buildImageWidget(
                                  _selected.variants.isNotEmpty
                                      ? (_selected.variants.values.first.isNotEmpty ? _selected.variants.values.first.first : _selected.imageUrl)
                                      : _selected.imageUrl,
                                ),
                              ),
                            ),
                            Align(
                              alignment: _alignmentForPosition(_position),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  _text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: colors[_colorKey] ?? Colors.black,
                                    fontSize: _fontSize,
                                    fontWeight: FontWeight.bold,
                                    shadows: const [Shadow(blurRadius: 2, color: Colors.black26, offset: Offset(1, 1))],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Controls
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Choose product', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButton<ProductModel>(
                          value: _selected,
                          isExpanded: true,
                          items: _products.map((p) => DropdownMenuItem(value: p, child: Text(p.title))).toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _selected = v);
                          },
                        ),
                        const SizedBox(height: 12),

                        const Text('Personalisation text', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: TextEditingController(text: _text),
                          onChanged: (v) => setState(() => _text = v),
                          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter text to print'),
                        ),
                        const SizedBox(height: 12),

                        const Text('Text color', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: colors.keys.map((k) {
                            final c = colors[k]!;
                            final sel = k == _colorKey;
                            return ChoiceChip(label: Text(k, style: TextStyle(color: c == Colors.white ? Colors.black : Colors.white)), selected: sel, selectedColor: c, backgroundColor: c.withOpacity(0.9), onSelected: (_) => setState(() => _colorKey = k));
                          }).toList(),
                        ),
                        const SizedBox(height: 12),

                        const Text('Font size', style: TextStyle(fontWeight: FontWeight.bold)),
                        Slider(value: _fontSize, min: 12, max: 72, divisions: 12, label: '${_fontSize.round()}', onChanged: (v) => setState(() => _fontSize = v)),
                        const SizedBox(height: 8),

                        const Text('Position', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          value: _position,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'Top', child: Text('Top')),
                            DropdownMenuItem(value: 'Center', child: Text('Center')),
                            DropdownMenuItem(value: 'Bottom', child: Text('Bottom')),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _position = v);
                          },
                        ),

                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // create a personalised product entry and add to cart
                            final meta = <String, String>{
                              'personal_text': _text,
                              'personal_color': _colorKey,
                              'personal_font': _fontSize.toString(),
                              'personal_pos': _position,
                              'original_id': _selected.id,
                            };
                            final personalised = ProductModel(
                              id: 'personalise-${DateTime.now().millisecondsSinceEpoch}',
                              title: '${_selected.title} (Personalised)',
                              price: _selected.price,
                              imageUrl: _selected.imageUrl,
                              variants: {
                                ..._selected.variants,
                                '_meta': [jsonEncode(meta)],
                              },
                            );
                            app_cart.Cart.instance.add(personalised, quantity: 1);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added personalised item to cart')));
                            Navigator.pushNamed(context, '/cart');
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                          child: const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Add personalised item to cart')),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Note: This is a demo personalisation preview. For production, integrate with server-side print rendering and payment.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
