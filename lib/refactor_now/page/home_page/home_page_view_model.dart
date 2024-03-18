import 'package:flutter_web_auth_2_sample/common_file/entity/user.dart';
import 'package:flutter_web_auth_2_sample/refactor_now/service/api_client.dart';
import 'package:flutter_web_auth_2_sample/refactor_now/service/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_view_model.g.dart';
part 'home_page_view_model.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(AsyncValue.loading()) AsyncValue<User> user,
  }) = _HomeState;
}

@riverpod
class HomePageViewModel extends _$HomePageViewModel {
  @override
  HomeState build() {
    return const HomeState();
  }

  /// ログイン中のユーザーデータを要求する
  Future<void> getUserData() async {
    const host = 'qiita.com';
    const endPoint = '/api/v2/authenticated_user';
    final url = Uri.https(host, endPoint).toString();
    final secureStorage = ref.read(secureStorageProvider);
    final accessToken = await secureStorage.loadAccessToken();
    final headers = {'Authorization': 'Bearer $accessToken'};
    final apiClient = ref.read(apiClientProvider);
    try {
      final json = await apiClient.fetchData(url, headers);
      final user = User.fromJson(json);
      state = state.copyWith(user: AsyncValue.data(user));
    } catch (e, s) {
      state = state.copyWith(user: AsyncValue.error(e, s));
    }
  }
}
