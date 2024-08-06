import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:nero_app/kakao/user/repository/user_repository.dart';

class SignupController extends GetxController {
  final UserRepository userRepository;
  var isLoading = false.obs;

  SignupController({required this.userRepository});

  Future<void> loginWithKakao() async {
    if (isLoading.value) return;  // 중복 요청 방지
    isLoading.value = true;

    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
        print('Received Kakao OAuth token: ${token.accessToken}');
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
        print('Received Kakao OAuth token via browser: ${token.accessToken}');
      }

      var user = await userRepository.authenticateWithKakao(token.accessToken);
      // 로그인 성공 후 MyPage로 이동
      Get.toNamed('/kakaomypage', arguments: user);
    } catch (e) {
      print('Kakao login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
