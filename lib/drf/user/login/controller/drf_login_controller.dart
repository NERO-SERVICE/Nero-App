import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:nero_app/drf/api_service.dart';
import 'package:nero_app/drf/user/repository/drf_authentication_repository.dart';

// class DrfLoginController extends GetxController {
//   final DrfAuthenticationRepository authRepository;
//   final ApiService apiService;
//
//   var isLoading = false.obs;
//
//   DrfLoginController(this.authRepository, this.apiService);
//
//   Future<void> loginWithKakao() async {
//     if (isLoading.value) return;
//     isLoading.value = true;
//
//     try {
//       OAuthToken token;
//       if (await isKakaoTalkInstalled()) {
//         token = await UserApi.instance.loginWithKakaoTalk();
//       } else {
//         token = await UserApi.instance.loginWithKakaoAccount();
//       }
//
//       var userExists = await authRepository.checkUserExists(token.accessToken);
//
//       if (userExists) {
//         Get.toNamed('/drf/home');
//       } else {
//         Get.toNamed('/drf/signup', arguments: token.accessToken);
//       }
//     } catch (e) {
//       print('Kakao login failed: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


class DrfLoginController extends GetxController {
  final DrfAuthenticationRepository drfAuthenticationRepository;

  DrfLoginController(this.drfAuthenticationRepository);

  void kakaoLogin() async {
    await drfAuthenticationRepository.signInWithKakao();
  }
}