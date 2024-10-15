import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import 'package:nero_app/develop/user/enum/authentication_status.dart';
import 'package:nero_app/develop/user/exceptions/user_not_found_exception.dart';
import 'package:nero_app/develop/user/model/nero_user.dart';
import 'package:nero_app/develop/user/repository/authentication_repository.dart';
import 'package:nero_app/develop/user/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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


  Future<void> authCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      try {
        var userInfo = await kakaoAuthRepo.getUserInfoWithTokens(accessToken);
        if (userInfo != null) {
          var user = NeroUser.fromJson(userInfo);
          _userStateChangedEvent(user);
        } else {
          status(AuthenticationStatus.unknown);
          Future.microtask(() => Get.offNamed('/login'));
        }
      } on UserNotFoundException catch (e) {
        await kakaoAuthRepo.logout();
      } catch (e) {
        status(AuthenticationStatus.unknown);
        Future.microtask(() => Get.offNamed('/login'));
      }
    } else if (isUsingKakaoAuth.value) {
      var kakaoUser = kakaoAuthRepo.user.value;
      if (kakaoUser != null) {
        _userStateChangedEvent(kakaoUser);
      } else {
        try {
          final user = await kakaoAuthRepo.fetchAndSaveUserInfo();
          if (user != null) {
            _userStateChangedEvent(user);
          } else {
            status(AuthenticationStatus.unknown);
            Future.microtask(() => Get.offNamed('/login'));
          }
        } on UserNotFoundException catch (e) {
          await kakaoAuthRepo.logout();
        } catch (e) {
          status(AuthenticationStatus.unknown);
          Future.microtask(() => Get.offNamed('/login'));
        }
      }
    } else {
      status(AuthenticationStatus.unknown);
      Future.microtask(() => Get.offNamed('/login'));
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
        status(AuthenticationStatus.unAuthenticated);
        Future.microtask(() => Get.toNamed('/signup'));
      } else {
        if (result.nickname == null || result.nickname!.isEmpty) {
          status(AuthenticationStatus.unAuthenticated);
          Future.microtask(() => Get.toNamed('/signup'));
        } else {
          status(AuthenticationStatus.authentication);
          userModel.value = result;
          Future.microtask(() => Get.toNamed('/home'));
        }
      }
    }
  }


  Future<void> logout() async {
    await kakaoAuthRepo.logout();
    status(AuthenticationStatus.unknown);
  }

  Future<void> deleteAccount() async {
    try {
      final success = await kakaoAuthRepo.deleteAccount();
      if (success) {
        Get.offAllNamed('/login');
        CustomSnackbar.show(
          context: Get.context!,
          message: '회원 탈퇴가 완료되었습니다.',
          isSuccess: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context: Get.context!,
        message: '회원 탈퇴를 실패했습니다.',
        isSuccess: false,
      );
    }
  }


  Future<void> handleKakaoLogin() async {
    try {
      final response = await kakaoAuthRepo.signUpWithKakao();
      bool needsSignup = response['needsSignup'] ?? false;

      if (needsSignup) {
        Get.offNamed('/signup');
      } else {
        Get.offNamed('/home');
      }
    } catch (e) {
      Get.offNamed('/login');
    }
  }

  Future<void> handleAppleLogin() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // 애플 로그인에 성공한 경우 토큰을 서버로 보내어 인증 처리
      final signUpResponse = await kakaoAuthRepo.signUpWithApple(appleCredential);

      bool needsSignup = signUpResponse['needsSignup'] ?? false;

      if (needsSignup) {
        Get.offNamed('/signup');
      } else {
        Get.offNamed('/home');
      }
    } catch (e) {
      print('Apple 로그인 실패: $e');
      Get.offNamed('/login');
    }
  }
}
