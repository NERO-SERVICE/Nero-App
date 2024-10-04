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
        final userInfo = await authenticationRepository.getUserInfoWithTokens(accessToken);
        if (userInfo != null) {
          final needsSignup = userInfo['nickname'] == null || (userInfo['nickname'] as String).isEmpty;
          if (needsSignup) {
            Get.offAllNamed('/signup');
          } else {
            Get.offAllNamed('/home');
          }
        } else {
          Get.offAllNamed('/login');
        }
      } catch (e) {
        Get.offAllNamed('/login');
      }
    } else {
      Get.offAllNamed('/login');
    }
  }

  void kakaoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      await Get.find<AuthenticationController>().handleKakaoLogin();
    } else {
      try {
        await authenticationRepository.signUpWithKakao();
      } catch (e) {
        await authenticationRepository.logout();
      }
    }
  }
}
