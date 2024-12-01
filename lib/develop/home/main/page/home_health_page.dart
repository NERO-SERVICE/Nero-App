import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/health/controller/health_controller.dart';
import 'package:nero_app/develop/health/page/health_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class HomeHealthPage extends StatelessWidget {
  final HealthController _healthController = Get.put(HealthController());
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  HomeHealthPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'HomeHealthPage',
      screenClass: 'HomeHealthPage',
    );
    _healthController.initialize();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목과 더보기 버튼
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '건강기능(Beta)',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => HealthPage());
                },
                child: Text(
                  '더보기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xffD0EE17),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            '국민체육진흥공단의 데이터로\n내 일상을 관리할 수 있어요',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Color(0xffD9D9D9),
            ),
          ),
        ),
      ],
    );
  }
}
