class MypageUserInfo {
  final String nickname;

  MypageUserInfo({required this.nickname});

  factory MypageUserInfo.fromJson(Map<String, dynamic> json) {
    return MypageUserInfo(
      nickname: json['nickname'],
    );
  }
}