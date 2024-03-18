import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_web_auth_2_sample/common_file/entity/user.dart';
import 'package:flutter_web_auth_2_sample/common_file/show_custom_snack_bar.dart';
import 'package:flutter_web_auth_2_sample/plain/page/plain_home_page_controller.dart';
import 'package:flutter_web_auth_2_sample/plain/state/plain_user_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlainHomePage extends HookConsumerWidget {
  const PlainHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // userのstateを監視
    final user = ref.watch(plainUserNotifierProvider);

    // ロジックを実行するcontrollerをインスタンス化
    final controller = PlainHomePageController(ref: ref);

    useEffect(
      () {
        // userデータをAPIから取得
        controller.getUser();
        return null;
      },
      [user],
    );
    return user.when(
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, _) {
        return const Scaffold(
          body: Center(
            child: Text('例外が発生しました'),
          ),
        );
      },
      data: (user) {
        return _PlainHomePage(
          user: user,
          controller: controller,
        );
      },
    );
  }
}

class _PlainHomePage extends StatelessWidget {
  const _PlainHomePage({
    required this.user,
    required this.controller,
  });

  final User user;
  final PlainHomePageController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'PlainHomePage',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Image.network(
                    user.profileImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                leading: const Text(
                  'ユーザー名',
                  style: TextStyle(fontSize: 20),
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              ListTile(
                leading: const Text(
                  '記事投稿数',
                  style: TextStyle(fontSize: 20),
                ),
                title: Text(
                  user.itemsCount.toString(),
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final result = await controller.startLogout();
                    if (result && context.mounted) {
                      showCustomSnackBar(context, 'ログアウトしました😀');
                      Navigator.pop(context);
                    } else if (!result && context.mounted) {
                      showCustomSnackBar(context, 'ログアウトに失敗しました');
                    }
                  },
                  child: const Text('ログアウト')),
            ],
          ),
        ));
  }
}
