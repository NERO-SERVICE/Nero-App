import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:nero_app/background_layout.dart';
import 'package:nero_app/develop/common/controller/bottom_nav_controller.dart';
import 'package:nero_app/develop/common/controller/common_layout_controller.dart';
import 'package:nero_app/develop/common/controller/data_load_controller.dart';
import 'package:nero_app/develop/fastmemo/repository/fastmemo_repository.dart';
import 'package:nero_app/develop/splash/controller/splash_controller.dart';
import 'package:nero_app/develop/todaylog/clinic/controller/clinic_controller.dart';
import 'package:nero_app/develop/user/controller/authentication_controller.dart';
import 'package:nero_app/develop/user/model/nero_user.dart';
import 'package:nero_app/develop/user/repository/authentication_repository.dart';
import 'package:nero_app/develop/user/repository/user_repository.dart';
import 'package:nero_app/route/develop_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'develop/app.dart';
import 'develop/dio_service.dart';
import 'develop/home/information/controller/information_controller.dart';
import 'develop/login/controller/login_controller.dart';
import 'firebase_options.dart';

late SharedPreferences prefs;
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  KakaoSdk.init(nativeAppKey: dotenv.env['kakaoAppKey']);
  prefs = await SharedPreferences.getInstance();
  await initializeDateFormatting();
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
    return GetMaterialApp(
      title: '네로 프로젝트',
      initialRoute: _lastRoute,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF202020),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put<DioService>(DioService());
        var kakaoAuth = Get.put(AuthenticationRepository());
        Get.put(UserRepository(authenticationRepository: Get.find()));
        Get.put(AuthenticationController(
          Get.find(),
          Get.find(),
        ));
        Get.put(SplashController());
        Get.put(DataLoadController());
        Get.put(NeroUser());
        Get.put(CommonLayoutController());
        Get.put(ClinicController());
        Get.put(FastmemoRepository());
        Get.put(LoginController(kakaoAuth));
        Get.put(BottomNavController());
        Get.put(InformationController());
      }),
      getPages: [
        GetPage(
          name: '/',
          page: () => BackgroundLayout(
            child: const App(),
          ),
        ),
        ...DevelopRoutes.routes,
      ],
    );
  }
}
