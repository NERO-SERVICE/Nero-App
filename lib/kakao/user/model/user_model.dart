class User {
  final String username;
  final String nickname;

  User({required this.username, required this.nickname});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      nickname: json['nickname'],
    );
  }
}
