import 'package:get/get.dart';
import 'package:nero_app/drf/user/repository/drf_authentication_repository.dart';
import 'package:nero_app/src/chat/controller/chat_controller.dart';
import 'package:nero_app/src/chat/page/chat_list_page.dart';
import 'package:nero_app/src/chat/page/chat_page.dart';
import 'package:nero_app/src/chat/repository/chat_repository.dart';
import 'package:nero_app/src/common/controller/authentication_controller.dart';
import 'package:nero_app/src/common/repository/cloud_firebase_repository.dart';
import 'package:nero_app/src/home/controller/home_controller.dart';
import 'package:nero_app/src/product/detail/controller/product_detail_controller.dart';
import 'package:nero_app/src/product/detail/page/product_detail_view.dart';
import 'package:nero_app/src/product/repository/product_repository.dart';
import 'package:nero_app/src/product/write/controller/product_write_controller.dart';
import 'package:nero_app/src/product/write/page/product_write_page.dart';
import 'package:nero_app/src/root.dart';
import 'package:nero_app/src/user/login/controller/login_controller.dart';
import 'package:nero_app/src/user/login/page/login_page.dart';
import 'package:nero_app/src/user/repository/authentication_repository.dart';
import 'package:nero_app/src/user/repository/user_repository.dart';
import 'package:nero_app/src/user/signup/controller/signup_controller.dart';
import 'package:nero_app/src/user/signup/page/signup_page.dart';

import '../src/app.dart';

class FirebaseRoutes {
  static final routes = [
    GetPage(name: '/', page: () => const App()),
    GetPage(
        name: '/home',
        page: () => const Root(),
        binding: BindingsBuilder(() {
          Get.put(HomeController(Get.find<ProductRepository>()));
        })),
    GetPage(name: '/signup', page: () => const SignupPage()),
    GetPage(
      name: '/login',
      page: () => const LoginPage(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut<LoginController>(() => LoginController(
              Get.find<AuthenticationRepository>(),
              Get.find<DrfAuthenticationRepository>()));
        },
      ),
    ),
    GetPage(
      name: '/signup/:uid',
      page: () => const SignupPage(),
      binding: BindingsBuilder(
        () {
          Get.create<SignupController>(() => SignupController(
              Get.find<UserRepository>(), Get.parameters['uid'] as String));
        },
      ),
    ),
    GetPage(
      name: '/product/write',
      page: () => ProductWritePage(),
      binding: BindingsBuilder(
        () {
          Get.put(ProductWriteController(
            Get.find<AuthenticationController>().userModel.value,
            Get.find<ProductRepository>(),
            Get.find<CloudFirebaseRepository>(),
          ));
        },
      ),
    ),
    GetPage(
      name: '/product/detail/:docId',
      page: () => ProductDetailView(),
      binding: BindingsBuilder(
        () {
          Get.put(ProductDetailController(
            Get.find<ProductRepository>(),
            Get.find<ChatRepository>(),
            Get.find<AuthenticationController>().userModel.value,
          ));
        },
      ),
    ),
    GetPage(
      name: '/chat/:docId/:ownerUid/:customerUid',
      page: () => const ChatPage(),
      binding: BindingsBuilder(
        () {
          Get.put(ChatController(
            Get.find<ChatRepository>(),
            Get.find<UserRepository>(),
            Get.find<ProductRepository>(),
          ));
        },
      ),
    ),
    GetPage(
      name: '/chat-list',
      page: () => const ChatListPage(useBackBtn: true),
    )
  ];
}
