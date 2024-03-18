import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2_sample/refactor_now/page/login_page/login_page.dart';
import 'package:flutter_web_auth_2_sample/plain/page/plain_login_page.dart';

class EntrancePage extends StatelessWidget {
  const EntrancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrance'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const PlainLoginPage();
                    },
                  ),
                );
              },
              child: const Text('無印ログインページ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LogInPage();
                    },
                  ),
                );
              },
              child: const Text('リファクタ中'),
            ),
          ],
        ),
      ),
    );
  }
}
