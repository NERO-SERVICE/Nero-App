import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/btn.dart';
import 'package:nero_app/develop/login/controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Widget _logoView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Lottie.asset(
            'assets/lottie/nero_splash.json',
            fit: BoxFit.contain,
            repeat: false,
            onLoaded: (composition) {},
          ),
        ),
        Text(
          '당신 곁에 네로',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: AppColors.titleColor,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          'ADHD를 위한\n토탈 케어 플랫폼',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: AppColors.secondaryTextColor,
          ),
          textAlign: TextAlign.center,
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
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: Text(
              '회원가입/로그인',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: AppColors.titleColor,
              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Btn(
            color: const Color(0xffFEE500),
            onTap: () => Get.find<LoginController>().kakaoLogin(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset('assets/images/kakao.svg'),
                ),
                Expanded(
                  child: Center(
                    child: const Text(
                      '카카오 로그인',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        color: Color(0xff000000),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 16),
          Btn(
            color: Colors.white,
            onTap: () => Get.find<LoginController>().appleLogin(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset('assets/images/apple.svg'),
                ),
                Expanded(
                  child: Center(
                    child: const Text(
                      'Apple 로그인',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'LoginPage',
      screenClass: 'LoginPage',
    );
    return Scaffold(
      body: Stack(
        children: [
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
