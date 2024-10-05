import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:nero_app/develop/init/page/init_start_page.dart';
import 'package:nero_app/develop/splash/page/splash_page.dart';
import 'package:nero_app/main.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late bool isInitStarted;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    isInitStarted = prefs.getBool('isInitStarted') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'AppStart',
      screenClass: 'AppStart',
    );
    return isInitStarted
        ? InitStartPage(
      onStart: () {
        setState(() {
          isInitStarted = false;
        });
        prefs.setBool('isInitStarted', isInitStarted);
      },
    )
        : SplashPage();
  }
}
