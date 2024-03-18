import 'package:dio/dio.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter_web_auth_2_sample/common_file/env.dart';
import 'package:flutter_web_auth_2_sample/plain/state/access_token_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PlainLoginPageで実行するロジックを集約したクラス
class PlainLoginPageController {
  const PlainLoginPageController({
    required this.ref,
  });

  /// ホスト
  final _host = 'qiita.com';

  /// 状態に関する処理も書くのでrefをもらっておく
  final WidgetRef ref;

  /// refからnotifierを持っておく
  PlainAccessTokenNotifier get accessTokenNotifier =>
      ref.read(plainAccessTokenNotifierProvider.notifier);

  /// ログイン処理
  ///
  /// 1.認証して認可コードを取得する
  /// 2.認可コードを使ってアクセストークンを取得
  /// 3.アクセストークンをデバイスに保存する
  Future<void> startLogin() async {
    // 認証を行って認可コードを取得する
    final code = await _fetchCode();
    if (code != null) {
      // 認証コードを使ってアクセストークンを取得する
      final accessToken = await _fetchAccessToken(code);
      if (accessToken != null && accessToken.isNotEmpty) {
        // アクセストークンを保存する
        await accessTokenNotifier.save(accessToken);
      }
    }
  }

  /// 認証を行い認可コードを取得する
  Future<String?> _fetchCode() async {
    const authEndPoint = '/api/v2/oauth/authorize';
    const scope = 'read_qiita';
    const state = 'bb17785d811bb1913ef54b0a7657de780defaa2d';
    // Uri.httpsメソッドでそれぞれの構成要素を一つにまとめてくれる
    // 但し、そのままだと使えないので最後に`.toString()`で文字列に変換しておく
    final url = Uri.https(_host, authEndPoint, {
      'client_id': Env.clientId,
      'scope': scope,
      'state': state,
    }).toString();
    try {
      // FlutterWebAuth2を使って認証を行う
      final result = await FlutterWebAuth2.authenticate(
        // 認証を行う問い合わせ先を指定
        url: url,
        // あらかじめ登録した認証が終わったら認可コードを返却する先（このアプリ）の名称を指定
        callbackUrlScheme: 'fwa2sample',
        // ここをtrueにしておくと、iOSだと処理を開始した時の内部ブラウザに移動する時の
        // 確認のダイアログの表示が省略される
        options: const FlutterWebAuth2Options(preferEphemeral: true),
      );
      // 認可コードを'code'というパラメータで入っているので、それを使って取り出す
      final code = Uri.parse(result).queryParameters['code'];
      // 取り出したコードを返却する
      return code;
    } catch (e) {
      rethrow;
    }
  }

  /// アクセストークンを取得する
  Future<String?> _fetchAccessToken(String code) async {
    const tokenEndPoint = '/api/v2/access_tokens';
    // ドキュメントにある必要な情報を入れてurlを作成
    final url = Uri.https(_host, tokenEndPoint, {
      // クライアントIDとクラアントシークレットはそれぞれ登録したものを代入してください
      'client_id': Env.clientId,
      'client_secret': Env.clientSecret,
      'code': code,
    }).toString();
    // Dioでhttpsの通信を行う
    final dio = Dio();
    // アクセストークンを要求
    final response = await dio.post(url);
    // レスポンスの中からアクセストークンを取り出す
    final accessToken = response.data['token'];
    // アクセストークンを返却
    return accessToken;
  }

  /// このアプリがインストール後最初の起動であるかどうかを確認する
  ///
  /// iOSの場合はFlutterSecureStorageはキーチェーンに保存される。
  /// 今回でいうアクセストークンを保存するが、キーチェーンはアプリがアンインストールされても
  /// そのままデータが残ってしまう。
  /// 再度アプリを再インストールした場合でも以前のアクセストークンを使用できてしまうのを防ぐために、
  /// SharedPreferences（iOSではUserDefault）に初回起動フラグを保存する。
  /// そのフラグによって例えば初めての起動の場合は念の為、アクセストークンキーの保存があるなしに
  /// かかわらず一旦削除する処理を入れている
  Future<void> checkFirstLunch() async {
    final prefs = await SharedPreferences.getInstance();
    const isFirstLunchKey = 'plain_is_first_lunch';
    // 初めての起動かどうかフラグを取得
    final isFirstLunch = prefs.getBool(isFirstLunchKey);
    // もしもフラグがない、またはtrueだった場合は（つまり初めての起動）
    if (isFirstLunch == null || isFirstLunch) {
      // アクセストークンを削除
      await accessTokenNotifier.delete();
      // 初回起動フラグをfalseで保存
      prefs.setBool(isFirstLunchKey, false);
    }
  }
}
