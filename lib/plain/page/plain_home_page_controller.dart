import 'package:dio/dio.dart';
import 'package:flutter_web_auth_2_sample/plain/state/access_token_state.dart';
import 'package:flutter_web_auth_2_sample/plain/state/plain_user_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// PlainHomePageで実行するロジックを集約したクラス
class PlainHomePageController {
  const PlainHomePageController({
    required this.ref,
  });

  final WidgetRef ref;

  /// ユーザー情報を取得する
  Future<void> getUser() async {
    // アクセストークンを取り出す
    final accessToken = ref.read(plainAccessTokenNotifierProvider).value;
    if (accessToken != null) {
      // アクセストークンを使ってユーザー情報を取り出す
      ref.read(plainUserNotifierProvider.notifier).fetchUserData(accessToken);
    }
  }

  /// ログアウトを行い、完了をbool値で返却して知らせる
  ///
  /// ログアウト==アクセストークンの削除だが、サーバー側とローカルデバイス側の両方の削除が必要
  Future<bool> startLogout() async {
    try {
      // 現在保存されているアクセストークンを呼び出す
      final accessToken = ref.read(plainAccessTokenNotifierProvider).value;
      if (accessToken != null) {
        const host = 'qiita.com';
        const tokenEndPoint = '/api/v2/access_tokens';
        // エンドポイントに削除したいトークンの値を'/'を挟んで追加する
        final url = Uri.https(
          host,
          '$tokenEndPoint/$accessToken',
        ).toString();
        final dio = Dio();
        // サーバー側にアクセストークンの削除を要求
        final response = await dio.delete(url);
        // 削除が受理されるとレスポンスで'204'というコードが返却される
        if (response.statusCode == 204) {
          // サーバー側でのアクセストークン削除の実行を確認したのちに
          // ローカルでのアクセストークンの削除を実行する
          await ref.read(plainAccessTokenNotifierProvider.notifier).delete();
          // 全ての削除が完了したら'true'を返す
          return true;
        } else {
          // 204以外のコードが返却された、即ちサーバー側で削除が失敗したので`false`を返す
          return false;
        }
      } else {
        // アクセストークンが`null`つまり削除処理ができてないので`false`を返す
        return false;
      }
    } catch (e) {
      // 何かしらのエラーで処理が完全に終わってないので`false`を返す
      return false;
    }
  }
}
