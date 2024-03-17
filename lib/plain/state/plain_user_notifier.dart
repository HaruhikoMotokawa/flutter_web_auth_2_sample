import 'package:dio/dio.dart';
import 'package:flutter_web_auth_2_sample/entity/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plain_user_notifier.g.dart';
/// QiitaAPIから取得したログイン中のユーザー情報の状態を管理する
/// 取得自体がFutureなので、初期値はローディング
@riverpod
class PlainUserNotifier extends _$PlainUserNotifier {
  @override
  AsyncValue<User> build() {
    return const AsyncValue.loading();
  }

  /// ログイン中のユーザーデータを要求する
  Future<void> fetchUserData(String accessToken) async {
    const host = 'qiita.com';
    const endPoint = '/api/v2/authenticated_user';
    final url = Uri.https(host, endPoint).toString();
    // ユーザー情報を要求する場合にはヘッダーにアクセストークンを含める
    final headers = {'Authorization': 'Bearer $accessToken'};
    try {
      // Dioを使ってhttpsで要求する
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(headers: headers),
      );
      // JSONで扱えるデータの元を取り出す
      final json = response.data;
      // Dartで扱える[User]オブジェクトに変換
      final user = User.fromJson(json);
      // 状態に保存する
      state = AsyncValue.data(user);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
