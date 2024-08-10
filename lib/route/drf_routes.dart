import 'package:get/get.dart';
import 'package:nero_app/drf/root.dart';
import 'package:nero_app/src/common/controller/bottom_nav_controller.dart';
import 'package:nero_app/src/init/page/init_start_page.dart';
import 'package:nero_app/src/splash/controller/splash_controller.dart';
import 'package:nero_app/src/splash/page/splash_page.dart';

class DrfRoutes {
  static final routes = [
    GetPage(
      name: '/drf',
      page: () => const SplashPage(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: '/drf/init',
      page: () => InitStartPage(
        onStart: () {
          Get.toNamed('/drf'); // InitStartPage 완료 후 SplashPage로 이동
        },
      ),
    ),
    GetPage(
      name: '/drf/root',
      page: () => const Root(),
      binding: BindingsBuilder(() {
        Get.lazyPut<BottomNavController>(() => BottomNavController());
      }),
    ),
  ];
}
