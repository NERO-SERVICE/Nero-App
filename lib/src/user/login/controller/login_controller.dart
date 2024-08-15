import 'package:get/get.dart';
import 'package:nero_app/drf/user/repository/drf_authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/authentication_repository.dart';

class LoginController extends GetxController {
  final AuthenticationRepository authenticationRepository;
  final DrfAuthenticationRepository drfAuthenticationRepository;

  LoginController(
      this.authenticationRepository, this.drfAuthenticationRepository);

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
        final user = await drfAuthenticationRepository.fetchAndSaveUserInfo();
        if (user != null) {
          // 유저 정보가 있으면 홈 화면으로 이동
          Get.offAllNamed('/drf/home');
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

  void googleLogin() async {
    await authenticationRepository.signInWithGoogle();
  }

  void kakaoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    print("kakaoLogin 함수 : ${accessToken}");
    if (accessToken == null) {
      await drfAuthenticationRepository.signUpWithKakao();
    } else {
      await drfAuthenticationRepository.loginWithKakao();
    }
  }
}
