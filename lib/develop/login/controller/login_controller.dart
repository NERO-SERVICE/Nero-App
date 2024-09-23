// lib/develop/login/controller/login_controller.dart

import 'package:get/get.dart';
import 'package:nero_app/develop/user/repository/authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../user/controller/authentication_controller.dart';

class LoginController extends GetxController {
  final AuthenticationRepository authenticationRepository;

  LoginController(this.authenticationRepository);

  @override
  void onInit() {
    super.onInit();
    _autoLogin();
  }

  void _autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    final String? refreshToken = prefs.getString('refreshToken');

    if (accessToken != null && refreshToken != null) {
      try {
        final user = await authenticationRepository.fetchAndSaveUserInfo();
        if (user != null) {
          // 유저 정보가 있으면 홈 화면으로 이동
          Get.offAllNamed('/home');
        } else {
          // 유저 정보를 불러오지 못하면 로그인 화면으로 이동
          Get.offAllNamed('/login');
        }
      } catch (e) {
        print("자동 로그인 실패: $e");
        // 로그인 실패 시 로그인 화면으로 이동
        Get.offAllNamed('/login');
      }
    } else {
      // 토큰이 없으면 로그인 화면으로 이동
      Get.offAllNamed('/login');
    }
  }

  void kakaoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    print("kakaoLogin 함수 : $accessToken");
    if (accessToken == null) {
      // accessToken이 없으면 카카오 로그인 시도
      await Get.find<AuthenticationController>().handleKakaoLogin();
    } else {
      // accessToken이 있으면 서버로 로그인 요청
      try {
        await authenticationRepository.signUpWithKakao();
      } catch (e) {
        print("loginWithKakao 에러: $e");
        // 로그인 실패 시 로그아웃 처리
        await authenticationRepository.logout();
      }
    }
  }
}
