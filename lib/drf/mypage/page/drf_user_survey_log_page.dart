import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nero_app/drf/mypage/controller/drf_montly_check_controller.dart';
import 'package:nero_app/drf/todaylog/model/drf_survey_response.dart';
import 'package:get/get.dart';

class DrfUserSurveyLogPage extends StatelessWidget {
  final DateTime selectedDate;

  DrfUserSurveyLogPage({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final DrfMonthlyCheckController controller = Get.put(DrfMonthlyCheckController());

    controller.fetchPreviousSurveyAnswers(selectedDate);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/today_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: kToolbarHeight + 29),
                  Text(
                    '하루 설문',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 13),
                  Text(
                    '이전에 제출한 설문 기록입니다',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.surveyResponses.length,
                    itemBuilder: (context, index) {
                      final DrfSurveyResponse response = controller.surveyResponses[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            response.question.questionText,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 40),
                          _buildCircularButtons(context, response: response),
                          SizedBox(height: 70),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCircularButtons(
      BuildContext context, {
        required DrfSurveyResponse response,
      }) {
    final options = ['매우나쁨', '나쁨', '보통', '좋음', '매우좋음'];
    final int selectedOptionIndex = int.parse(response.answer) - 1;

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: List.generate(options.length, (optionIndex) {
        final isSelected = optionIndex == selectedOptionIndex;
        return GestureDetector(
          onTap: () {},
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isSelected ? Color(0xff1C1B1B) : Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              options[optionIndex],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        );
      }),
    );
  }
}
