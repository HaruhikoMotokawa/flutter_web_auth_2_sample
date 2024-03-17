import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

/// APIとの通信をおこうなためのクラス
class ApiClient {
  final _dio = Dio();

  /// アクセストークンを取得する
  Future<String?> fetchResponseData(
      {required String url, required String responseDataKey}) async {
    // アクセストークンを要求
    final response = await _dio.post(url);
    // レスポンスの中からアクセストークンを取り出す
    final responseData = response.data[responseDataKey];
    return responseData;
  }

  /// ログイン中のユーザーデータを要求する
  Future<dynamic> fetchData(String url,Map<String, dynamic> headers) async {

    // データを要求
    final response = await _dio.get(url, options: Options(headers: headers));
    final data = response.data;

    return data;
  }
}

/// ApiClientクラスのインスタンスを注入するための処理
@Riverpod(keepAlive: true)
ApiClient apiClient(ApiClientRef ref) {
  return ApiClient();
}
