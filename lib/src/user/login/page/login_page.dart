import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/src/common/components/btn.dart';

import '../../../common/components/app_font.dart';
import '../controller/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  Widget _logoView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 99,
          height: 116,
          child: Image.asset(
            'assets/images/nero_icon.png',
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        const AppFont(
          '당신 곁의 네로',
          fontWeight: FontWeight.bold,
          size: 20,
        ),
        const SizedBox(
          height: 40,
        ),
        AppFont(
          '중고 거래부터 동네 정보까지.\n지금 내 동네를 선택하고 시작해보세요',
          align: TextAlign.center,
          size: 18,
          color: Colors.white.withOpacity(0.6),
        )
      ],
    );
  }

  Widget _textDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 80.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
            child: AppFont(
              '회원가입/로그인',
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _snsLoginBtn() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: Column(
          children: [
            Btn(
              color: Colors.white,
              onTap: controller.googleLogin,
              child: Row(
                children: [
                  Image.asset('assets/images/google.png'),
                  const SizedBox(
                    width: 30,
                  ),
                  const AppFont(
                    'Google로 계속하기',
                    color: Colors.black,
                  )
                ],
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _logoView(),
          _textDivider(),
          _snsLoginBtn(),
        ],
      ),
    );
  }
}
