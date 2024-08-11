import 'package:get/get.dart';
import 'package:nero_app/drf/common/controller/drf_bottom_nav_controller.dart';
import 'package:nero_app/drf/drf_root.dart';
import 'package:nero_app/drf/product/detail/controller/drf_product_detail_controller.dart';
import 'package:nero_app/drf/product/detail/page/drf_product_detail_page.dart';
import 'package:nero_app/drf/product/repository/drf_product_repository.dart';
import 'package:nero_app/drf/user/model/drf_user_model.dart';
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
    // GetPage(name: '/drf/home', page: () => DrfHomePage()),
    GetPage(
      name: '/drf/init',
      page: () => InitStartPage(
        onStart: () {
          Get.toNamed('/drf'); // InitStartPage 완료 후 SplashPage로 이동
        },
      ),
    ),
    GetPage(
      name: '/drf/home',
      page: () => const DrfRoot(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DrfBottomNavController>(() => DrfBottomNavController());
      }),
    ),
    GetPage(
      name: '/drf/product/detail/:id',
      page: () => DrfProductDetailPage(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut<DrfProductDetailController>(
            () => DrfProductDetailController(
              Get.find<DrfProductRepository>(),
              Get.find<DrfUserModel>(),
            ),
          );
        },
      ),
    ),
  ];
}
