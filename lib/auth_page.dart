/*
  文件：lib/auth_page.dart
  说明：认证页面（Auth Page），提供用户登录与注册界面。
  已实现功能要点：
  - 支持登录与注册模式切换，包括表单验证提示与加载态显示。
  - 使用 `AuthService` 提供的示例认证逻辑进行本地演示（课程用途）。
  - 成功后通过 `Navigator.pushReplacement` 进入 `AccountPage`。
  备注：此页面为示例演示，真实项目应接入安全的后端认证服务与更严格的校验。
*/
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'account_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();
  final _confirmCtl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Sign In' : 'Sign Up'),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(isLogin ? 'Welcome back' : 'Create account', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailCtl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordCtl,
                  decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                  obscureText: true,
                ),
                if (!isLogin) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _confirmCtl,
                    decoration: const InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder()),
                    obscureText: true,
                  ),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() => _loading = true);
                          final email = _emailCtl.text.trim();
                          final pass = _passwordCtl.text;
                          if (email.isEmpty || pass.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter email and password')));
                            setState(() => _loading = false);
                            return;
                          }
                          if (isLogin) {
                            final ok = await AuthService.instance.signIn(email, pass);
                              if (ok) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signed in')));
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AccountPage()));
                              } else {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign in failed')));
                              }
                          } else {
                            final confirm = _confirmCtl.text;
                            if (pass != confirm) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
                              setState(() => _loading = false);
                              return;
                            }
                            final displayName = email.split('@').first;
                            final ok = await AuthService.instance.signUp(email, pass, displayName);
                            if (ok) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created')));
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AccountPage()));
                            } else {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account exists')));
                            }
                          }
                          setState(() => _loading = false);
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                  child: _loading ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text(isLogin ? 'Sign In' : 'Sign Up'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => isLogin = !isLogin),
                  child: Text(isLogin ? 'Don\'t have an account? Sign Up' : 'Already have an account? Sign In'),
                ),
                const SizedBox(height: 24),
                const Text('Or sign in with', textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.login)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.login)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
