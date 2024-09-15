import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/user/enum/authentication_status.dart';
import 'package:nero_app/develop/user/model/nero_user.dart';
import 'package:nero_app/develop/user/repository/authentication_repository.dart';
import 'package:nero_app/develop/user/repository/user_repository.dart';

class AuthenticationController extends GetxController {
  final AuthenticationRepository kakaoAuthRepo;
  final UserRepository kakaoUserRepo;

  AuthenticationController(
      this.kakaoAuthRepo,
      this.kakaoUserRepo,
      );

  Rx<AuthenticationStatus> status = AuthenticationStatus.init.obs;
  Rx<NeroUser> userModel = NeroUser().obs;
  RxBool isUsingKakaoAuth = true.obs;

  // authCheck 수정
  authCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      // accessToken이 있으면 회원가입 페이지로 이동
      status(AuthenticationStatus.unAuthenticated);
      Get.offNamed('/signup');
    } else if (isUsingKakaoAuth.value) {
      var kakaoUser = kakaoAuthRepo.user.value;
      if (kakaoUser != null) {
        _userStateChangedEvent(kakaoUser);
      } else {
        final user = await kakaoAuthRepo.fetchAndSaveUserInfo();
        if (user != null) {
          _userStateChangedEvent(user);
        } else {
          status(AuthenticationStatus.unknown);
        }
      }
    }
  }

  void reload() {
    if (isUsingKakaoAuth.value) {
      _userStateChangedEvent(userModel.value);
    }
  }

  void _userStateChangedEvent(NeroUser? user) async {
    if (user == null) {
      status(AuthenticationStatus.unknown);
    } else {
      var result = await kakaoUserRepo.findUserOne(user.userId!);
      if (result == null) {
        NeroUser();
        status(AuthenticationStatus.unAuthenticated);
        Get.toNamed('/signup');  // 회원가입 페이지로 이동
      } else {
        status(AuthenticationStatus.authentication);
        NeroUser();
        Get.toNamed('/drf/home');
      }
    }
  }

  void logout() async {
    if (isUsingKakaoAuth.value) {
      await kakaoAuthRepo.logout();
      userModel.value = NeroUser();
    }
    status(AuthenticationStatus.unknown);
  }
}
