import 'package:equatable/equatable.dart';

class NeroUser extends Equatable {
  // 유저 클래스 정의
  final int? userId;
  final int? kakaoId;
  final DateTime? createdAt;
  final String? nickname;
  final String? email;
  final DateTime? birth;  // birth를 DateTime으로 변경
  final String? sex;

  // 생성자
  NeroUser({
    this.userId,
    this.kakaoId,
    this.createdAt,
    this.nickname,
    this.email,
    this.birth,
    this.sex,
  });

  // 빈 상태의 생성자
  NeroUser.empty()
      : userId = 1,
        kakaoId = 1,
        createdAt = DateTime.now(),
        nickname = null,
        email = null,
        birth = null,
        sex = null;

  factory NeroUser.fromJson(Map<String, dynamic> json) {
    return NeroUser(
      userId: json['userId'] ?? 1,
      kakaoId: json['kakaoId'] ?? 1,
      createdAt: DateTime.parse(json['createdAt']),
      nickname: json['nickName'] ?? null,
      email: json['email'] ?? null,
      birth: json['birth'] != null ? DateTime.parse(json['birth']) : null,
      sex: json['sex'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'kakaoId': kakaoId,
      'createdAt': createdAt?.toIso8601String(),
      'nickName': nickname,
      'email': email,
      'birth': birth?.toIso8601String(),
      'sex': sex,
    };
  }

  // User 객체를 복사, 특정 필드만 변경 가능하도록 만드는 메서드
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

  // 객체간 비교 시 어떤 필드 사용할지 결정
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
