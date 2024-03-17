// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_web_auth_2_sample/plain/state/access_token_state.dart';
import 'package:flutter_web_auth_2_sample/plain/page/plain_home_page.dart';
import 'package:flutter_web_auth_2_sample/plain/page/plain_login_page_controller.dart';
import 'package:flutter_web_auth_2_sample/show_custom_snack_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlainLoginPage extends HookConsumerWidget {
  const PlainLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // アクセストークンの保存状態を監視
    // アクセストークンのある、なしでログイン状態を判定する
    final accessToken = ref.watch(plainAccessTokenNotifierProvider);

    // ロジックを実行するcontrollerをインスタンス化
    final controller = PlainLoginPageController(ref: ref);

    // 画面初期化時に実行する
    // accessTokenの値が変わると再実行される
    useEffect(
      () {
        // 初回の起動かどうかチェックして必要な処理を実行
        controller.checkFirstLunch();
        return null;
      },
      [accessToken],
    );
    // riverpodのAsyncValueの機能を用いてWidgetを作成
    return accessToken.when(
      //
      data: (accessToken) {
        // アクセストークンがない==ログインしていないのでログイン画面を表示
        if (accessToken == null) {
          return _LoginPage(controller);
        } else {
          // アクセストークンがある==ログイン中なのでログイン画面を表示する
          // 最初にログインページを表示した後にホームページに**遷移させる**
          Future.microtask(
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PlainHomePage(),
                  fullscreenDialog: true,
                ),
              );
            },
          );
          return _LoginPage(controller);
        }
      },
      // エラーがあったらとりあえず今回はログイン画面（適切な画面を出す）
      error: (e, _) => _LoginPage(controller),
      // ローディング中はぐるぐるを表示
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

/// ログインページ
class _LoginPage extends StatelessWidget {
  const _LoginPage(this.controller);

  final PlainLoginPageController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PlainLoginPage',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              _logIn(context: context, controller: controller);
            },
            child: const Text('Login')),
      ),
    );
  }

  /// ログインを実行
  void _logIn({
    required BuildContext context,
    required PlainLoginPageController controller,
  }) async {
    try {
      // ログインの細かい処理はコントローラーで定義
      controller.startLogin();
    } catch (e) {
      // 失敗したらスナックバーを出す
      showCustomSnackBar(context, 'ログインに失敗しました');
    }
  }
}
