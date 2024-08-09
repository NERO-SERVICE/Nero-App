import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:nero_app/drf/api_service.dart';
import 'package:nero_app/drf/user/model/drf_user_model.dart';

class DrfAuthenticationRepository extends GetxService {
  final ApiService apiService;
  var user = Rxn<DrfUserModel>();
  var isLoading = false.obs;

  DrfAuthenticationRepository({required this.apiService});

  Future<bool> checkUserExists(String accessToken) async {
    print("----checkUserExists----");
    final response = await apiService.sendTokenToServer(accessToken);
    if (response['user'] != null) {
      user.value = DrfUserModel.fromJson(response['user']);
      return true;
    } else {
      return false;
    }
  }

  Future<void> signUpWithKakao(String accessToken) async {
    print("----signUpWithKakao----");
    final response = await apiService.signUpWithKakao(accessToken);
    user.value = DrfUserModel.fromJson(response);
  }

  Future<void> signInWithKakao() async {
    print("----signInWithKakao----");
    isLoading.value = true;
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      final responseData = await apiService.sendTokenToServer(token.accessToken);
      user.value = DrfUserModel.fromJson(responseData);
      print(user.value);

      // Home으로 이동하면서 user ID를 전달합니다.
      Get.toNamed('/drf/home', arguments: {'uid': user.value?.uid});
      print("유저 id ${user.value?.uid}");
    } catch (e) {
      print('Kakao login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    print("----logout----");
    user.value = null;
  }
}