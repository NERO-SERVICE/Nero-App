import 'package:get/get.dart';

import '../../user/controller/user_repository.dart';
import '../../user/model/user_model.dart';
import '../../user/repository/authentication_repository.dart';
import '../enum/authentication_status.dart';

class AuthenticationController extends GetxController {
  AuthenticationController(
      this._authenticationRepository, this._userRepository);

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  RxBool isLogined = false.obs;
  Rx<AuthenticationStatus> status = AuthenticationStatus.init.obs;
  Rx<UserModel> userModel = const UserModel().obs;

  void authCheck() async {
    _authenticationRepository.user.listen((user) {
      _userStateChangedEvent(user);
    });
  }

  void _userStateChangedEvent(UserModel? user) async {
    if (user == null) {
      status(AuthenticationStatus.unknown);
    } else {
      var result = await _userRepository.findUserOne(user.uid!);
      if (result == null) {
        userModel(user);
        status(AuthenticationStatus.unAuthenticated);
      } else {
        status(AuthenticationStatus.authentication);
        userModel(result);
      }
    }
  }

  void logout() async {
    await _authenticationRepository.logout();
  }
}
