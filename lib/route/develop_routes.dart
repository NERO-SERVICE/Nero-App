import 'package:get/get.dart';
import 'package:nero_app/develop/common/controller/bottom_nav_controller.dart';
import 'package:nero_app/develop/login/page/login_page.dart';
import 'package:nero_app/develop/memories/page/memories_page.dart';
import 'package:nero_app/develop/root.dart';
import 'package:nero_app/develop/signup/controller/sign_up_controller.dart';
import 'package:nero_app/develop/signup/page/sign_up_page.dart';
import 'package:nero_app/develop/tutorial/page/tutorial_page.dart';

class DevelopRoutes {
  static final routes = [
    GetPage(
      name: '/home',
      page: () => Root(),
      binding: BindingsBuilder(() {
        Get.lazyPut<BottomNavController>(() => BottomNavController());
      }),
    ),
    GetPage(
      name: '/signup',
      page: () => const SignUpPage(),
      binding: BindingsBuilder(
        () {
          Get.create<SignUpController>(() => SignUpController());
        },
      ),
    ),
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(
      name: '/memories',
      page: () => const MemoriesPage(),
    ),
    GetPage(
      name: '/tutorial',
      page: () => TutorialPage(),
    ),
  ];
}
