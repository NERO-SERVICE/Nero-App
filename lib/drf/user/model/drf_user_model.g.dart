// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drf_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrfUserModel _$DrfUserModelFromJson(Map<String, dynamic> json) => DrfUserModel(
      uid: json['uid'] as String?,
      nickname: json['nickname'] as String?,
      kakaoId: json['kakaoId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      temperature: (json['temperature'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DrfUserModelToJson(DrfUserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'nickname': instance.nickname,
      'kakaoId': instance.kakaoId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'temperature': instance.temperature,
    };
