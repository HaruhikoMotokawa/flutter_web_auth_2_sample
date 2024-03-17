import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';

/// 認証を行うクラス
class Auth {
  /// 認証を行うメソッドで認可コードが返却される
  Future<String> authenticate(
      {required String url, required String callbackUrlScheme}) async {
    final code = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: callbackUrlScheme,
        options: const FlutterWebAuth2Options(preferEphemeral: true));
    return code;
  }
}

/// Authクラスのインスタンスを注入するための処理
@Riverpod(keepAlive: true)
Auth auth(AuthRef ref) {
  return Auth();
}
