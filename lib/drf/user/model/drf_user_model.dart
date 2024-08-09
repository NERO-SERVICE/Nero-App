// import 'package:json_annotation/json_annotation.dart';
//
// part 'drf_user_model.g.dart';
//
// @JsonSerializable()
// class DrfUserModel {
//   final String uid;
//   final String username;
//   final String nickname;
//
//   DrfUserModel({required this.uid, required this.username, required this.nickname});
//
//   factory DrfUserModel.fromJson(Map<String, dynamic> json) {
//     return DrfUserModel(
//       uid: json['id'].toString(),
//       username: json['username'],
//       nickname: json['nickname'],
//     );
//   }
// }

import 'package:json_annotation/json_annotation.dart';
import 'dart:math';

import 'package:equatable/equatable.dart';

part 'drf_user_model.g.dart';

@JsonSerializable()
class DrfUserModel extends Equatable {
  final String? uid;
  final String? nickname;
  final String? kakaoId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? temperature;

  const DrfUserModel({
    this.uid,
    this.nickname,
    this.kakaoId,
    this.createdAt,
    this.updatedAt,
    this.temperature,
  });

  factory DrfUserModel.fromJson(Map<String, dynamic> json) =>
      _$DrfUserModelFromJson(json);

  factory DrfUserModel.create(String name, String uid, String kakaoId) {
    return DrfUserModel(
      nickname: name,
      uid: uid,
      kakaoId: kakaoId,
      temperature: Random().nextInt(100) + 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _$DrfUserModelToJson(this);

  @override
  List<Object?> get props =>
      [
        uid,
        nickname,
        kakaoId,
        temperature,
        createdAt,
        updatedAt,
      ];
}
