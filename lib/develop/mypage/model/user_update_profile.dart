import 'package:intl/intl.dart';

class UserUpdateProfile {
  final String nickname;
  final String email;
  final String birth;
  final String sex;

  UserUpdateProfile({
    required this.nickname,
    required this.email,
    required this.birth,
    required this.sex,
  });

  factory UserUpdateProfile.fromJson(Map<String, dynamic> json) {
    String formattedBirth = '';
    if (json['birth'] != null && json['birth'].isNotEmpty) {
      try {
        DateTime birthDate = DateTime.parse(json['birth']);
        formattedBirth = DateFormat('yyMMdd').format(birthDate);
      } catch (e) {
        print("Failed to parse birth date: $e");
      }
    }

    return UserUpdateProfile(
      nickname: json['nickname'] ?? '',
      email: json['email'] ?? '',
      birth: formattedBirth,
      sex: json['sex'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    String formattedBirth = birth;
    if (birth.length == 6) {
      try {
        String prefix = int.parse(birth.substring(0, 2)) > 21 ? '19' : '20';
        String formatted = '$prefix${birth.substring(0, 2)}-${birth.substring(2, 4)}-${birth.substring(4, 6)}';
        DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(formatted);
        formattedBirth = DateFormat('yyyy-MM-dd').format(parsedDate);
      } catch (e) {
        print("Failed to format birth date for server: $e");
      }
    }

    return {
      'nickname': nickname,
      'email': email,
      'birth': formattedBirth,
      'sex': sex,
    };
  }
}
