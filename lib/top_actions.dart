/*
  File: lib/top_actions.dart
  Purpose: Top actions widget for the app bar. Shows search, account and cart icons with a live cart badge.
  Notes: Encapsulates header actions to keep UI consistent across pages and handle navigation callbacks.
*/
/*
  文件：lib/top_actions.dart
  说明：应用顶部操作按钮组件（Top Actions）。
  已实现功能要点：
  - 在 AppBar 上显示搜索、账户和购物车图标。
  - 购物车图标显示实时数量徽章（基于 ValueListenable/Cart 状态）。
  - 提供统一的回调接口用于页面级导航或弹窗触发。
  备注：该文件封装头部操作，便于在各页面重用与样式统一。
*/
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'cart.dart' as app_cart;
import 'models.dart';

class TopActions extends StatelessWidget {
  final double iconSize;

  const TopActions({Key? key, this.iconSize = 20}) : super(key: key);

  Future<void> _showSearchAndNavigate(BuildContext context) async {
    final ctl = TextEditingController();
    final q = await showDialog<String>(context: context, builder: (c) => AlertDialog(
      title: const Text('Search products'),
      content: TextField(controller: ctl, decoration: const InputDecoration(hintText: 'Search...'), autofocus: true, onSubmitted: (v) => Navigator.of(c).pop(v)),
      actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')), ElevatedButton(onPressed: () => Navigator.pop(c, ctl.text.trim()), child: const Text('Search'))],
    ));
    if (q != null && q.trim().isNotEmpty) Navigator.pushNamed(context, '/search', arguments: q.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(icon: Icon(Icons.search, size: iconSize, color: Colors.grey), onPressed: () => _showSearchAndNavigate(context)),
      IconButton(icon: Icon(Icons.person_outline, size: iconSize, color: Colors.grey), onPressed: () {
        final u = AuthService.instance.currentUser.value;
        if (u != null) {
          Navigator.pushNamed(context, '/account');
        } else {
          Navigator.pushNamed(context, '/auth');
        }
      }),
      ValueListenableBuilder<List<CartItem>>(
        valueListenable: app_cart.Cart.instance.items,
        builder: (context, list, _) {
          final count = list.fold<int>(0, (s, e) => s + e.quantity);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(icon: Icon(Icons.shopping_bag_outlined, size: iconSize, color: Colors.grey), onPressed: () => Navigator.pushNamed(context, '/cart')),
              if (count > 0)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Center(child: Text(count > 99 ? '99+' : '$count', style: const TextStyle(color: Colors.white, fontSize: 10))),
                  ),
                ),
            ],
          );
        },
      ),
    ]);
  }
}
