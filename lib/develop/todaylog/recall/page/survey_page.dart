import 'package:flutter/material.dart';
import 'package:nero_app/develop/todaylog/recall/controller/recall_controller.dart';
import 'package:provider/provider.dart';

import '../../../common/components/custom_detail_app_bar.dart';

class SurveyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecallController()..fetchSurveyQuestions(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomDetailAppBar(title: '하루 설문'),
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
            Consumer<RecallController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.surveyQuestions.isEmpty) {
                  return Center(
                    child: Text(
                      '설문이 현재 없습니다.',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xffD9D9D9),
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: kToolbarHeight + 29),
                      Text(
                        '오늘 당신의 하루가 어땠는지\n저에게 알려주세요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                      SizedBox(height: 60),
                      Column(
                        children: List.generate(
                            controller.surveyQuestions.length, (index) {
                          final question = controller.surveyQuestions[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                question.questionText,
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 18),
                              _buildCircularButtons(
                                context,
                                controller: controller,
                                index: index,
                              ),
                              SizedBox(height: 60),
                            ],
                          );
                        }),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller.submitSurveyResponses();
                            final snackBar = SnackBar(
                              content: Text('설문이 제출되었습니다.'),
                              duration: Duration(seconds: 1),
                            );

                            final snackBarController =
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                            await snackBarController.closed;
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 17, horizontal: 72.0),
                          ),
                          child: Text(
                            '제출하기',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xffFFFFFF),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularButtons(
    BuildContext context, {
    required RecallController controller,
    required int index,
  }) {
    final options = ['매우나쁨', '나쁨', '보통', '좋음', '매우좋음'];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(options.length, (optionIndex) {
        final isSelected =
            controller.surveyAnswers[index] == (optionIndex + 1).toString();
        return GestureDetector(
          onTap: () {
            final answer = (optionIndex + 1).toString();
            controller.updateSurveyAnswer(index, answer);
          },
          child: Container(
            width: 70,
            height: 30,
            margin: const EdgeInsets.only(bottom: 5.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(0xff1C1B1B)
                  : Color(0xff000000).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              options[optionIndex],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: isSelected
                    ? Color(0xffFFFFFF)
                    : Color(0xffFFFFFF).withOpacity(0.8),
              ),
            ),
          ),
        );
      }),
    );
  }
}
