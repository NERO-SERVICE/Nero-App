import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:nero_app/background_layout.dart';
import 'package:nero_app/develop/common/controller/common_layout_controller.dart';
import 'package:nero_app/develop/common/controller/data_load_controller.dart';
import 'package:nero_app/develop/splash/controller/splash_controller.dart';
import 'package:nero_app/develop/user/controller/authentication_controller.dart';
import 'package:nero_app/develop/user/model/nero_user.dart';
import 'package:nero_app/develop/user/repository/authentication_repository.dart';
import 'package:nero_app/develop/user/repository/user_repository.dart';
import 'package:nero_app/push_notification.dart';
import 'package:nero_app/route/develop_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'develop/app.dart';
import 'firebase_options.dart';

late SharedPreferences prefs;
final navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    print("Notification Received!");
  }
}

Future<void> setupInteractedMessage() async {
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

void _handleMessage(RemoteMessage message) {
  Future.delayed(const Duration(seconds: 1), () {
    navigatorKey.currentState!.pushNamed("/message", arguments: message);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PushNotification.init();
  PushNotification.localNotiInit();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 포그라운드 알림 수신 리스너
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print('Got a message in foreground');
    if (message.notification != null) {
      PushNotification.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData);
    }
  });
  setupInteractedMessage();

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
        scaffoldBackgroundColor: const Color(0xFF1C1B1B),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(SplashController());
        Get.put(DataLoadController());
        var kakaoAuthRepo = Get.put(AuthenticationRepository());
        var kakaoUserRepo =Get.put(UserRepository(authenticationRepository: kakaoAuthRepo));
        Get.put(AuthenticationController(
          kakaoAuthRepo ,
          kakaoUserRepo,
        ));
        Get.put(NeroUser());
        Get.put(CommonLayoutController());
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
