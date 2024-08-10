import 'package:get/get.dart';
import 'package:nero_app/drf/user/repository/drf_authentication_repository.dart';
import '../../repository/authentication_repository.dart';

class LoginController extends GetxController {
  final AuthenticationRepository authenticationRepository;
  final DrfAuthenticationRepository drfAuthenticationRepository;

  LoginController(this.authenticationRepository, this.drfAuthenticationRepository);

  void googleLogin() async {
    await authenticationRepository.signInWithGoogle();
  }

  void kakaoLogin() async {
    // final check = drfAuthenticationRepository.getDrfAccessToken();
    await drfAuthenticationRepository.signUpWithKakao();
    // if(check == null){
    //   await drfAuthenticationRepository.signUpWithKakao();
    // } else{
    //   await drfAuthenticationRepository.loginWithKakao();
    // }
  }
}
