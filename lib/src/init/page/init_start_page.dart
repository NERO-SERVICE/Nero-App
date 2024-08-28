import 'package:flutter/material.dart';
import 'package:nero_app/src/common/components/btn.dart';

import '../../common/components/app_font.dart';

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

  Widget _contentView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          const Text(
            'By Your Side',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '오늘도 한발짝\n스스로 돌아보며\n네로(Nero)',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 44,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _startBtn() {
    return Positioned(
      bottom: 96,
      left: 32,
      right: 32,
      child: Btn(
        color: const Color(0xffD0EE17),
        onTap: onStart,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Center(
          child: Text(
            '시작하기',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundView(),
          _contentView(),
          _startBtn(),
        ],
      ),
    );
  }
}
