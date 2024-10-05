import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import '../../common/components/custom_loading_indicator.dart';

class InitStartPage extends StatelessWidget {
  final Function() onStart;

  InitStartPage({super.key, required this.onStart});
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Widget _backgroundView() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/login_background.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'InitStartPage',
      screenClass: 'InitStartPage',
    );
    return Scaffold(
      body: Stack(
        children: [
          _backgroundView(),
          Center(child: CustomLoadingIndicator()),
        ],
      ),
    );
  }
}
