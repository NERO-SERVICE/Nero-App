import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/kakao/user/controller/signup_controller.dart';
import 'package:nero_app/kakao/user/repository/user_repository.dart';
import 'package:nero_app/kakao/api_service.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signupController = Get.put(
      SignupController(userRepository: UserRepository(apiService: ApiService())),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Center(
        child: ElevatedButton(
          onPressed: signupController.loginWithKakao,
          child: Text('Kakao로 계속하기'),
        ),
      ),
    );
  }
}
