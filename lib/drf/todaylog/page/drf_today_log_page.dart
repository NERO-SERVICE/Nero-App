import 'package:flutter/material.dart';
import 'package:nero_app/drf/todaylog/controller/drf_today_controller.dart';
import 'package:provider/provider.dart';

class DrfTodayLogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrfTodayController()..fetchSurveyQuestions(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
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
            Consumer<DrfTodayController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
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
                        '오늘 당신의 하루가 어땠는지\n저에게 알려주세요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xffD9D9D9),
                        ),
                      ),
                      SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true, // ScrollView 내에서 ListView가 작동할 수 있도록 설정
                        physics: NeverScrollableScrollPhysics(), // ListView 자체의 스크롤을 비활성화
                        itemCount: controller.surveyQuestions.length,
                        itemBuilder: (context, index) {
                          final question = controller.surveyQuestions[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                question.questionText,
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 40),
                              _buildCircularButtons(
                                context,
                                controller: controller,
                                index: index,
                              ),
                              SizedBox(height: 70),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 26),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller.submitSurveyResponses();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('설문이 제출되었습니다.')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 66.0),
                          ),
                          child: Text(
                            '제출하기',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 25,
                              color: Color(0xffD9D9D9),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 26),
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
        required DrfTodayController controller,
        required int index,
      }) {
    final options = ['매우나쁨', '나쁨', '보통', '좋음', '매우좋음'];

    return Wrap(
      spacing: 8.0, // 버튼들 간의 간격
      runSpacing: 8.0, // 줄 바꿈 시 간격
      alignment: WrapAlignment.center,
      children: List.generate(options.length, (optionIndex) {
        final isSelected =
            controller.surveyAnswers[index] == (optionIndex + 1).toString();
        return GestureDetector(
          onTap: () {
            final answer = (optionIndex + 1).toString();
            controller.updateSurveyAnswer(index, answer);
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color:
              isSelected ? Color(0xff1C1B1B) : Colors.grey.withOpacity(0.3),
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
