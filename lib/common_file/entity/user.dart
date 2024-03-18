// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.g.dart';
part 'user.freezed.dart';

/// QiitaAPIから取得したユーザー情報のエンティティ
@freezed
class User with _$User {
  const factory User({
    // nameはそのままでOK
    required String name,
    // JSONは基本スネークキャメルケース、Dartはローワーキャメルケース
    // @JsonKey(name: 'items_count')でしてしたものをitemsCountとして置き換えてくれる
    // 但し、リントにはなぜか怒られるので１行目の // ignore_for_file: invalid_annotation_target
    // をつけておく
    @JsonKey(name: 'items_count') required int itemsCount,
    @JsonKey(name: 'profile_image_url') required String profileImageUrl,
  }) = _User;

  // JSON変換用のファクトリーメソッド
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
