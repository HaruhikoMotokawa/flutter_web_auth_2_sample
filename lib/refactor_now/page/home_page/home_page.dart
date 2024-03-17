import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_web_auth_2_sample/entity/user.dart';
import 'package:flutter_web_auth_2_sample/refactor_now/page/home_page/home_page_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // viewModelのuserのstateだけ監視
    final user =
        ref.watch(homePageViewModelProvider.select((state) => state.user));
    useEffect(() {
      // userデータをAPIから取得
      ref.read(homePageViewModelProvider.notifier).getUserData();
      return null;
    }, [homePageViewModelProvider.notifier]);
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
        return _HomePage(user: user);
      },
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({required this.user});

  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'ログイン成功',
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
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('ログアウト')),
            ],
          ),
        ));
  }
}
