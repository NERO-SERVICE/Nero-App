import 'package:flutter/material.dart';

import '../../common/components/custom_loading_indicator.dart';

class InitStartPage extends StatelessWidget {
  final Function() onStart;

  const InitStartPage({super.key, required this.onStart});

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
