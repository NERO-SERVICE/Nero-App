import 'package:get/get.dart';
import '../../repository/authentication_repository.dart';

class LoginController extends GetxController {
  final AuthenticationRepository authenticationRepository;

  LoginController(this.authenticationRepository);

  void googleLogin() async {
    await authenticationRepository.signInWithGoogle();
  }
}
