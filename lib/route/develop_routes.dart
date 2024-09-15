import 'package:get/get.dart';
import 'package:nero_app/develop/login/controller/login_controller.dart';
import 'package:nero_app/develop/login/page/login_page.dart';
import 'package:nero_app/develop/signup/controller/sign_up_controller.dart';
import 'package:nero_app/develop/signup/page/sign_up_page.dart';
import 'package:nero_app/develop/user/repository/authentication_repository.dart';

class DevelopRoutes {
  static final routes = [
    GetPage(
      name: '/signup',
      page: () => const SignUpPage(),
      binding: BindingsBuilder(
        () {
          Get.create<SignUpController>(() => SignUpController());
        },
      ),
    ),
    GetPage(
      name: '/login',
      page: () => const LoginPage(),
      binding: BindingsBuilder(
            () {
          Get.lazyPut<LoginController>(() => LoginController(
              Get.find<AuthenticationRepository>()));
        },
      ),
    ),
  ];
}
