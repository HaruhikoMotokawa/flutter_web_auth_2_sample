import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2_sample/refactor_now/service/api_client.dart';
import 'package:flutter_web_auth_2_sample/refactor_now/service/auth.dart';
import 'package:flutter_web_auth_2_sample/env.dart';
import 'package:flutter_web_auth_2_sample/refactor_now/service/regular_storage.dart';
import 'package:flutter_web_auth_2_sample/refactor_now/service/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_page_view_model.g.dart';
part 'login_page_view_model.freezed.dart';
/// ログインの状態
/// 今回は一つなのでクラスの状態にしなくてもいいが、ViewModelの
/// 状態とセットにするためにクラスにした
/// つまりグローバルなステートではない
@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isLogin,
  }) = _LoginState;
}

@riverpod
class LoginPageViewModel extends _$LoginPageViewModel {
  @override
  LoginState build() {
    return const LoginState();
  }

  /// ログイン処理
  Future<bool> startLogin() async {
    try {
      final code = await _fetchCode();
      if (code != null) {
        final accessToken = await _fetchAccessToken(code);
        if (accessToken != null) {
          final secureStorage = ref.read(secureStorageProvider);
          secureStorage.saveAccessToken(accessToken: accessToken);
          state = state.copyWith(isLogin: true);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String?> _fetchCode() async {
    final auth = ref.read(authProvider);
    const host = 'qiita.com';
    const authEndPoint = '/api/v2/oauth/authorize';
    const scope = 'read_qiita';
    const state = 'bb17785d811bb1913ef54b0a7657de780defaa2d';
    const callbackUrlScheme = 'fwa2sample';
    final queryParameters = {
      'client_id': Env.clientId,
      'scope': scope,
      'state': state,
    };
    final url = Uri.https(host, authEndPoint, queryParameters).toString();
    try {
      final result = await auth.authenticate(
          url: url, callbackUrlScheme: callbackUrlScheme);
      final code = Uri.parse(result).queryParameters['code'];
      return code;
    } catch (e) {
      switch (e) {
        case PlatformException(code: 'CANCELED'):
          rethrow;
        default:
          rethrow;
      }
    }
  }

  /// アクセストークンを取得する
  Future<String?> _fetchAccessToken(String code) async {
    // アクセストークンを取得するためのurlを作成
    const host = 'qiita.com';
    const tokenEndPoint = '/api/v2/access_tokens';
    final queryParameters = {
      'client_id': Env.clientId,
      'client_secret': Env.clientSecret,
      'code': code,
    };
    // urlここで完成
    final url = Uri.https(host, tokenEndPoint, queryParameters).toString();
    // レスポンスの中から取り出すデータをtokenにする
    const responseDataKey = 'token';
    // ApiClientのインスタンス取得
    final apiClient = ref.read(apiClientProvider);
    // アクセストークンを要求
    final accessToken = await apiClient.fetchResponseData(
        url: url, responseDataKey: responseDataKey);
    return accessToken;
  }

  Future<void> setupLoginCondition() async {
    await _checkFirstLunch();
    await _checkIsLogin();
  }

  /// アプリがインストール後に初めて起動しているかチェックする
  ///
  /// もしも初めての場合は念の為セキュアストレージに保存されている
  /// アクセストークンを削除して、リセットする
  /// この処理はiOSのキーチェーン向けの処理となる
  Future<void> _checkFirstLunch() async {
    final regularStorage = ref.read(regularStorageProvider);
    final isFirstLunch = await regularStorage.getIsFirstLunch();
    if (isFirstLunch == null || isFirstLunch) {
      final secureStorage = ref.read(secureStorageProvider);
      secureStorage.deleteAccessToken();
      regularStorage.updateIsFirstLunch(false);
    }
  }

  Future<void> _checkIsLogin() async {
    final secureStorage = ref.read(secureStorageProvider);
    final isLogin = await secureStorage.loadAccessToken();
    if (isLogin != null) {
      state = state.copyWith(isLogin: true);
    } else {
      state = state.copyWith(isLogin: false);
    }
  }

  /// ログアウトの処理
  Future<void> startLogout() async {
    final secureStorage = ref.read(secureStorageProvider);
    secureStorage.deleteAccessToken();
    state = state.copyWith(isLogin: false);
  }
}
