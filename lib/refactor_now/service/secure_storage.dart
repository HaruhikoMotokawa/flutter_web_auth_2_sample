import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  /// キー
  final _accessTokenKey = 'accessToken';

  /// 初回起動時は削除しないと履歴がダブる（前回インストールした方で読まれてしまう）
  /// アクセストークンを保存するメソッド
  Future<void> saveAccessToken({required String accessToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
  }

  /// 保存されているアクセストークンキーを呼び出す
  Future<String?> loadAccessToken() async {
    final accessToken = await _storage.read(key: _accessTokenKey);
    return accessToken;
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }
}

@Riverpod(keepAlive: true)
SecureStorage secureStorage(SecureStorageRef ref) {
  return SecureStorage();
}
