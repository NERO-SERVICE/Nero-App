import 'package:flutter/material.dart';
import 'package:nero_app/kakao/user/model/user_model.dart';
import 'package:nero_app/kakao/user/repository/user_repository.dart';

class LoginController extends ChangeNotifier {
  final UserRepository userRepository;
  User? user;

  LoginController({required this.userRepository});

  Future<void> kakaoLogin(String accessToken) async {
    try {
      user = await userRepository.authenticateWithKakao(accessToken);
      notifyListeners();
    } catch (e) {
      print('Failed to login with Kakao: $e');
    }
  }
}
