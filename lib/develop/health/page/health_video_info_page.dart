import 'package:flutter/material.dart';
import 'package:nero_app/app_colors.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/health/page/health_video_page.dart';

class HealthVideoInfoPage extends StatelessWidget {
  const HealthVideoInfoPage({Key? key}) : super(key: key);

  void _navigateToVideoPage(BuildContext context, String sportsStep) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HealthVideoPage(sportsStep: sportsStep),
      ),
    );
  }

  Widget _healthTitle({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xffD9D9D9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton(
      BuildContext context, {
        required String labelTop,
        required String labelBottom,
        required VoidCallback onPressed,
        EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: const Color(0xff323232),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labelTop,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xffFFFFFF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labelBottom,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xffD0EE17),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDetailAppBar(title: '운동 동영상(Beta)'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/develop/health_logo.png',
                width: 311,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                '운동 동영상 추천에 활용되는 자료는\n국민체육진흥공단에서 제공해주었습니다.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: AppColors.primaryTextColor,
                ),
              ),
            ),
            const SizedBox(height: 60),
            // Start-aligned Health Title
            _healthTitle(
              title: '운동 동영상 추천',
              content: '국민체육진흥공단과 함께\n건강한 운동습관을 만들어보아요',
            ),
            const SizedBox(height: 20),
            _buildCustomButton(
              context,
              labelTop: '준비운동',
              labelBottom: '다치지 않게 가볍게 시작해요',
              onPressed: () => _navigateToVideoPage(context, '준비운동'),
            ),
            _buildCustomButton(
              context,
              labelTop: '본운동',
              labelBottom: '이제 본격적으로 달려볼까요?',
              onPressed: () => _navigateToVideoPage(context, '본운동'),
            ),
            _buildCustomButton(
              context,
              labelTop: '마무리운동',
              labelBottom: '끝까지 마무리를 지어요',
              onPressed: () => _navigateToVideoPage(context, '마무리운동'),
            ),
            const SizedBox(height: 20), // Extra spacing at the bottom
          ],
        ),
      ),
    );
  }
}
