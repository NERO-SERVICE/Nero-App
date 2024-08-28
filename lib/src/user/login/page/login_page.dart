import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/components/btn.dart';
import 'package:nero_app/src/user/login/controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Widget _logoView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 35),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Container(
            height: 136,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset(
                'assets/images/nero_init.png',
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 200,
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
          '토탈 케어 플랫폼 \n 네로를 시작하세요',
          align: TextAlign.center,
          size: 18,
          color: Colors.white.withOpacity(0.6),
        ),
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
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
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
          const SizedBox(height: 10),
          Btn(
            color: Color(0xffFEE500),
            onTap: () => Get.find<LoginController>().kakaoLogin(),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset('assets/images/kakao.svg')
                ),
                const SizedBox(
                  width: 40,
                ),
                const AppFont(
                  '카카오로 계속하기',
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _logoView(),
              _textDivider(),
              _snsLoginBtn(),
            ],
          ),
        ],
      ),
    );
  }
}
