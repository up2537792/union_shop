import 'package:flutter/material.dart';
import 'auth_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    AuthService.instance.currentUser.addListener(_onUser);
  }

  void _onUser() => setState(() {});

  @override
  void dispose() {
    AuthService.instance.currentUser.removeListener(_onUser);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser.value;
    return Scaffold(
      appBar: AppBar(title: const Text('Account'), backgroundColor: const Color(0xFF4d2963)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: user == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Not signed in', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/auth'), child: const Text('Sign In')),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(user.displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                      TextButton(
                        onPressed: () async {
                          final ctl = TextEditingController(text: user.displayName);
                          final res = await showDialog<String>(context: context, builder: (c) => AlertDialog(
                            title: const Text('Edit display name'),
                            content: TextField(controller: ctl, decoration: const InputDecoration(labelText: 'Display name')),
                            actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')), ElevatedButton(onPressed: () => Navigator.pop(c, ctl.text.trim()), child: const Text('Save'))],
                          ));
                          if (res != null && res.isNotEmpty) {
                            await AuthService.instance.updateDisplayName(user.id, res);
                            if (!mounted) return;
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Display name updated')));
                          }
                        },
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(user.email),
                  const SizedBox(height: 20),
                  const Text('Order history', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Text('No orders yet (placeholder)'),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                    onPressed: () async {
                      await AuthService.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
      ),
    );
  }
}
