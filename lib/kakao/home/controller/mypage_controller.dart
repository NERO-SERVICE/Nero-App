import 'package:get/get.dart';
import 'package:nero_app/kakao/user/repository/user_repository.dart';
import 'package:nero_app/kakao/user/model/user_model.dart';

class MyPageController extends GetxController {
  final UserRepository userRepository;
  var user = Rxn<User>();
  var isLoading = false.obs;

  MyPageController({required this.userRepository});

  Future<void> loadUser() async {
    isLoading.value = true;
    try {
      // 실제로는 사용자 ID나 토큰을 사용하여 서버에서 사용자 정보를 가져옵니다.
      // 여기서는 임시로 예제 사용자 정보를 설정합니다.
      var fetchedUser = await userRepository.getUserInfo(); // 사용자 정보를 가져오는 메서드
      user.value = fetchedUser;
    } catch (e) {
      print('Failed to load user info: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
