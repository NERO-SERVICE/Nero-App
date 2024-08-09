import 'package:get/get.dart';
import 'package:nero_app/drf/api_service.dart';
import 'package:nero_app/drf/user/model/drf_user_model.dart';
import 'package:nero_app/drf/user/repository/drf_authentication_repository.dart';
import 'package:nero_app/drf/user/repository/drf_user_repository.dart';
import 'package:nero_app/src/user/model/user_model.dart';
import 'package:nero_app/src/user/repository/authentication_repository.dart'
as firebase_auth;
import 'package:nero_app/src/user/repository/user_repository.dart'
as firebase_user_repo;

import '../enum/authentication_status.dart';

class AuthenticationController extends GetxController {
  final firebase_auth.AuthenticationRepository firebaseAuthRepo;
  final firebase_user_repo.UserRepository firebaseUserRepository;
  final DrfAuthenticationRepository kakaoAuthRepo;
  final DrfUserRepository kakaoUserRepo;
  final ApiService apiService;

  AuthenticationController(
      this.firebaseAuthRepo,
      this.firebaseUserRepository,
      this.kakaoAuthRepo,
      this.kakaoUserRepo,
      this.apiService,
      );

  Rx<AuthenticationStatus> status = AuthenticationStatus.init.obs;
  Rx<UserModel> userModel = const UserModel().obs;
  Rx<DrfUserModel> drfUserModel = const DrfUserModel().obs;
  RxBool isUsingKakaoAuth = true.obs;
  RxBool isUsingGoogleAuth = true.obs;

  void authCheck() async {
    firebaseAuthRepo.user.listen((user) {
      print("---authentication_controller/authCheck/firebase---");
      _userStateChangedEvent(user);
    });

    // Kakao authentication check
    if (isUsingKakaoAuth.value) {
      print("---authentication_controller/authCheck/isUsingKakaoAuth---");
      var kakaoUser = kakaoAuthRepo.user.value;
      if (kakaoUser != null) {
        _drfUserStateChangedEvent(kakaoUser);
      }
    }
  }

  void reload() {
    print("---authentication_controller/reload---");
    if (isUsingKakaoAuth.value) {
      _drfUserStateChangedEvent(drfUserModel.value);
    } else {
      _userStateChangedEvent(userModel.value);
    }
  }

  void _userStateChangedEvent(UserModel? user) async {
    if (user == null) {
      print("---authentication_controller/authCheck/_userStateChangedEvent => unknown---");
      status(AuthenticationStatus.unknown);
    } else {
      var result = await firebaseUserRepository.findUserOne(user.uid!);
      if (result == null) {
        print("---authentication_controller/authCheck/_userStateChangedEvent => unAuthenticated---");
        userModel(user);
        status(AuthenticationStatus.unAuthenticated);
      } else {
        print("---authentication_controller/authCheck/_userStateChangedEvent => authentication---");
        status(AuthenticationStatus.authentication);
        userModel(result);
      }
    }
  }

  void _drfUserStateChangedEvent(DrfUserModel? user) async {
    if (user == null) {
      print("---authentication_controller/authCheck/drf_userStateChangedEvent => unknown---");
      status(AuthenticationStatus.unknown);
    } else {
      var result = await kakaoUserRepo.findUserOne(user.uid!);
      if (result == null) {
        print("---authentication_controller/authCheck/drf_userStateChangedEvent => unAuthenticated---");
        drfUserModel(user);
        status(AuthenticationStatus.unAuthenticated);
      } else {
        print("---authentication_controller/authCheck/drf_userStateChangedEvent => unAuthenticated---");
        status(AuthenticationStatus.authentication);
        drfUserModel(result);
        Get.toNamed('/drf/home', arguments: drfUserModel.value);
      }
    }
  }

  void logout() async {
    if (isUsingKakaoAuth.value) {
      await kakaoAuthRepo.logout();
      drfUserModel.value = const DrfUserModel();
    } else {
      await firebaseAuthRepo.logout();
      userModel.value = const UserModel();
    }
    status(AuthenticationStatus.unknown);
  }


  Future<void> loginWithGoogle() async {
    isUsingGoogleAuth.value = false;
    // Add your Google login logic here
  }
}
