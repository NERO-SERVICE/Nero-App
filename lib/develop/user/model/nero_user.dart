import 'package:equatable/equatable.dart';

class NeroUser extends Equatable {
  final int? userId;
  final int? kakaoId;
  final DateTime? createdAt;
  final String? nickname;
  final String? email;
  final DateTime? birth;
  final String? sex;

  NeroUser({
    this.userId,
    this.kakaoId,
    this.createdAt,
    this.nickname,
    this.email,
    this.birth,
    this.sex,
  });

  NeroUser.empty()
      : userId = 1,
        kakaoId = 1,
        createdAt = DateTime.now(),
        nickname = null,
        email = null,
        birth = null,
        sex = null;

  factory NeroUser.fromJson(Map<String, dynamic> json) {
    print("Parsing NeroUser from JSON: $json"); // 로깅 추가

    int? parsedUserId;
    int? parsedKakaoId;

    if (json['userId'] != null) {
      if (json['userId'] is int) {
        parsedUserId = json['userId'];
      } else if (json['userId'] is String) {
        parsedUserId = int.tryParse(json['userId']);
      }
    }

    if (json['kakaoId'] != null) {
      if (json['kakaoId'] is int) {
        parsedKakaoId = json['kakaoId'];
      } else if (json['kakaoId'] is String) {
        parsedKakaoId = int.tryParse(json['kakaoId']);
      }
    }

    return NeroUser(
      userId: parsedUserId ?? 1,
      kakaoId: parsedKakaoId ?? 1,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      nickname: json['nickname'],
      email: json['email'],
      birth: json['birth'] != null
          ? DateTime.tryParse(json['birth'].toString())
          : null,
      sex: json['sex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'kakaoId': kakaoId,
      'createdAt': createdAt?.toIso8601String(),
      'nickname': nickname,
      'email': email,
      'birth': birth?.toIso8601String(),
      'sex': sex,
    };
  }

  NeroUser copyWith({
    int? userId,
    int? kakaoId,
    DateTime? createdAt,
    String? nickname,
    String? email,
    DateTime? birth,
    String? sex,
  }) {
    return NeroUser(
      userId: userId ?? this.userId,
      kakaoId: kakaoId ?? this.kakaoId,
      createdAt: createdAt ?? this.createdAt,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      birth: birth ?? this.birth,
      sex: sex ?? this.sex,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        kakaoId,
        createdAt,
        nickname,
        email,
        birth,
        sex,
      ];
}
