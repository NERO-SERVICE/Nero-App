import 'package:get/get.dart';
import 'package:nero_app/develop/user/enum/authentication_status.dart';
import 'package:nero_app/develop/user/exceptions/user_not_found_exception.dart';
import 'package:nero_app/develop/user/model/nero_user.dart';
import 'package:nero_app/develop/user/repository/authentication_repository.dart';
import 'package:nero_app/develop/user/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<void> authCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      // accessToken이 있으면 서버로 유저 정보 요청
      try {
        var userInfo = await kakaoAuthRepo.getUserInfoWithTokens(accessToken);
        if (userInfo != null) {
          var user = NeroUser.fromJson(userInfo);
          _userStateChangedEvent(user);
        } else {
          // 유저 정보 가져오기 실패 시 로그인 페이지로 이동
          status(AuthenticationStatus.unknown);
          Future.microtask(() => Get.offNamed('/login'));
        }
      } on UserNotFoundException catch (e) {
        print("사용자가 서버에 존재하지 않습니다: $e");
        await kakaoAuthRepo.logout(); // 사용자 없음 시 로그아웃
      } catch (e) {
        print("authCheck 중 오류 발생: $e");
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
          print("사용자가 서버에 존재하지 않습니다: $e");
          await kakaoAuthRepo.logout(); // 사용자 없음 시 로그아웃
        } catch (e) {
          print("fetchAndSaveUserInfo 중 오류 발생: $e");
          status(AuthenticationStatus.unknown);
          Future.microtask(() => Get.offNamed('/login'));
        }
      }
    } else {
      // 카카오 인증을 사용하지 않거나 accessToken이 없는 경우 로그인 페이지로 이동
      status(AuthenticationStatus.unknown);
      Future.microtask(() => Get.offNamed('/login'));
    }
  }

  void reload() {
    if (isUsingKakaoAuth.value) {
      _userStateChangedEvent(userModel.value);
    }
  }

  // _userStateChangedEvent 수정: nickname 확인 추가
  void _userStateChangedEvent(NeroUser? user) async {
    if (user == null) {
      status(AuthenticationStatus.unknown);
    } else {
      var result = await kakaoUserRepo.findUserOne(user.userId!);
      if (result == null) {
        // 유저가 존재하지 않음
        status(AuthenticationStatus.unAuthenticated);
        Future.microtask(() => Get.toNamed('/signup')); // 빌드 후 라우팅
      } else {
        // 유저가 존재함, nickname 확인
        if (result.nickname == null || result.nickname!.isEmpty) {
          // nickname이 없음
          status(AuthenticationStatus.unAuthenticated);
          Future.microtask(() => Get.toNamed('/signup')); // 빌드 후 라우팅
        } else {
          // 유저 인증 완료
          status(AuthenticationStatus.authentication);
          userModel.value = result;
          Future.microtask(() => Get.toNamed('/home')); // 빌드 후 라우팅
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
        Get.snackbar(
          '성공',
          '회원 탈퇴가 완료되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        '오류',
        '회원 탈퇴에 실패했습니다: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // 카카오 로그인 처리 메서드 수정
  Future<void> handleKakaoLogin() async {
    try {
      final response = await kakaoAuthRepo.signUpWithKakao();
      bool needsSignup = response['needsSignup'] ?? false;

      if (needsSignup) {
        // 신규 사용자
        Get.offNamed('/signup');
      } else {
        // 기존 사용자
        Get.offNamed('/home');
      }
    } catch (e) {
      print("handleKakaoLogin 중 오류 발생: $e");
      // 오류 발생 시 로그인 페이지로 이동
      Get.offNamed('/login');
    }
  }
}
