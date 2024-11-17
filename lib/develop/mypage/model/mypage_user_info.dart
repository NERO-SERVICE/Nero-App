class MypageUserInfo {
  final String nickname;
  final String profileImageUrl;

  MypageUserInfo({required this.nickname, required this.profileImageUrl});

  factory MypageUserInfo.fromJson(Map<String, dynamic> json) {
    return MypageUserInfo(
      nickname: json['nickname'] ?? '',
      profileImageUrl: json['profile_image']?['image_url'] ?? '',
    );
  }
}
