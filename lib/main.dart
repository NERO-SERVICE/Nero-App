import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:nero_app/drf/clinic/controller/drf_clinic_controller.dart';
import 'package:nero_app/drf/common/controller/drf_bottom_nav_controller.dart';
import 'package:nero_app/drf/product/repository/drf_product_repository.dart';
import 'package:nero_app/drf/user/model/drf_user_model.dart';
import 'package:nero_app/drf/user/repository/drf_authentication_repository.dart';
import 'package:nero_app/drf/user/repository/drf_user_repository.dart';
import 'package:nero_app/route/drf_routes.dart';
import 'package:nero_app/route/firebase_routes.dart';
import 'package:nero_app/src/app.dart';
import 'package:nero_app/src/chat/controller/chat_list_controller.dart';
import 'package:nero_app/src/chat/repository/chat_repository.dart';
import 'package:nero_app/src/common/controller/authentication_controller.dart'
    as firebase_auth_cont;
import 'package:nero_app/src/common/controller/bottom_nav_controller.dart';
import 'package:nero_app/src/common/controller/common_layout_controller.dart';
import 'package:nero_app/src/common/controller/data_load_controller.dart';
import 'package:nero_app/src/common/repository/cloud_firebase_repository.dart';
import 'package:nero_app/src/product/repository/product_repository.dart';
import 'package:nero_app/src/splash/controller/splash_controller.dart';
import 'package:nero_app/src/user/repository/authentication_repository.dart'
    as firebase_auth;
import 'package:nero_app/src/user/repository/user_repository.dart'
    as firebase_user_repo;
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  KakaoSdk.init(nativeAppKey: dotenv.env['kakaoAppKey']);
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _lastRoute = '/splash';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadLastRoute();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveLastRoute();
    }
  }

  Future<void> _loadLastRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastRoute = prefs.getString('lastRoute') ?? '/splash';
    });
  }

  Future<void> _saveLastRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastRoute', _lastRoute);
  }

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    return GetMaterialApp(
      title: '네로 프로젝트',
      initialRoute: _lastRoute,
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
        // // 카카오 인증
        var kakaoAuthRepo = Get.put(DrfAuthenticationRepository());
        var kakaoUserRepo = Get.put(
            DrfUserRepository(drfAuthenticationRepository: kakaoAuthRepo));
        Get.put(DrfBottomNavController());
        Get.put(DrfProductRepository());
        Get.put(DrfUserModel());
        Get.put(DrfClinicController());

        // 구글 인증
        var firebaseAuthRepo =
            firebase_auth.AuthenticationRepository(FirebaseAuth.instance);
        var firebaseUserRepo = firebase_user_repo.UserRepository(db);
        Get.put<firebase_auth.AuthenticationRepository>(firebaseAuthRepo);
        Get.put<firebase_user_repo.UserRepository>(firebaseUserRepo);
        Get.put(ProductRepository(db));
        Get.put(ChatRepository(db));
        Get.put(BottomNavController());
        Get.put(CommonLayoutController());
        Get.put(SplashController());
        Get.put(DataLoadController());
        Get.put(firebase_auth_cont.AuthenticationController(
          firebaseAuthRepo,
          firebaseUserRepo,
          kakaoAuthRepo,
          kakaoUserRepo,
          // apiService,
        ));
        Get.put(CloudFirebaseRepository(FirebaseStorage.instance));
        Get.lazyPut<ChatListController>(
          () => ChatListController(
            Get.find<ChatRepository>(),
            Get.find<ProductRepository>(),
            Get.find<firebase_user_repo.UserRepository>(),
            Get.find<firebase_auth_cont.AuthenticationController>()
                    .userModel
                    .value
                    .uid ??
                '',
          ),
          fenix: true,
        );
      }),
      getPages: [
        GetPage(name: '/', page: () => const App()),
        ...FirebaseRoutes.routes, // Firebase 라우트
        ...DrfRoutes.routes, // DRF 라우트
      ],
    );
  }
}
