/*
  File: lib/about_page.dart
  Purpose: About page that displays information about the application/shop, contact details and copyright.
  Notes: Static informational page used for the coursework demo; links to the personalise page for Print Shack.
*/
/*
  文件：lib/about_page.dart
  说明：关于页面（About Page），展示应用/商店信息。
  已实现功能要点：
  - 显示团队或商店简介、联系方式与版权信息。
  - 用于替代早期的 Print Shack 占位菜单项，作为课程演示的静态信息页。
  - 风格与 Home 页保持一致以保证视觉连贯性。
*/
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About us'),
        backgroundColor: const Color(0xFF4d2963),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 28),
            Center(
              child: Text(
                'About us',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.grey[800]),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text('Welcome to the Union Shop!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.8),
                          children: [
                            const TextSpan(text: "We're dedicated to giving you the very best University branded products, with a range of clothing and merchandise available to shop all year round! We even offer an exclusive "),
                            TextSpan(
                              text: 'personalisation service',
                              style: const TextStyle(decoration: TextDecoration.underline, color: Colors.black87),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Navigator.pushNamed(context, '/personalise');
                              },
                            ),
                            const TextSpan(text: '!'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('All online purchases are available for delivery or instore collection!', style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.8)),
                      const SizedBox(height: 12),
                      const Text('We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, please don\'t hesitate to contact us at hello@upsu.net.', style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.8)),
                      const SizedBox(height: 16),
                      const Text('Happy shopping!', style: TextStyle(fontSize: 15, color: Colors.black54)),
                      const SizedBox(height: 16),
                      const Text('The Union Shop & Reception Team', style: TextStyle(fontSize: 15, color: Colors.black54)),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ),

            // Footer (reuse main footer style)
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
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      TextButton(onPressed: () => Navigator.pushNamed(context, '/'), child: const Text('Home')),
                      TextButton(onPressed: () => Navigator.pushNamed(context, '/collections'), child: const Text('Collections')),
                      TextButton(onPressed: () => Navigator.pushNamed(context, '/about'), child: const Text('About us')),
                      TextButton(onPressed: () {}, child: const Text('Privacy')),
                      TextButton(onPressed: () {}, child: const Text('Terms')),
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
}