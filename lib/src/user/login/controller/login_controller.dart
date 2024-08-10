import 'package:get/get.dart';
import 'package:nero_app/drf/dio_service.dart';
import 'package:nero_app/drf/user/repository/drf_authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repository/authentication_repository.dart';

class LoginController extends GetxController {
  final AuthenticationRepository authenticationRepository;
  final DrfAuthenticationRepository drfAuthenticationRepository;

  LoginController(this.authenticationRepository, this.drfAuthenticationRepository);

  void googleLogin() async {
    await authenticationRepository.signInWithGoogle();
  }

  void kakaoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    print("kakaoLogin 함수 : ${accessToken}");
    if(accessToken == null){
      await drfAuthenticationRepository.signUpWithKakao();
    } else{
      await drfAuthenticationRepository.loginWithKakao();
    }
  }
}
