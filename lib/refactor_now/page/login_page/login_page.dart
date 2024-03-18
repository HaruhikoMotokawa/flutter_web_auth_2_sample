import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_web_auth_2_sample/refactor_now/page/home_page/home_page.dart';
import 'package:flutter_web_auth_2_sample/refactor_now/page/login_page/login_page_view_model.dart';
import 'package:flutter_web_auth_2_sample/common_file/show_custom_snack_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LogInPage extends HookConsumerWidget {
  const LogInPage({super.key});

  Future<void> _logIn(BuildContext context, WidgetRef ref) async {
    final viewModel = ref.read(loginPageViewModelProvider.notifier);
    final result = await viewModel.startLogin();
    if (result) {
      if (context.mounted) {
        showCustomSnackBar(context, 'ログインに成功しました😀');
      }
    } else {
      if (context.mounted) {
        showCustomSnackBar(context, 'ログインに失敗しました😢');
      }
    }
  }

  Future<void> _setupPage(
      BuildContext context, WidgetRef ref, bool isLogin) async {
    final viewModel = ref.read(loginPageViewModelProvider.notifier);
    await viewModel.setupLoginCondition();
    if (isLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
            fullscreenDialog: true,
          ),
        )
            .then((isLogin) {
          if (isLogin == false) {
            viewModel.startLogout();
            showCustomSnackBar(context, 'ログアウトしました👋');
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(loginPageViewModelProvider).isLogin;
    useEffect(() {
      _setupPage(context, ref, isLogin);
      return null;
    }, [isLogin]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'LoginPage',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await _logIn(context, ref);
            },
            child: const Text('Login')),
      ),
    );
  }
}
