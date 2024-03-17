import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'access_token_state.g.dart';

/// QiitaAPIのOAuthで取得したアクセストークンの状態を管理する
/// 保存先はよりセキュアなセキュアストレージを使用する
@riverpod
class PlainAccessTokenNotifier extends _$PlainAccessTokenNotifier {
  @override
  Future<String?> build() async {
    /// 初期値はセキュアストレージから呼び出す
    /// 認証前の段階では値がないのでnullの可能性がある
    return await _loadAccessToken();
  }

  // 状態を変更する関数
  Future<void> save(String token) async {
    await _saveAccessToken(token: token);
    state = AsyncData(token);
  }

  /// アクセストークンを削除する
  Future<void> delete() async {
    await _deleteAccessToken();
    state = const AsyncData(null);
  }

  /// アクセストークンキーをセキュアストレージに保存する際のキー
  final _accessTokenKey = 'plainAccessToken';

  /// セキュアストレージをインスタンス化
  final _storage = const FlutterSecureStorage();

  /// 保存されているアクセストークンを呼び出す
  Future<String?> _loadAccessToken() async {
    final accessToken = await _storage.read(key: _accessTokenKey);
    return accessToken;
  }

  /// アクセストークンを保存する
  Future<void> _saveAccessToken({required String token}) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// アクセストークンを削除する
  Future<void> _deleteAccessToken() async {
    _storage.delete(key: _accessTokenKey);
  }
}
