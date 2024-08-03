import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/src/app.dart';
import 'package:nero_app/src/common/controller/authentication_controller.dart';
import 'package:nero_app/src/common/controller/bottom_nav_controller.dart';
import 'package:nero_app/src/common/controller/data_load_controller.dart';
import 'package:nero_app/src/common/repository/cloud_firebase_repository.dart';
import 'package:nero_app/src/product/repository/product_repository.dart';
import 'package:nero_app/src/product/write/controller/product_write_controller.dart';
import 'package:nero_app/src/product/write/page/product_write_page.dart';
import 'package:nero_app/src/root.dart';
import 'package:nero_app/src/splash/controller/splash_controller.dart';
import 'package:nero_app/src/user/controller/user_repository.dart';
import 'package:nero_app/src/user/login/controller/login_controller.dart';
import 'package:nero_app/src/user/login/page/login_page.dart';
import 'package:nero_app/src/user/signup/controller/signup_controller.dart';
import 'package:nero_app/src/user/signup/page/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'src/user/repository/authentication_repository.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    return GetMaterialApp(
      title: '네로 프로젝트',
      initialRoute: '/',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Color(0xff212123),
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xff212123),
      ),
      initialBinding: BindingsBuilder(() {
        var authenticationRepository =
            AuthenticationRepository(FirebaseAuth.instance);
        var user_repository = UserRepository(db);
        Get.put(authenticationRepository);
        Get.put(user_repository);
        Get.put(ProductRepository(db));
        Get.put(BottomNavController());
        Get.put(UserRepository(db));
        Get.put(SplashController());
        Get.put(DataLoadController());
        Get.put(AuthenticationController(
          authenticationRepository,
          user_repository,
        ));
        Get.put(CloudFirebaseRepository(FirebaseStorage.instance));
      }),
      getPages: [
        GetPage(name: '/', page: () => const App()),
        GetPage(name: '/home', page: () => const Root()),
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          binding: BindingsBuilder(
            () {
              Get.lazyPut<LoginController>(
                  () => LoginController(Get.find<AuthenticationRepository>()));
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
              Get.put(
                ProductWriteController(
                  Get.find<AuthenticationController>().userModel.value,
                  Get.find<ProductRepository>(),
                  Get.find<CloudFirebaseRepository>(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
