import 'package:flutter/material.dart';
import 'package:nero_app/kakao/user/controller/login_controller.dart';
import 'package:provider/provider.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginController = Provider.of<LoginController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
              await loginController.kakaoLogin(token.accessToken);
              if (loginController.user != null) {
                // Navigate to the next screen
                Navigator.pushReplacementNamed(context, '/home'); // Replace '/home' with your next screen's route
              }
            } catch (e) {
              print('Failed to login with Kakao: $e');
            }
          },
          child: Text('Login with Kakao'),
        ),
      ),
    );
  }
}
